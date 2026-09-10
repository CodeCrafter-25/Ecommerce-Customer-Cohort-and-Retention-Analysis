CREATE OR REPLACE TABLE
  `bright-gearbox-402817.ecommerce_retention.customer_cohort_base` AS

WITH customer_monthly_activity AS (
  SELECT
    customer_id,
    DATE_TRUNC(
      DATE(invoice_datetime),
      MONTH
    ) AS activity_month,

    COUNT(DISTINCT invoice_no) AS order_count,
    SUM(quantity) AS units_purchased,
    ROUND(SUM(revenue), 2) AS monthly_revenue

  FROM
    `bright-gearbox-402817.ecommerce_retention.online_retail_clean`

  GROUP BY
    customer_id,
    activity_month
),

cohort_assignment AS (
  SELECT
    *,
    MIN(activity_month) OVER (
      PARTITION BY customer_id
    ) AS cohort_month

  FROM
    customer_monthly_activity
)

SELECT
  customer_id,
  cohort_month,
  activity_month,

  DATE_DIFF(
    activity_month,
    cohort_month,
    MONTH
  ) AS cohort_index,

  order_count,
  units_purchased,
  monthly_revenue

FROM
  cohort_assignment;


-- checking the table 'customer_cohort_base'
SELECT
  COUNT(*) AS customer_month_rows,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNT(DISTINCT cohort_month) AS cohort_count,
  MIN(cohort_month) AS first_cohort_month,
  MAX(activity_month) AS last_activity_month,
  MIN(cohort_index) AS minimum_cohort_index,
  MAX(cohort_index) AS maximum_cohort_index,
  COUNTIF(cohort_index < 0) AS invalid_cohort_rows

FROM
  `bright-gearbox-402817.ecommerce_retention.customer_cohort_base`;
-- result: first_cohort_month: 2009-12-01, last_activity_month: 2011-12-01, minimum_cohort_index: 0, invalid_cohort_rows: 0.


-- Vetting each client's startup.
WITH customer_start AS (
  SELECT
    customer_id,
    MIN(cohort_index) AS first_cohort_index
  FROM
    `bright-gearbox-402817.ecommerce_retention.customer_cohort_base`
  GROUP BY
    customer_id
)

SELECT
  COUNTIF(first_cohort_index != 0) AS customers_without_cohort_zero
FROM
  customer_start;
-- result = 0.


