CREATE OR REPLACE TABLE
  `bright-gearbox-402817.ecommerce_retention.monthly_cohort_retention` AS

WITH cohort_activity AS (
  SELECT
    cohort_month,
    activity_month,
    cohort_index,
    COUNT(DISTINCT customer_id) AS retained_customers,
    ROUND(SUM(monthly_revenue), 2) AS cohort_revenue

  FROM
    `bright-gearbox-402817.ecommerce_retention.customer_cohort_base`

  GROUP BY
    cohort_month,
    activity_month,
    cohort_index
),

cohort_sizes AS (
  SELECT
    cohort_month,
    COUNT(DISTINCT customer_id) AS cohort_size

  FROM
    `bright-gearbox-402817.ecommerce_retention.customer_cohort_base`

  WHERE
    cohort_index = 0

  GROUP BY
    cohort_month
)

SELECT
  activity.cohort_month,
  activity.activity_month,
  activity.cohort_index,
  sizes.cohort_size,
  activity.retained_customers,

  ROUND(
    SAFE_DIVIDE(
      activity.retained_customers,
      sizes.cohort_size
    ),
    4
  ) AS retention_rate,

  activity.cohort_revenue

FROM
  cohort_activity AS activity

LEFT JOIN
  cohort_sizes AS sizes
USING
  (cohort_month);


SELECT
  COUNT(*) AS retention_rows,

  COUNTIF(
    cohort_index = 0
    AND retained_customers != cohort_size
  ) AS invalid_cohort_sizes,

  COUNTIF(
    cohort_index = 0
    AND retention_rate != 1
  ) AS invalid_initial_retention,

  COUNTIF(
    retention_rate < 0
    OR retention_rate > 1
  ) AS invalid_retention_rates

FROM
  `bright-gearbox-402817.ecommerce_retention.monthly_cohort_retention`;



SELECT
  cohort_month,
  cohort_index,
  cohort_size,
  retained_customers,
  retention_rate,
  cohort_revenue

FROM
  `bright-gearbox-402817.ecommerce_retention.monthly_cohort_retention`

ORDER BY
  cohort_month,
  cohort_index

LIMIT 50;





