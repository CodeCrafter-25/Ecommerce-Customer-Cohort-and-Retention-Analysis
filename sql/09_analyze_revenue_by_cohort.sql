-- Creating cohort revenue analysis table

CREATE OR REPLACE TABLE
  `bright-gearbox-402817.ecommerce_retention.cohort_revenue_analysis` AS

WITH revenue_metrics AS (
  SELECT
    cohort_month,
    activity_month,
    cohort_index,
    cohort_size,
    retained_customers,
    cohort_revenue,

    SUM(cohort_revenue) OVER (
      PARTITION BY cohort_month
      ORDER BY cohort_index
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_cohort_revenue

  FROM
    `bright-gearbox-402817.ecommerce_retention.monthly_cohort_retention`
)

SELECT
  cohort_month,
  activity_month,
  cohort_index,
  cohort_size,
  retained_customers,
  cohort_revenue,

  ROUND(
    SAFE_DIVIDE(
      cohort_revenue,
      cohort_size
    ),
    2
  ) AS revenue_per_acquired_customer,

  ROUND(
    SAFE_DIVIDE(
      cohort_revenue,
      retained_customers
    ),
    2
  ) AS revenue_per_retained_customer,

  ROUND(
    cumulative_cohort_revenue,
    2
  ) AS cumulative_cohort_revenue,

  ROUND(
    SAFE_DIVIDE(
      cumulative_cohort_revenue,
      cohort_size
    ),
    2
  ) AS cumulative_revenue_per_customer

FROM
  revenue_metrics;


-- Validating cohort revenue metrics

SELECT
  COUNT(*) AS revenue_rows,

  COUNTIF(
    cohort_revenue IS NULL
    OR cohort_revenue <= 0
  ) AS invalid_cohort_revenue,

  COUNTIF(
    revenue_per_acquired_customer IS NULL
    OR revenue_per_acquired_customer <= 0
  ) AS invalid_revenue_per_acquired_customer,

  COUNTIF(
    revenue_per_retained_customer IS NULL
    OR revenue_per_retained_customer <= 0
  ) AS invalid_revenue_per_retained_customer,

  COUNTIF(
    cumulative_cohort_revenue < cohort_revenue
  ) AS invalid_cumulative_revenue

FROM
  `bright-gearbox-402817.ecommerce_retention.cohort_revenue_analysis`;
