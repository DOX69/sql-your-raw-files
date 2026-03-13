-- Exploration queries for the finance.db persistent tables
-- Run this with: duckdb duckdb/db/public/finance.db

-- 1. Check table sizes
SELECT 'account_statements' as tab, COUNT(*) FROM account_statements
UNION ALL
SELECT 'order_details', COUNT(*) FROM order_details
UNION ALL
SELECT 'order_headers', COUNT(*) FROM order_headers
UNION ALL
SELECT 'stores', COUNT(*) FROM stores;

-- 2. Preview account statements (Top 5)
SELECT * FROM account_statements LIMIT 5;

-- 3. Top 5 stores by order volume (Example join)
SELECT s.LIB_MAG, COUNT(h.NUM_CDE) as order_count
FROM stores s
JOIN order_headers h ON s.CD_MAG = h.CD_MAG
GROUP BY s.LIB_MAG
ORDER BY order_count DESC
LIMIT 5;

-- 4. Sample order with its details (Example join)
SELECT h.NUM_CDE, h.DT_CDE, d.CD_PDT, d.QT_ART
FROM order_headers h
JOIN order_details d ON h.NUM_CDE = d.NUM_CDE
LIMIT 5;
