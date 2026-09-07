SELECT
  COUNT(*) AS total_rows,

  COUNTIF(NULLIF(TRIM(customer_id), '') IS NULL)
    AS missing_customer_id,

  COUNTIF(NULLIF(TRIM(description), '') IS NULL)
    AS missing_description,

  COUNTIF(STARTS_WITH(UPPER(TRIM(invoice)), 'C'))
    AS cancelled_transactions,

  COUNTIF(SAFE_CAST(TRIM(quantity) AS INT64) <= 0)
    AS non_positive_quantity,

  COUNTIF(
    SAFE_CAST(REPLACE(TRIM(price), ',', '.') AS NUMERIC) <= 0
  ) AS non_positive_price,

  COUNT(DISTINCT NULLIF(TRIM(customer_id), ''))
    AS unique_customers,

  COUNT(DISTINCT NULLIF(TRIM(invoice), ''))
    AS unique_invoices,

  COUNT(DISTINCT NULLIF(TRIM(country), ''))
    AS unique_countries,

  COUNTIF(NULLIF(TRIM(invoice_date), '') IS NULL)
    AS missing_invoice_date,

  COUNTIF(
    NULLIF(TRIM(quantity), '') IS NOT NULL
    AND SAFE_CAST(TRIM(quantity) AS INT64) IS NULL
  ) AS invalid_quantity,

  COUNTIF(
    NULLIF(TRIM(price), '') IS NOT NULL
    AND SAFE_CAST(REPLACE(TRIM(price), ',', '.') AS NUMERIC) IS NULL
  ) AS invalid_price

FROM
  `bright-gearbox-402817.ecommerce_retention.online_retail_raw`;


-- duplicate check
WITH row_counts AS (
  SELECT
    invoice,
    stock_code,
    description,
    quantity,
    invoice_date,
    price,
    customer_id,
    country,
    COUNT(*) AS row_count
  FROM
    `bright-gearbox-402817.ecommerce_retention.online_retail_raw`
  GROUP BY
    invoice,
    stock_code,
    description,
    quantity,
    invoice_date,
    price,
    customer_id,
    country
)

SELECT
  COUNTIF(row_count > 1) AS duplicated_combinations,
  SUM(
    IF(row_count > 1, row_count - 1, 0)
  ) AS duplicate_rows_to_remove
FROM
  row_counts;

-- Checking date format
SELECT DISTINCT
  invoice_date
FROM
  `bright-gearbox-402817.ecommerce_retention.online_retail_raw`
WHERE
  NULLIF(TRIM(invoice_date), '') IS NOT NULL
LIMIT 20;


SELECT
  COUNTIF(
    NULLIF(TRIM(invoice_date), '') IS NOT NULL
    AND SAFE.PARSE_DATETIME(
      '%d.%m.%Y %H:%M',
      TRIM(invoice_date)
    ) IS NULL
  ) AS invalid_invoice_date,

  MIN(
    SAFE.PARSE_DATETIME(
      '%d.%m.%Y %H:%M',
      TRIM(invoice_date)
    )
  ) AS minimum_invoice_datetime,

  MAX(
    SAFE.PARSE_DATETIME(
      '%d.%m.%Y %H:%M',
      TRIM(invoice_date)
    )
  ) AS maximum_invoice_datetime

FROM
  `bright-gearbox-402817.ecommerce_retention.online_retail_raw`;

-- | Row | invalid_invoice_date	| minimum_invoice_datetime | maximum_invoice_datetime |
-- |-----|----------------------|--------------------------|--------------------------|
-- | 1   | 541910               | 2009-12-01T07:45:00      | 2010-12-09T20:01:00      |
