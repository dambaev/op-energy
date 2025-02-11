import { DB } from '../database';
import logger from '../../logger';

class OpEnergyDatabaseMigration {
  private static currentVersion = 10;

  public async $initializeOrMigrateDatabase( UUID: string): Promise<void> {
    logger.info(`${UUID}: OE MIGRATION: running migrations`);
    let databaseSchemaVersion = 0;
    try {
      databaseSchemaVersion = await this.$getCurrentRevision();
    } catch(e) {
      logger.info( `${UUID}: OE MIGRATION: warn: failed to get current revision: ` + ((e instanceof Error)? e.message : JSON.stringify(e)));
    }
    while( databaseSchemaVersion < OpEnergyDatabaseMigration.currentVersion) {
      logger.info(`${UUID}: OE MIGRATION: current databaseSchemaVersion ` + databaseSchemaVersion);
      await this.$createOrMigrateTables( UUID, databaseSchemaVersion);
      databaseSchemaVersion = await this.$getCurrentRevision();
    }
    logger.info(`${UUID}: OE MIGRATION: finished migrations to revision ` + OpEnergyDatabaseMigration.currentVersion);
  }
  private async $createOrMigrateTables( UUID: string, revision: number) {
    logger.info( `${UUID}: OE MIGRATION: OpEnergyDatabaseMigration.$createOrMigrateTables: revision requested: ` + JSON.stringify(revision));
    switch( revision) {
      case 0: {
        await this.$createTableVersion();
        break;
      }
      case 1: {
        await this.$createTableChainstats();
        break;
      }
      case 2: {
        await this.$createTableUsers(UUID);
        break;
      }
      case 3: {
        await this.$alterTableUsersCreateIndex( UUID);
        break;
      }
      case 4: {
        await this.$createTableTimeStrikes( UUID);
        break;
      }
      case 5: {
        await this.$createTableSinglePlayerGuesses( UUID);
        break;
      }
      case 6: {
        await this.$createTableTimeStrikesHistory( UUID);
        break;
      }
      case 7: {
        await this.$createTableSinglePlayerResults( UUID);
        break;
      }
      case 8: {
        await this.$createTableBlockHeaders(UUID);
        break;
      }
      case 9: {
        await this.$dropTableChainstats();
        break;
      }
      default: {
        throw new Error( `${UUID} OE MIGRATION: OpEnergyDatabaseMigration.$createOrMigrateTables: unsupported revision requested: ` + JSON.stringify(revision));
      }
    }
    await this.$increaseRevision( revision);
  }
  private async $increaseRevision( revision: number) {
    try {
      const connection = await DB.pool.getConnection();
      const query = `UPDATE version set revision=${revision + 1} where revision=${revision};`;
      await connection.query<any>(query, []);
      connection.release();
      logger.info('OE MIGRATION: migrated to databaseSchemaVersion ' + (revision + 1));
    } catch (e) {
      let err_msg = `OE MIGRATION: $createOrMigrateTables error: failed to update version: ${( e instanceof Error ? e.message : e)}`;
      throw new Error( err_msg);
    }
  }
  private async $getCurrentRevision():Promise<number> {
    var revision = 0;
    try {
      const connection = await DB.pool.getConnection();
      const query = 'SELECT revision FROM version ORDER BY revision DESC limit 1;';
      const [[result]] = await connection.query<any>(query, []);
      revision = result.revision;
      connection.release();
    } catch(e) {
      let err_msg = `OE MIGRATION: $getCurrentRevision error ${( e instanceof Error ? e.message : e)}`;
      throw new Error( err_msg);
    }
    return revision;
  }
  private async $createTableVersion() {
    try {
      const connection = await DB.pool.getConnection();
      const query = `CREATE TABLE IF NOT EXISTS version (
        revision int(8) NOT NULL,
        PRIMARY KEY(revision)
      ) ENGINE=InnoDB CHARSET=utf8`;
      await connection.query<any>(query, []);
      await connection.query<any>('INSERT INTO `version` (`revision`) VALUES(0)', []);
      connection.release();
    } catch(e) {
      let err_msg = `OE MIGRATION: createTableVersion error ${( e instanceof Error ? e.message : e)}`;
      throw new Error( err_msg);
    }
  }
  private async $createTableChainstats() {
    try {
      const connection = await DB.pool.getConnection();
      const query = `CREATE TABLE IF NOT EXISTS \`chainstats\` (
        \`block_height\` int(11) NOT NULL,
        \`chain_revenue\` double,
        \`chain_fee\` double,
        \`chain_subsidy\` double,
        \`chainwork\` VARCHAR(65),
        PRIMARY KEY(block_height)
      ) ENGINE=InnoDB CHARSET=utf8`;
      await connection.query<any>(query, []);
      connection.release();
    } catch(e) {
      let err_msg = `OE MIGRATION: createTableVersion error ${( e instanceof Error ? e.message : e)}`;
      throw new Error( err_msg);
    }
    logger.info( 'OE MOGRATION: OpEneryDatabaseMigration.$createTableChainstats completed');
  }
  private async $createTableUsers(UUID: string){
    const query = `CREATE TABLE IF NOT EXISTS \`users\` (
      \`id\` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
      \`secret_hash\` VARCHAR(65) NOT NULL,
      \`display_name\` VARCHAR(30) NOT NULL,
      \`creation_time\` datetime NOT NULL,
      \`last_log_time\` datetime NOT NULL,
      PRIMARY KEY(id)
    ) ENGINE=InnoDB CHARSET=utf8`;
    try {
      await DB.$with_accountPool<void>( UUID, async (connection) => {
        await DB.$profile_query<any>(UUID, connection, query, []);
      });
    } catch(e) {
      let err_msg = `${UUID}: OE MIGRATION: createTableUsers error ${( e instanceof Error ? e.message : e)}`;
      throw new Error( err_msg);
    }
    logger.info( '${UUID}: OE MIGRATION: OpEneryDatabaseMigration.$createTableUsers completed');
  }
  private async $createTableTimeStrikes( UUID: string){
    const query = `CREATE TABLE IF NOT EXISTS \`timestrikes\` (
      \`id\` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
      \`user_id\` int(11) UNSIGNED NOT NULL,
      \`block_height\` int(11) UNSIGNED NOT NULL,
      \`nlocktime\` int(11) UNSIGNED NOT NULL,
      \`creation_time\` datetime NOT NULL,
      PRIMARY KEY(id),
      UNIQUE INDEX(block_height,nlocktime),
      FOREIGN KEY (user_id)
        REFERENCES users(id)
    ) ENGINE=InnoDB CHARSET=utf8`;
    try {
      await DB.$with_accountPool( UUID, async (connection) => {
        await DB.$profile_query( UUID, connection, query, []);
      });
    } catch(e) {
      let err_msg = `OE MIGRATION: createTableTimeStrikes error ${( e instanceof Error ? e.message : e)}`;
      throw new Error( err_msg);
    }
    logger.info( 'OE MIGRATION: OpEneryDatabaseMigration.$createTableTimeStrikes completed');
  }
  private async $alterTableUsersCreateIndex(UUID: string){
    const query = `ALTER TABLE \`users\` ADD UNIQUE INDEX(secret_hash)`;
    try {
      await DB.$with_accountPool( UUID, async (connection) => {
        await DB.$profile_query<any>(UUID, connection, query, []);
      });
    } catch(e) {
      let err_msg = `OE MIGRATION: ERROR: OpEneryDatabaseMigration.$alterTableUsersCreateIndex ${( e instanceof Error ? e.message : e)}`;
      throw new Error( err_msg);
    }
    logger.info( 'OE MIGRATION: OpEneryDatabaseMigration.$alterTableUsersCreateIndex completed');
  }
  private async $createTableSinglePlayerGuesses(UUID: string){
    const query = `CREATE TABLE IF NOT EXISTS \`slowfastguesses\` (
      \`id\` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
      \`user_id\` int(11) UNSIGNED NOT NULL,
      \`timestrike_id\` int(11) UNSIGNED NOT NULL,
      \`guess\` int(1) UNSIGNED NOT NULL,
      \`creation_time\` datetime NOT NULL,
      PRIMARY KEY(id),
      UNIQUE INDEX(user_id,timestrike_id),
      FOREIGN KEY (user_id)
        REFERENCES users(id),
      FOREIGN KEY (timestrike_id)
        REFERENCES timestrikes(id)
    ) ENGINE=InnoDB CHARSET=utf8`;
    try {
      await DB.$with_accountPool( UUID, async (connection) => {
        await DB.$profile_query<any>(UUID, connection, query, []);
      });
    } catch(e) {
      let err_msg = `OE MIGRATION: createTableSinglePlayerGuesses error ${( e instanceof Error ? e.message : e)}`;
      throw new Error( err_msg);
    }
    logger.info( 'OE MIGRATION: OpEneryDatabaseMigration.$createTableSinglePlayerGuesses completed');
  }

  private async $createTableBlockHeaders(UUID: string): Promise<void>{
    const query = `CREATE TABLE \`blocks\` (
      \`height\` int unsigned NOT NULL,
      \`version\` int unsigned NOT NULL,
      \`current_block_hash\` varchar(65) NOT NULL,
      \`previous_block_hash\` varchar(65) DEFAULT NULL,
      \`merkle_root\` varchar(65) NOT NULL,
      \`timestamp\` int unsigned NOT NULL,
      \`difficulty\` double unsigned NOT NULL,
      \`nonce\` bigint unsigned NOT NULL,
      \`reward\` bigint unsigned NOT NULL,
      \`mediantime\` int unsigned NOT NULL,
      \`chainwork\` varchar(65) NOT NULL,
      PRIMARY KEY (\`height\`)
    );`;
    try {
      await DB.$with_blockSpanPool( UUID, async (connection) => {
        await DB.$profile_query<any>(UUID, connection, query, [], 'blockSpanPool.query');
      });
    } catch(e) {
      const err_msg = `OE MIGRATION: $createTableBlockHeaders error ${( e instanceof Error ? e.message : e)}`;
      throw new Error( err_msg);
    }
    logger.info( 'OE MIGRATION: OpEneryDatabaseMigration.$createTableBlockHeaders completed');
  }

  private async $createTableTimeStrikesHistory( UUID: string){
    const query = `CREATE TABLE IF NOT EXISTS \`timestrikeshistory\` (
      \`id\` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
      \`user_id\` int(11) UNSIGNED NOT NULL,
      \`block_height\` int(11) UNSIGNED NOT NULL,
      \`mediantime\` int unsigned NOT NULL,
      \`nlocktime\` int(11) UNSIGNED NOT NULL,
      \`creation_time\` datetime NOT NULL,
      \`archive_time\` datetime NOT NULL,
      \`wrong_results\` int(11) UNSIGNED NOT NULL,
      \`right_results\` int(11) UNSIGNED NOT NULL,
      PRIMARY KEY(id),
      UNIQUE INDEX(block_height,nlocktime),
      FOREIGN KEY (user_id)
        REFERENCES users(id)
    ) ENGINE=InnoDB CHARSET=utf8`;
    try {
      await DB.$with_accountPool( UUID, async (connection) => {
        await DB.$profile_query( UUID, connection, query, []);
      });
    } catch(e) {
      let err_msg = `OE MIGRATION: createTableTimeStrikesHistory error ${( e instanceof Error ? e.message : e)}`;
      throw new Error( err_msg);
    }
    logger.info( 'OE MIGRATION: OpEneryDatabaseMigration.$createTableTimeStrikesHistory completed');
  }

  private async $createTableSinglePlayerResults(UUID: string){
    const query = `CREATE TABLE IF NOT EXISTS \`slowfastresults\` (
      \`id\` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
      \`user_id\` int(11) UNSIGNED NOT NULL,
      \`timestrikehistory_id\` int(11) UNSIGNED NOT NULL,
      \`guess\` int(1) UNSIGNED NOT NULL,
      \`result\` int(1) UNSIGNED NOT NULL,
      \`creation_time\` datetime NOT NULL,
      PRIMARY KEY(id),
      UNIQUE INDEX(user_id,timestrikehistory_id),
      FOREIGN KEY (user_id)
        REFERENCES users(id),
      FOREIGN KEY (timestrikehistory_id)
        REFERENCES timestrikeshistory(id)
    ) ENGINE=InnoDB CHARSET=utf8`;
    try {
      await DB.$with_accountPool( UUID, async (connection) => {
        await DB.$profile_query<any>(UUID, connection, query, []);
      });
    } catch(e) {
      let err_msg = `OE MIGRATION: createTableSinglePlayerResults error ${( e instanceof Error ? e.message : e)}`;
      throw new Error( err_msg);
    }
    logger.info( 'OE MIGRATION: OpEneryDatabaseMigration.$createTableSinglePlayerResults completed');
  }
  private async $dropTableChainstats() {
    try {
      const connection = await DB.pool.getConnection();
      const query = `DROP TABLE \`chainstats\``;
      await connection.query<any>(query, []);
      connection.release();
    } catch(e) {
      let err_msg = `OE MIGRATION: dropTableVersion error ${( e instanceof Error ? e.message : e)}`;
      throw new Error( err_msg);
    }
    logger.info( 'OE MOGRATION: OpEneryDatabaseMigration.$createTableChainstats completed');
  }

}

export default new OpEnergyDatabaseMigration();
