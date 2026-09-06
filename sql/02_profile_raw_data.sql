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
