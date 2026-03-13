-- Initial Exploration of CSV files

-- 1. Explore Stores
SELECT * FROM read_csv_auto('duckdb/data/csv/store.csv') LIMIT 10;

-- 2. Explore Account Statement (Comma separated)
SELECT * FROM read_csv_auto('duckdb/data/csv/account-statement*.csv') LIMIT 10;

-- 3. Explore Orders Header (Semicolon separated)
SELECT * FROM read_csv_auto('duckdb/data/csv/ent_cde.csv') LIMIT 10;

-- 4. Explore Order Details (Semicolon separated)
SELECT * FROM read_csv_auto('duckdb/data/csv/det_cde.csv') LIMIT 10;

-- 5. Total amount by Type in Account Statement
SELECT Type, SUM(Montant) as Total_Amount
FROM read_csv_auto('duckdb/data/csv/account-statement*.csv')
GROUP BY Type
ORDER BY Total_Amount DESC;
