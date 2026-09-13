-- Overall weighted retention by month after acquisition

WITH retention_curve AS (
  SELECT
    cohort_index,
    COUNT(*) AS observed_cohorts,
    SUM(cohort_size) AS total_cohort_customers,
    SUM(retained_customers) AS retained_customers,

    ROUND(
      SAFE_DIVIDE(
        SUM(retained_customers),
        SUM(cohort_size)
      ),
      4
    ) AS weighted_retention_rate

  FROM
    `bright-gearbox-402817.ecommerce_retention.monthly_cohort_retention`

  GROUP BY
    cohort_index
)

SELECT
  cohort_index,
  observed_cohorts,
  total_cohort_customers,
  retained_customers,
  weighted_retention_rate,

  ROUND(
    weighted_retention_rate
    - LAG(weighted_retention_rate) OVER (
        ORDER BY cohort_index
      ),
    4
  ) AS change_from_previous_month

FROM
  retention_curve

ORDER BY
  cohort_index;
