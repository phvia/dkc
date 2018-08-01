##
# mysql/Dockerfile
#
# @license Apache-2.0
# @maintainer <github.com/farwish>
##

ARG MYSQL_VERSION

FROM mysql:${MYSQL_VERSION}

#mysql_1  | 2018-07-05T09:49:39.851911Z 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
#mysql_1  | 2018-07-05T09:49:40.008181Z 0 [Warning] InnoDB: New log files created, LSN=45790
#mysql_1  | 2018-07-05T09:49:40.032866Z 0 [Warning] InnoDB: Creating foreign key constraint system tables.
#mysql_1  | 2018-07-05T09:49:40.087121Z 0 [Warning] No existing UUID has been found, so we assume that this is the first time that this server has been started. Generating a new UUID: bc52dce8-8038-11e8-bd8d-0242ac120005.
#mysql_1  | 2018-07-05T09:49:40.088389Z 0 [Warning] Gtid table is not ready to be used. Table 'mysql.gtid_executed' cannot be opened.
#mysql_1  | 2018-07-05T09:49:40.088955Z 1 [Warning] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
#mysql_1  | 2018-07-05T09:49:40.441898Z 1 [Warning] 'user' entry 'root@localhost' ignored in --skip-name-resolve mode.
#mysql_1  | 2018-07-05T09:49:40.442361Z 1 [Warning] 'user' entry 'mysql.session@localhost' ignored in --skip-name-resolve mode.
#mysql_1  | 2018-07-05T09:49:40.442628Z 1 [Warning] 'user' entry 'mysql.sys@localhost' ignored in --skip-name-resolve mode.
#mysql_1  | 2018-07-05T09:49:40.442896Z 1 [Warning] 'db' entry 'performance_schema mysql.session@localhost' ignored in --skip-name-resolve mode.
#mysql_1  | 2018-07-05T09:49:40.443136Z 1 [Warning] 'db' entry 'sys mysql.sys@localhost' ignored in --skip-name-resolve mode.
#mysql_1  | 2018-07-05T09:49:40.443377Z 1 [Warning] 'proxies_priv' entry '@ root@localhost' ignored in --skip-name-resolve mode.
#mysql_1  | 2018-07-05T09:49:40.443637Z 1 [Warning] 'tables_priv' entry 'user mysql.session@localhost' ignored in --skip-name-resolve mode.
#mysql_1  | 2018-07-05T09:49:40.443912Z 1 [Warning] 'tables_priv' entry 'sys_config mysql.sys@localhost' ignored in --skip-name-resolve mode.
#mysql_1  | Database initialized
