/* Initialise docker postgreSQL container */
CREATE USER postgres WITH PASSWORD 'postgres' CREATEDB;
CREATE DATABASE tododatabase;
GRANT ALL PRIVILEGES ON DATABASE todotabase postgres to postgres;