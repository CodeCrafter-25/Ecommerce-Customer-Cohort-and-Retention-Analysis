-- Comparing cohorts by first-month retention
-- The incomplete final month is excluded from the ranking.

WITH data_limit AS (
  SELECT
    DATE_TRUNC(
      DATE(MAX(invoice_datetime)),
      MONTH
    ) AS incomplete_month

  FROM
    `bright-gearbox-402817.ecommerce_retention.online_retail_clean`
)

SELECT
  retention.cohort_month,
  retention.cohort_size,
  retention.retained_customers AS month_1_retained_customers,
  retention.retention_rate,
  ROUND(
    retention.retention_rate * 100,
    2
  ) AS retention_rate_percent,
  retention.cohort_revenue AS month_1_revenue,

  DENSE_RANK() OVER (
    ORDER BY retention.retention_rate DESC
  ) AS retention_rank

FROM
  `bright-gearbox-402817.ecommerce_retention.monthly_cohort_retention`
    AS retention

CROSS JOIN
  data_limit

WHERE
  retention.cohort_index = 1
  AND retention.activity_month < data_limit.incomplete_month

ORDER BY
  retention_rank,
  retention.cohort_month;
