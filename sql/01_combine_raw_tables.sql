
CREATE OR REPLACE TABLE
  `bright-gearbox-402817.ecommerce_retention.online_retail_raw` AS

SELECT
  invoice,
  stock_code,
  description,
  quantity,
  invoice_date,
  price,
  customer_id,
  country,
  '2009_2010' AS source_period
FROM
  `bright-gearbox-402817.ecommerce_retention.online_retail_2009_2010_raw`

UNION ALL

SELECT
  invoice,
  stock_code,
  description,
  quantity,
  invoice_date,
  price,
  customer_id,
  country,
  '2010_2011' AS source_period
FROM
  `bright-gearbox-402817.ecommerce_retention.online_retail_2010_2011_raw`;



-- Checking the result. Expected: 2009_2010: 525461; 2010_2011: 541910.
  SELECT
  source_period,
  COUNT(*) AS total_rows
FROM
  `bright-gearbox-402817.ecommerce_retention.online_retail_raw`
GROUP BY
  source_period
ORDER BY
  source_period;


-- Total check and expected result: 1067371.
  SELECT COUNT(*) AS total_rows
FROM `bright-gearbox-402817.ecommerce_retention.online_retail_raw`;
