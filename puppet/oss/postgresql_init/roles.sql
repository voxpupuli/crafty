CREATE USER puppetdb PASSWORD 'puppetdb';
CREATE USER puppetdb_read PASSWORD 'puppetdb_read';

REVOKE CREATE ON SCHEMA public FROM public;
GRANT CREATE ON SCHEMA public TO puppetdb;

ALTER DEFAULT PRIVILEGES FOR USER puppetdb IN SCHEMA public GRANT SELECT ON tables TO puppetdb_read;
ALTER DEFAULT PRIVILEGES FOR USER puppetdb IN SCHEMA public GRANT USAGE ON sequences TO puppetdb_read;
ALTER DEFAULT PRIVILEGES FOR USER puppetdb IN SCHEMA public GRANT EXECUTE ON functions TO puppetdb_read;
