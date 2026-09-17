-- ============================================================
-- 1. Creating the cohort-level Tableau dataset
-- ============================================================

CREATE OR REPLACE TABLE
  `bright-gearbox-402817.ecommerce_retention.tableau_cohort_metrics` AS

WITH data_limit AS (
  SELECT
    DATE_TRUNC(
      DATE(MAX(invoice_datetime)),
      MONTH
    ) AS incomplete_final_month

  FROM
    `bright-gearbox-402817.ecommerce_retention.online_retail_clean`
)

SELECT
  metrics.cohort_month,

  FORMAT_DATE(
    '%Y-%m',
    metrics.cohort_month
  ) AS cohort_label,

  metrics.activity_month,

  FORMAT_DATE(
    '%Y-%m',
    metrics.activity_month
  ) AS activity_label,

  metrics.cohort_index,
  metrics.cohort_size,
  metrics.retained_customers,

  ROUND(
    SAFE_DIVIDE(
      metrics.retained_customers,
      metrics.cohort_size
    ),
    4
  ) AS retention_rate,

  ROUND(
    SAFE_DIVIDE(
      metrics.retained_customers,
      metrics.cohort_size
    ) * 100,
    2
  ) AS retention_rate_percent,

  metrics.cohort_revenue,
  metrics.revenue_per_acquired_customer,
  metrics.revenue_per_retained_customer,
  metrics.cumulative_cohort_revenue,
  metrics.cumulative_revenue_per_customer,

  metrics.cohort_month
    < data_limit.incomplete_final_month
    AS is_complete_cohort_month,

  metrics.activity_month
    < data_limit.incomplete_final_month
    AS is_complete_activity_month,

  metrics.cohort_month
    < data_limit.incomplete_final_month
    AND metrics.activity_month
    < data_limit.incomplete_final_month
    AS is_complete_observation

FROM
  `bright-gearbox-402817.ecommerce_retention.cohort_revenue_analysis`
    AS metrics

CROSS JOIN
  data_limit;


-- ============================================================
-- 2. Creating the customer-level Tableau dataset
-- ============================================================

CREATE OR REPLACE TABLE
  `bright-gearbox-402817.ecommerce_retention.tableau_customer_metrics` AS

SELECT
  customer_id,

  DATE(first_purchase_datetime) AS first_purchase_date,

  DATE_TRUNC(
    DATE(first_purchase_datetime),
    MONTH
  ) AS first_purchase_month,

  DATE(second_purchase_datetime) AS second_purchase_date,

  total_orders,
  total_customer_revenue,
  is_repeat_customer,
  hours_to_second_purchase,
  days_to_second_purchase,

  IF(
    is_repeat_customer,
    'Repeat customer',
    'One-time customer'
  ) AS customer_type,

  CASE
    WHEN NOT is_repeat_customer
      THEN 'No repeat purchase'
    WHEN days_to_second_purchase <= 30
      THEN '0–30 days'
    WHEN days_to_second_purchase <= 60
      THEN '31–60 days'
    WHEN days_to_second_purchase <= 90
      THEN '61–90 days'
    WHEN days_to_second_purchase <= 180
      THEN '91–180 days'
    ELSE '181+ days'
  END AS second_purchase_interval,

  CASE
    WHEN NOT is_repeat_customer THEN 0
    WHEN days_to_second_purchase <= 30 THEN 1
    WHEN days_to_second_purchase <= 60 THEN 2
    WHEN days_to_second_purchase <= 90 THEN 3
    WHEN days_to_second_purchase <= 180 THEN 4
    ELSE 5
  END AS second_purchase_interval_order

FROM
  `bright-gearbox-402817.ecommerce_retention.customer_repeat_purchase_metrics`;


-- ============================================================
-- 3. Validating the Tableau datasets
-- ============================================================

SELECT
  'tableau_cohort_metrics' AS table_name,
  COUNT(*) AS row_count,

  COUNTIF(
    cohort_month IS NULL
    OR activity_month IS NULL
    OR cohort_index IS NULL
    OR retention_rate IS NULL
    OR cohort_revenue IS NULL
  ) AS invalid_rows

FROM
  `bright-gearbox-402817.ecommerce_retention.tableau_cohort_metrics`

UNION ALL

SELECT
  'tableau_customer_metrics' AS table_name,
  COUNT(*) AS row_count,

  COUNTIF(
    customer_id IS NULL
    OR first_purchase_date IS NULL
    OR total_orders <= 0
    OR total_customer_revenue <= 0
  ) AS invalid_rows

FROM
  `bright-gearbox-402817.ecommerce_retention.tableau_customer_metrics`;

