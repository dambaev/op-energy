# derivations for node.js-based applications in NixOS are supposed to be generated by node2nix
{ stdenv, pkgs, fetchurl, fetchzip
}:
let
  source = ../.;

  backend_derivation =
  let
    nodeDependencies = ( pkgs.callPackage ./backend/op-energy-backend.nix {}).shell.nodeDependencies;
    initial_script = pkgs.writeText "initial_script.sql" ''
      CREATE USER IF NOT EXISTS mempool@localhost IDENTIFIED BY 'mempool';
      ALTER USER mempool@localhost IDENTIFIED BY 'mempool';
      flush privileges;
    '';
  in stdenv.mkDerivation {
    name = "op-energy-backend";

    src = source;
    buildInputs = with pkgs;
    [ nodejs
      python
      git
    ];
    preConfigure = "cd backend";
    buildPhase = ''
      export PATH="${nodeDependencies}/bin:$PATH"
      # if there is no HOME var, then npm will try to write to root dir, for which it has no write permissions to, so we provide HOME var
      export HOME=./home

      # and create this dir as well
      mkdir $HOME

      # copy contents of the node_modules, following symlinks, such that current build/install will be able to modify local copies
      cp -r ${nodeDependencies}/lib/node_modules ./node_modules
      patchShebangs ./node_modules/typescript/bin/tsc
      # allow user to write. the build will try to write into ./node_modules/@types/node
      chmod -R u+w ./node_modules
      # we already have populated node_modules dir, so we don't need to run `npm install`
      npm run build
    '';
    installPhase = ''
      mkdir -p $out/backend
      cp -r ./node_modules $out/backend
      cp -r dist $out/backend
      cp package.json $out/backend/ # needed for `npm run start`
      cp ${initial_script} $out/backend/initial_script.sql # script, which should setup DB user
    '';
    patches = [
    ];
  };
  # frontend_derivation is a function, because it needs 2 variables, which affect the build result.
  frontend_derivation = { testnet_enabled ? false, signet_enabled ? false}:
  let
    # those repos are required for frontend's step which tries to download some assets during build.
    poolsJsonUrl = fetchzip {
      url = "https://github.com/btccom/Blockchain-Known-Pools/archive/349c8d907ad9293661c804684782696dcb48d3b4.zip";
      sha256 = "1sqragdf7wbzmrwqz82j9306v9czj6xxpfg6x8c1zy0a6yhzf2fl";
    };
    assetsJsonUrl = fetchzip {
      url = "https://github.com/mempool/asset_registry_db/archive/689456ad4d653055eb690dca282b9f8faab1e873.zip";
      sha256 = "0lk377a9kdciwj1w6aik3307zmp64i0sc8g26fmqzm4wfn198n8j";
    };
    assetsTestnet = fetchzip {
      url = "https://github.com/Blockstream/asset_registry_testnet_db/archive/ede5ad5376e178e3da9b21c50fc9babb8fbb6372.zip";
      sha256 = "0nz7ads18bmjf5s2a12y73h4vhq15xbbcybdyypyrvkvhch7f27x";
    };

    nodeDependencies = ( pkgs.callPackage ./frontend/op-energy-frontend.nix {}).shell.nodeDependencies;
    testnet_enabled_str =
      if testnet_enabled
      then "true"
      else "false";
    signet_enabled_str =
      if signet_enabled
      then "true"
      else "false";
    # this is a frontend build-time config: basically, we are either enable or disable parts of frontend
    frontend_config = pkgs.writeText "mempool-frontend-config.json" ''
      {
        "TESTNET_ENABLED": ${testnet_enabled_str},
        "SIGNET_ENABLED": ${signet_enabled_str},
        "WITHOUT_MINING_POOL_LOGOS": true
      }
    '';
  in
    stdenv.mkDerivation {
    name = "op-energy-frontend";

    src = source;
    buildInputs = with pkgs;
    [ nodejs
      python
      poolsJsonUrl
      assetsJsonUrl
      assetsTestnet
      rsync
      git
    ];
    preConfigure = ''
      cd frontend
      # deploy frontend build config
      cp ${frontend_config} mempool-frontend-config.json
      # deploying predownloaded assets, so install will not attemp to download them
      mkdir -p dist/mempool/browser/en-US/resources/
      mkdir -p src/resources
      cp ${poolsJsonUrl}/pools.json dist/mempool/browser/en-US/resources/
      cp ${assetsJsonUrl}/index.json dist/mempool/browser/en-US/resources/assets.json
      cp ${assetsJsonUrl}/index.minimal.json dist/mempool/browser/en-US/resources/assets.minimal.json
      cp ${poolsJsonUrl}/pools.json src/resources
      cp ${assetsJsonUrl}/index.json src/resources/assets.json
      cp ${assetsJsonUrl}/index.minimal.json src/resources/assets.minimal.json
      cp ${assetsTestnet}/index.json src/resources/assets-testnet.json
      cp ${assetsTestnet}/index.minimal.json src/resources/assets-testnet.minimal.json
    '';
    buildPhase = ''
      export PATH="${nodeDependencies}/bin:$PATH"
      # if there is no HOME var, then npm will try to write to root dir, for which it has no write permissions to, so we provide HOME var
      export HOME=./home

      # and create this dir as well
      mkdir $HOME

      # without overriding this env var, build will try to ask for some input.
      # copy contents of the node_modules, following symlinks, such that current build/install will be able to modify local copies
      cp -r ${nodeDependencies}/lib/node_modules ./node_modules
      # allow user to write
      chmod -R u+w ./node_modules
      find ./node_modules -name '*.js' -exec chmod a+x {} \;
      patchShebangs ./node_modules/@angular/cli/bin/ng.js
      for FILE in $(find ./node_modules/.bin/); do
        chmod a+x $FILE
        chmod a+x $(readlink -f $FILE)
        patchShebangs $FILE
        patchShebangs $(readlink -f $FILE)
      done
      export DOCKER_COMMIT_HASH=$(git rev-parse --short HEAD)
      # we already have populated node_modules dir, so we don't need to run `npm install`
      npm run build
    '';
    installPhase = ''
      mkdir -p $out
      cp -r dist/mempool/browser/* $out
    '';
    patches = [
      ./sync-assets.patch # support offline build
    ];
  };
in
{ op-energy-backend = backend_derivation;
  op-energy-frontend = frontend_derivation;
}
