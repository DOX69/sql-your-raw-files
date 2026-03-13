-- Import CSV data into persistent tables in finance.db

-- 1. Create stores table (Semicolon separated)
CREATE TABLE stores AS SELECT * FROM read_csv_auto('duckdb/data/csv/store.csv', delim=';');

-- 2. Create account_statements table (Comma separated)
CREATE TABLE account_statements AS SELECT * FROM read_csv_auto('duckdb/data/csv/account-statement*.csv');

-- 3. Create order_headers table (Semicolon separated)
CREATE TABLE order_headers AS SELECT * FROM read_csv_auto('duckdb/data/csv/ent_cde.csv', delim=';');

-- 4. Create order_details table (Semicolon separated)
CREATE TABLE order_details AS SELECT * FROM read_csv_auto('duckdb/data/csv/det_cde.csv', delim=';');

-- Show imported tables
SHOW TABLES;
