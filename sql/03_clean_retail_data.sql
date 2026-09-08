-- ============================================================
-- Create a cleaned Online Retail II transactions table
-- ============================================================

CREATE OR REPLACE TABLE
  `bright-gearbox-402817.ecommerce_retention.online_retail_clean` AS

WITH typed_data AS (
  SELECT
    NULLIF(TRIM(invoice), '') AS invoice_no,
    NULLIF(TRIM(stock_code), '') AS stock_code,
    NULLIF(TRIM(description), '') AS description,

    SAFE_CAST(
      TRIM(quantity) AS INT64
    ) AS quantity,

    -- The source files contain two different date formats.
    CASE
      -- Text format: DD.MM.YYYY HH:MM
      WHEN source_period = '2009_2010' THEN
        SAFE.PARSE_DATETIME(
          '%d.%m.%Y %H:%M',
          TRIM(invoice_date)
        )

      -- Excel serial date format
      WHEN source_period = '2010_2011' THEN
        DATETIME_ADD(
          DATETIME '1899-12-30 00:00:00',
          INTERVAL CAST(
            ROUND(
              SAFE_CAST(
                REPLACE(TRIM(invoice_date), ',', '.')
                AS NUMERIC
              ) * 86400
            ) AS INT64
          ) SECOND
        )
    END AS invoice_datetime,

    SAFE_CAST(
      REPLACE(TRIM(price), ',', '.') AS NUMERIC
    ) AS unit_price,

    NULLIF(TRIM(customer_id), '') AS customer_id,
    NULLIF(TRIM(country), '') AS country,
    source_period

  FROM
    `bright-gearbox-402817.ecommerce_retention.online_retail_raw`
),

filtered_data AS (
  SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_datetime,
    unit_price,
    customer_id,
    country,
    source_period,
    quantity * unit_price AS revenue

  FROM
    typed_data

  WHERE
    customer_id IS NOT NULL
    AND invoice_no IS NOT NULL
    AND NOT STARTS_WITH(UPPER(invoice_no), 'C')
    AND quantity > 0
    AND unit_price > 0
    AND invoice_datetime IS NOT NULL
),

deduplicated_data AS (
  SELECT
    *
  FROM
    filtered_data

  -- Remove duplicate transaction lines, including duplicates
  -- caused by the overlap between the two source periods.
  QUALIFY
    ROW_NUMBER() OVER (
      PARTITION BY
        invoice_no,
        stock_code,
        description,
        quantity,
        invoice_datetime,
        unit_price,
        customer_id,
        country
      ORDER BY
        source_period
    ) = 1
)

SELECT
  *
FROM
  deduplicated_data;


-- ============================================================
-- Validate the cleaned table
-- ============================================================

WITH duplicate_check AS (
  SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_datetime,
    unit_price,
    customer_id,
    country,
    COUNT(*) AS row_count

  FROM
    `bright-gearbox-402817.ecommerce_retention.online_retail_clean`

  GROUP BY
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_datetime,
    unit_price,
    customer_id,
    country
),

duplicate_summary AS (
  SELECT
    COALESCE(
      SUM(
        IF(row_count > 1, row_count - 1, 0)
      ),
      0
    ) AS remaining_duplicate_rows

  FROM
    duplicate_check
),

quality_summary AS (
  SELECT
    COUNT(*) AS total_clean_rows,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT invoice_no) AS unique_invoices,
    MIN(invoice_datetime) AS minimum_invoice_datetime,
    MAX(invoice_datetime) AS maximum_invoice_datetime,
    ROUND(SUM(revenue), 2) AS total_revenue,

    COUNTIF(
      customer_id IS NULL
      OR invoice_no IS NULL
      OR STARTS_WITH(UPPER(invoice_no), 'C')
      OR quantity <= 0
      OR unit_price <= 0
      OR invoice_datetime IS NULL
    ) AS remaining_quality_issues

  FROM
    `bright-gearbox-402817.ecommerce_retention.online_retail_clean`
)

SELECT
  quality_summary.*,
  duplicate_summary.remaining_duplicate_rows

FROM
  quality_summary

CROSS JOIN
  duplicate_summary;
