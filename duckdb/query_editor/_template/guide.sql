-- 1. Query files directly (In-memory)
SELECT * FROM read_csv_auto('duckdb/data/csv/*.csv') LIMIT 10;
SELECT * FROM read_parquet('duckdb/data/parquet/*.parquet') LIMIT 10;
SELECT * FROM read_json_auto('duckdb/data/json/*.json') LIMIT 10;

-- 2. Create/Open persistent DB
-- Command: duckdb duckdb/db/public/my_data.db

-- 3. Create tables in persistent DB
CREATE TABLE my_table AS SELECT * FROM read_csv_auto('duckdb/data/csv/my_file.csv');

-- 4. List existing tables
SHOW TABLES;
