#!/bin/sh

# MEMPOOL
__MEMPOOL_NETWORK__=${MEMPOOL_NETWORK:=mainnet}
__MEMPOOL_BACKEND__=${MEMPOOL_BACKEND:=electrum}
__MEMPOOL_HTTP_PORT__=${BACKEND_HTTP_PORT:=8999}
__MEMPOOL_SPAWN_CLUSTER_PROCS__=${MEMPOOL_SPAWN_CLUSTER_PROCS:=0}
__MEMPOOL_API_URL_PREFIX__=${MEMPOOL_API_URL_PREFIX:=/api/v1/}
__MEMPOOL_POLL_RATE_MS__=${MEMPOOL_POLL_RATE_MS:=2000}
__MEMPOOL_CACHE_DIR__=${MEMPOOL_CACHE_DIR:=./cache}
__MEMPOOL_CLEAR_PROTECTION_MINUTES__=${MEMPOOL_CLEAR_PROTECTION_MINUTES:=20}
__MEMPOOL_RECOMMENDED_FEE_PERCENTILE__=${MEMPOOL_RECOMMENDED_FEE_PERCENTILE:=50}
__MEMPOOL_BLOCK_WEIGHT_UNITS__=${MEMPOOL_BLOCK_WEIGHT_UNITS:=4000000}
__MEMPOOL_INITIAL_BLOCKS_AMOUNT__=${MEMPOOL_INITIAL_BLOCKS_AMOUNT:=8}
__MEMPOOL_MEMPOOL_BLOCKS_AMOUNT__=${MEMPOOL_MEMPOOL_BLOCKS_AMOUNT:=8}
__MEMPOOL_INDEXING_BLOCKS_AMOUNT__=${MEMPOOL_INDEXING_BLOCKS_AMOUNT:=11000}
__MEMPOOL_BLOCKS_SUMMARIES_INDEXING__=${MEMPOOL_BLOCKS_SUMMARIES_INDEXING:=false}
__MEMPOOL_PRICE_FEED_UPDATE_INTERVAL__=${MEMPOOL_PRICE_FEED_UPDATE_INTERVAL:=600}
__MEMPOOL_USE_SECOND_NODE_FOR_MINFEE__=${MEMPOOL_USE_SECOND_NODE_FOR_MINFEE:=false}
__MEMPOOL_EXTERNAL_ASSETS__=${MEMPOOL_EXTERNAL_ASSETS:=[]}
__MEMPOOL_EXTERNAL_MAX_RETRY__=${MEMPOOL_EXTERNAL_MAX_RETRY:=1}
__MEMPOOL_EXTERNAL_RETRY_INTERVAL__=${MEMPOOL_EXTERNAL_RETRY_INTERVAL:=0}
__MEMPOOL_USER_AGENT__=${MEMPOOL_USER_AGENT:=mempool}
__MEMPOOL_STDOUT_LOG_MIN_PRIORITY__=${MEMPOOL_STDOUT_LOG_MIN_PRIORITY:=info}
__MEMPOOL_INDEXING_BLOCKS_AMOUNT__=${MEMPOOL_INDEXING_BLOCKS_AMOUNT:=false}
__MEMPOOL_AUTOMATIC_BLOCK_REINDEXING__=${MEMPOOL_AUTOMATIC_BLOCK_REINDEXING:=false}
__MEMPOOL_POOLS_JSON_URL__=${MEMPOOL_POOLS_JSON_URL:=https://raw.githubusercontent.com/mempool/mining-pools/master/pools.json}
__MEMPOOL_POOLS_JSON_TREE_URL__=${MEMPOOL_POOLS_JSON_TREE_URL:=https://api.github.com/repos/mempool/mining-pools/git/trees/master}

# CORE_RPC
__CORE_RPC_HOST__=${CORE_RPC_HOST:=127.0.0.1}
__CORE_RPC_PORT__=${CORE_RPC_PORT:=8332}
__CORE_RPC_USERNAME__=${CORE_RPC_USERNAME:=mempool}
__CORE_RPC_PASSWORD__=${CORE_RPC_PASSWORD:=mempool}

# ELECTRUM
__ELECTRUM_HOST__=${ELECTRUM_HOST:=127.0.0.1}
__ELECTRUM_PORT__=${ELECTRUM_PORT:=50002}
__ELECTRUM_TLS_ENABLED__=${ELECTRUM_TLS_ENABLED:=false}

# ESPLORA
__ESPLORA_REST_API_URL__=${ESPLORA_REST_API_URL:=http://127.0.0.1:3000}

# SECOND_CORE_RPC
__SECOND_CORE_RPC_HOST__=${SECOND_CORE_RPC_HOST:=127.0.0.1}
__SECOND_CORE_RPC_PORT__=${SECOND_CORE_RPC_PORT:=8332}
__SECOND_CORE_RPC_USERNAME__=${SECOND_CORE_RPC_USERNAME:=mempool}
__SECOND_CORE_RPC_PASSWORD__=${SECOND_CORE_RPC_PASSWORD:=mempool}

# DATABASE
__DATABASE_ENABLED__=${DATABASE_ENABLED:=true}
__DATABASE_HOST__=${DATABASE_HOST:=127.0.0.1}
__DATABASE_SOCKET__=${DATABASE_SOCKET:=""}
__DATABASE_PORT__=${DATABASE_PORT:=3306}
__DATABASE_DATABASE__=${DATABASE_DATABASE:=mempool}
__DATABASE_USERNAME__=${DATABASE_USERNAME:=mempool}
__DATABASE_PASSWORD__=${DATABASE_PASSWORD:=mempool}

# SYSLOG
__SYSLOG_ENABLED__=${SYSLOG_ENABLED:=false}
__SYSLOG_HOST__=${SYSLOG_HOST:=127.0.0.1}
__SYSLOG_PORT__=${SYSLOG_PORT:=514}
__SYSLOG_MIN_PRIORITY__=${SYSLOG_MIN_PRIORITY:=info}
__SYSLOG_FACILITY__=${SYSLOG_FACILITY:=local7}

# STATISTICS
__STATISTICS_ENABLED__=${STATISTICS_ENABLED:=true}
__STATISTICS_TX_PER_SECOND_SAMPLE_PERIOD__=${STATISTICS_TX_PER_SECOND_SAMPLE_PERIOD:=150}

# BISQ
__BISQ_ENABLED__=${BISQ_ENABLED:=false}
__BISQ_DATA_PATH__=${BISQ_DATA_PATH:=/bisq/statsnode-data/btc_mainnet/db}

# SOCKS5PROXY
__SOCKS5PROXY_ENABLED__=${SOCKS5PROXY_ENABLED:=false}
__SOCKS5PROXY_USE_ONION__=${SOCKS5PROXY_USE_ONION:=true}
__SOCKS5PROXY_HOST__=${SOCKS5PROXY_HOST:=localhost}
__SOCKS5PROXY_PORT__=${SOCKS5PROXY_PORT:=9050}
__SOCKS5PROXY_USERNAME__=${SOCKS5PROXY_USERNAME:=""}
__SOCKS5PROXY_PASSWORD__=${SOCKS5PROXY_PASSWORD:=""}

# PRICE_DATA_SERVER
__PRICE_DATA_SERVER_TOR_URL__=${PRICE_DATA_SERVER_TOR_URL:=http://wizpriceje6q5tdrxkyiazsgu7irquiqjy2dptezqhrtu7l2qelqktid.onion/getAllMarketPrices}
__PRICE_DATA_SERVER_CLEARNET_URL__=${PRICE_DATA_SERVER_CLEARNET_URL:=https://price.bisq.wiz.biz/getAllMarketPrices}

# EXTERNAL_DATA_SERVER
__EXTERNAL_DATA_SERVER_MEMPOOL_API__=${EXTERNAL_DATA_SERVER_MEMPOOL_API:=https://mempool.space/api/v1}
__EXTERNAL_DATA_SERVER_MEMPOOL_ONION__=${EXTERNAL_DATA_SERVER_MEMPOOL_ONION:=http://mempoolhqx4isw62xs7abwphsq7ldayuidyx2v2oethdhhj6mlo2r6ad.onion/api/v1}
__EXTERNAL_DATA_SERVER_LIQUID_API__=${EXTERNAL_DATA_SERVER_LIQUID_API:=https://liquid.network/api/v1}
__EXTERNAL_DATA_SERVER_LIQUID_ONION__=${EXTERNAL_DATA_SERVER_LIQUID_ONION:=http://liquidmom47f6s3m53ebfxn47p76a6tlnxib3wp6deux7wuzotdr6cyd.onion/api/v1}
__EXTERNAL_DATA_SERVER_BISQ_URL__=${EXTERNAL_DATA_SERVER_BISQ_URL:=https://bisq.markets/api}
__EXTERNAL_DATA_SERVER_BISQ_ONION__=${EXTERNAL_DATA_SERVER_BISQ_ONION:=http://bisqmktse2cabavbr2xjq7xw3h6g5ottemo5rolfcwt6aly6tp5fdryd.onion/api}

# LIGHTNING
__LIGHTNING_ENABLED__=${LIGHTNING_ENABLED:=false}
__LIGHTNING_BACKEND__=${LIGHTNING_BACKEND:="lnd"}
__LIGHTNING_TOPOLOGY_FOLDER__=${LIGHTNING_TOPOLOGY_FOLDER:=""}
__LIGHTNING_STATS_REFRESH_INTERVAL__=${LIGHTNING_STATS_REFRESH_INTERVAL:=600}
__LIGHTNING_GRAPH_REFRESH_INTERVAL__=${LIGHTNING_GRAPH_REFRESH_INTERVAL:=600}
__LIGHTNING_LOGGER_UPDATE_INTERVAL__=${LIGHTNING_LOGGER_UPDATE_INTERVAL:=30}

# LND
__LND_TLS_CERT_PATH__=${LND_TLS_CERT_PATH:=""}
__LND_MACAROON_PATH__=${LND_MACAROON_PATH:=""}
__LND_REST_API_URL__=${LND_REST_API_URL:="https://localhost:8080"}

# CLN
__CLIGHTNING_SOCKET__=${CLIGHTNING_SOCKET:=""}

mkdir -p "${__MEMPOOL_CACHE_DIR__}"

sed -i "s/__MEMPOOL_NETWORK__/${__MEMPOOL_NETWORK__}/g" mempool-config.json
sed -i "s/__MEMPOOL_BACKEND__/${__MEMPOOL_BACKEND__}/g" mempool-config.json
sed -i "s/__MEMPOOL_HTTP_PORT__/${__MEMPOOL_HTTP_PORT__}/g" mempool-config.json
sed -i "s/__MEMPOOL_SPAWN_CLUSTER_PROCS__/${__MEMPOOL_SPAWN_CLUSTER_PROCS__}/g" mempool-config.json
sed -i "s!__MEMPOOL_API_URL_PREFIX__!${__MEMPOOL_API_URL_PREFIX__}!g" mempool-config.json
sed -i "s/__MEMPOOL_POLL_RATE_MS__/${__MEMPOOL_POLL_RATE_MS__}/g" mempool-config.json
sed -i "s!__MEMPOOL_CACHE_DIR__!${__MEMPOOL_CACHE_DIR__}!g" mempool-config.json
sed -i "s/__MEMPOOL_CLEAR_PROTECTION_MINUTES__/${__MEMPOOL_CLEAR_PROTECTION_MINUTES__}/g" mempool-config.json
sed -i "s/__MEMPOOL_RECOMMENDED_FEE_PERCENTILE__/${__MEMPOOL_RECOMMENDED_FEE_PERCENTILE__}/g" mempool-config.json
sed -i "s/__MEMPOOL_BLOCK_WEIGHT_UNITS__/${__MEMPOOL_BLOCK_WEIGHT_UNITS__}/g" mempool-config.json
sed -i "s/__MEMPOOL_INITIAL_BLOCKS_AMOUNT__/${__MEMPOOL_INITIAL_BLOCKS_AMOUNT__}/g" mempool-config.json
sed -i "s/__MEMPOOL_MEMPOOL_BLOCKS_AMOUNT__/${__MEMPOOL_MEMPOOL_BLOCKS_AMOUNT__}/g" mempool-config.json
sed -i "s/__MEMPOOL_INDEXING_BLOCKS_AMOUNT__/${__MEMPOOL_INDEXING_BLOCKS_AMOUNT__}/g" mempool-config.json
sed -i "s/__MEMPOOL_BLOCKS_SUMMARIES_INDEXING__/${__MEMPOOL_BLOCKS_SUMMARIES_INDEXING__}/g" mempool-config.json
sed -i "s/__MEMPOOL_PRICE_FEED_UPDATE_INTERVAL__/${__MEMPOOL_PRICE_FEED_UPDATE_INTERVAL__}/g" mempool-config.json
sed -i "s/__MEMPOOL_USE_SECOND_NODE_FOR_MINFEE__/${__MEMPOOL_USE_SECOND_NODE_FOR_MINFEE__}/g" mempool-config.json
sed -i "s!__MEMPOOL_EXTERNAL_ASSETS__!${__MEMPOOL_EXTERNAL_ASSETS__}!g" mempool-config.json
sed -i "s!__MEMPOOL_EXTERNAL_MAX_RETRY__!${__MEMPOOL_EXTERNAL_MAX_RETRY__}!g" mempool-config.json
sed -i "s!__MEMPOOL_EXTERNAL_RETRY_INTERVAL__!${__MEMPOOL_EXTERNAL_RETRY_INTERVAL__}!g" mempool-config.json
sed -i "s!__MEMPOOL_USER_AGENT__!${__MEMPOOL_USER_AGENT__}!g" mempool-config.json
sed -i "s/__MEMPOOL_STDOUT_LOG_MIN_PRIORITY__/${__MEMPOOL_STDOUT_LOG_MIN_PRIORITY__}/g" mempool-config.json
sed -i "s/__MEMPOOL_INDEXING_BLOCKS_AMOUNT__/${__MEMPOOL_INDEXING_BLOCKS_AMOUNT__}/g" mempool-config.json
sed -i "s/__MEMPOOL_AUTOMATIC_BLOCK_REINDEXING__/${__MEMPOOL_AUTOMATIC_BLOCK_REINDEXING__}/g" mempool-config.json
sed -i "s!__MEMPOOL_POOLS_JSON_URL__!${__MEMPOOL_POOLS_JSON_URL__}!g" mempool-config.json
sed -i "s!__MEMPOOL_POOLS_JSON_TREE_URL__!${__MEMPOOL_POOLS_JSON_TREE_URL__}!g" mempool-config.json

sed -i "s/__CORE_RPC_HOST__/${__CORE_RPC_HOST__}/g" mempool-config.json
sed -i "s/__CORE_RPC_PORT__/${__CORE_RPC_PORT__}/g" mempool-config.json
sed -i "s/__CORE_RPC_USERNAME__/${__CORE_RPC_USERNAME__}/g" mempool-config.json
sed -i "s/__CORE_RPC_PASSWORD__/${__CORE_RPC_PASSWORD__}/g" mempool-config.json

sed -i "s/__ELECTRUM_HOST__/${__ELECTRUM_HOST__}/g" mempool-config.json
sed -i "s/__ELECTRUM_PORT__/${__ELECTRUM_PORT__}/g" mempool-config.json
sed -i "s/__ELECTRUM_TLS_ENABLED__/${__ELECTRUM_TLS_ENABLED__}/g" mempool-config.json

sed -i "s!__ESPLORA_REST_API_URL__!${__ESPLORA_REST_API_URL__}!g" mempool-config.json

sed -i "s/__SECOND_CORE_RPC_HOST__/${__SECOND_CORE_RPC_HOST__}/g" mempool-config.json
sed -i "s/__SECOND_CORE_RPC_PORT__/${__SECOND_CORE_RPC_PORT__}/g" mempool-config.json
sed -i "s/__SECOND_CORE_RPC_USERNAME__/${__SECOND_CORE_RPC_USERNAME__}/g" mempool-config.json
sed -i "s/__SECOND_CORE_RPC_PASSWORD__/${__SECOND_CORE_RPC_PASSWORD__}/g" mempool-config.json

sed -i "s/__DATABASE_ENABLED__/${__DATABASE_ENABLED__}/g" mempool-config.json
sed -i "s/__DATABASE_HOST__/${__DATABASE_HOST__}/g" mempool-config.json
sed -i "s!__DATABASE_SOCKET__!${__DATABASE_SOCKET__}!g" mempool-config.json

sed -i "s/__DATABASE_PORT__/${__DATABASE_PORT__}/g" mempool-config.json
sed -i "s/__DATABASE_DATABASE__/${__DATABASE_DATABASE__}/g" mempool-config.json
sed -i "s/__DATABASE_USERNAME__/${__DATABASE_USERNAME__}/g" mempool-config.json
sed -i "s/__DATABASE_PASSWORD__/${__DATABASE_PASSWORD__}/g" mempool-config.json

sed -i "s/__SYSLOG_ENABLED__/${__SYSLOG_ENABLED__}/g" mempool-config.json
sed -i "s/__SYSLOG_HOST__/${__SYSLOG_HOST__}/g" mempool-config.json
sed -i "s/__SYSLOG_PORT__/${__SYSLOG_PORT__}/g" mempool-config.json
sed -i "s/__SYSLOG_MIN_PRIORITY__/${__SYSLOG_MIN_PRIORITY__}/g" mempool-config.json
sed -i "s/__SYSLOG_FACILITY__/${__SYSLOG_FACILITY__}/g" mempool-config.json

sed -i "s/__STATISTICS_ENABLED__/${__STATISTICS_ENABLED__}/g" mempool-config.json
sed -i "s/__STATISTICS_TX_PER_SECOND_SAMPLE_PERIOD__/${__STATISTICS_TX_PER_SECOND_SAMPLE_PERIOD__}/g" mempool-config.json

sed -i "s/__BISQ_ENABLED__/${__BISQ_ENABLED__}/g" mempool-config.json
sed -i "s!__BISQ_DATA_PATH__!${__BISQ_DATA_PATH__}!g" mempool-config.json

sed -i "s/__SOCKS5PROXY_ENABLED__/${__SOCKS5PROXY_ENABLED__}/g" mempool-config.json
sed -i "s/__SOCKS5PROXY_USE_ONION__/${__SOCKS5PROXY_USE_ONION__}/g" mempool-config.json
sed -i "s/__SOCKS5PROXY_HOST__/${__SOCKS5PROXY_HOST__}/g" mempool-config.json
sed -i "s/__SOCKS5PROXY_PORT__/${__SOCKS5PROXY_PORT__}/g" mempool-config.json
sed -i "s/__SOCKS5PROXY_USERNAME__/${__SOCKS5PROXY_USERNAME__}/g" mempool-config.json
sed -i "s/__SOCKS5PROXY_PASSWORD__/${__SOCKS5PROXY_PASSWORD__}/g" mempool-config.json

sed -i "s!__PRICE_DATA_SERVER_TOR_URL__!${__PRICE_DATA_SERVER_TOR_URL__}!g" mempool-config.json
sed -i "s!__PRICE_DATA_SERVER_CLEARNET_URL__!${__PRICE_DATA_SERVER_CLEARNET_URL__}!g" mempool-config.json

sed -i "s!__EXTERNAL_DATA_SERVER_MEMPOOL_API__!${__EXTERNAL_DATA_SERVER_MEMPOOL_API__}!g" mempool-config.json
sed -i "s!__EXTERNAL_DATA_SERVER_MEMPOOL_ONION__!${__EXTERNAL_DATA_SERVER_MEMPOOL_ONION__}!g" mempool-config.json
sed -i "s!__EXTERNAL_DATA_SERVER_LIQUID_API__!${__EXTERNAL_DATA_SERVER_LIQUID_API__}!g" mempool-config.json
sed -i "s!__EXTERNAL_DATA_SERVER_LIQUID_ONION__!${__EXTERNAL_DATA_SERVER_LIQUID_ONION__}!g" mempool-config.json
sed -i "s!__EXTERNAL_DATA_SERVER_BISQ_URL__!${__EXTERNAL_DATA_SERVER_BISQ_URL__}!g" mempool-config.json
sed -i "s!__EXTERNAL_DATA_SERVER_BISQ_ONION__!${__EXTERNAL_DATA_SERVER_BISQ_ONION__}!g" mempool-config.json

# LIGHTNING
sed -i "s!__LIGHTNING_ENABLED__!${__LIGHTNING_ENABLED__}!g" mempool-config.json
sed -i "s!__LIGHTNING_BACKEND__!${__LIGHTNING_BACKEND__}!g" mempool-config.json
sed -i "s!__LIGHTNING_TOPOLOGY_FOLDER__!${__LIGHTNING_TOPOLOGY_FOLDER__}!g" mempool-config.json
sed -i "s!__LIGHTNING_STATS_REFRESH_INTERVAL__!${__LIGHTNING_STATS_REFRESH_INTERVAL__}!g" mempool-config.json
sed -i "s!__LIGHTNING_GRAPH_REFRESH_INTERVAL__!${__LIGHTNING_GRAPH_REFRESH_INTERVAL__}!g" mempool-config.json
sed -i "s!__LIGHTNING_LOGGER_UPDATE_INTERVAL__!${__LIGHTNING_LOGGER_UPDATE_INTERVAL__}!g" mempool-config.json

# LND
sed -i "s!__LND_TLS_CERT_PATH__!${__LND_TLS_CERT_PATH__}!g" mempool-config.json
sed -i "s!__LND_MACAROON_PATH__!${__LND_MACAROON_PATH__}!g" mempool-config.json
sed -i "s!__LND_REST_API_URL__!${__LND_REST_API_URL__}!g" mempool-config.json

# CLN
sed -i "s!__CLIGHTNING_SOCKET__!${__CLIGHTNING_SOCKET__}!g" mempool-config.json

node /backend/package/index.js
