import { PoolConnection } from 'mysql2/promise';
import { DB } from '../database';
import logger from '../logger';

class OpEnergyDatabaseMigration {
  private static currentVersion = 3;

  public async $initializeOrMigrateDatabase(): Promise<void> {
    logger.info('OE MIGRATION: running migrations');
    let databaseSchemaVersion = 0;
    try {
      databaseSchemaVersion = await this.$getCurrentRevision();
    } catch(e) {
      logger.info( 'OE MIGRATION: warn: failed to get current revision: ' + ((e instanceof Error)? e.message : JSON.stringify(e)));
    }
    while( databaseSchemaVersion < OpEnergyDatabaseMigration.currentVersion) {
      logger.info('OE MIGRATION: current databaseSchemaVersion ' + databaseSchemaVersion);
      await this.$createOrMigrateTables( databaseSchemaVersion);
      databaseSchemaVersion = await this.$getCurrentRevision();
    }
    logger.info('OE MIGRATION: finished migrations to revision ' + OpEnergyDatabaseMigration.currentVersion);
  }
  private async $createOrMigrateTables( revision: number) {
    logger.info( 'OE MIGRATION: OpEnergyDatabaseMigration.$createOrMigrateTables: revision requested: ' + JSON.stringify(revision));
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
        await this.$createTableUsers();
        break;
      }
      default: {
        throw new Error( 'OE MIGRATION: OpEnergyDatabaseMigration.$createOrMigrateTables: unsupported revision requested: ' + JSON.stringify(revision));
      }
    }
    await this.$increaseRevision(revision);
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
      let err_msg = 'OE MIGRATION: createTableVersion error ${( e instanceof Error ? e.message : e)}';
      throw new Error( err_msg);
    }
    logger.info( 'OE MOGRATION: OpEneryDatabaseMigration.$createTableChainstats completed');
  }
  private async $createTableUsers(){
    try {
      const connection = await DB.accountPool.getConnection();
      const query = `CREATE TABLE IF NOT EXISTS \`users\` (
        \`user_id\` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
        \`secret_hash\` VARCHAR(65) NOT NULL,
        \`display_name\` VARCHAR(30) NOT NULL,
        \`creation_time\` datetime NOT NULL,
        \`last_log_time\` datetime NOT NULL,
        PRIMARY KEY(user_id)
      ) ENGINE=InnoDB CHARSET=utf8`;
      await connection.query<any>(query, []);
      connection.release();
    } catch(e) {
      let err_msg = `OE MIGRATION: createTableUsers error ${( e instanceof Error ? e.message : e)}`;
      throw new Error( err_msg);
    }
    logger.info( 'OE MOGRATION: OpEneryDatabaseMigration.$createTableUsers completed');
  }

}

export default new OpEnergyDatabaseMigration();