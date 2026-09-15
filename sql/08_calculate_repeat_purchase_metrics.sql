-- Creating customer repeat purchase metrics

CREATE OR REPLACE TABLE
  `bright-gearbox-402817.ecommerce_retention.customer_repeat_purchase_metrics` AS

WITH customer_orders AS (
  SELECT
    customer_id,
    invoice_no,
    MIN(invoice_datetime) AS order_datetime,
    ROUND(SUM(revenue), 2) AS order_revenue

  FROM
    `bright-gearbox-402817.ecommerce_retention.online_retail_clean`

  GROUP BY
    customer_id,
    invoice_no
),

ranked_orders AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY order_datetime, invoice_no
    ) AS order_number

  FROM
    customer_orders
),

customer_metrics AS (
  SELECT
    customer_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_revenue), 2) AS total_customer_revenue,

    MIN(
      IF(order_number = 1, order_datetime, NULL)
    ) AS first_purchase_datetime,

    MIN(
      IF(order_number = 2, order_datetime, NULL)
    ) AS second_purchase_datetime

  FROM
    ranked_orders

  GROUP BY
    customer_id
)

SELECT
  customer_id,
  first_purchase_datetime,
  second_purchase_datetime,
  total_orders,
  total_customer_revenue,
  total_orders >= 2 AS is_repeat_customer,

  DATETIME_DIFF(
    second_purchase_datetime,
    first_purchase_datetime,
    HOUR
  ) AS hours_to_second_purchase,

  ROUND(
    SAFE_DIVIDE(
      DATETIME_DIFF(
        second_purchase_datetime,
        first_purchase_datetime,
        MINUTE
      ),
      1440
    ),
    2
  ) AS days_to_second_purchase

FROM
  customer_metrics;


-- Validating repeat purchase metrics

SELECT
  COUNT(*) AS total_customers,
  COUNTIF(is_repeat_customer) AS repeat_customers,
  COUNTIF(NOT is_repeat_customer) AS one_time_customers,

  ROUND(
    SAFE_DIVIDE(
      COUNTIF(is_repeat_customer),
      COUNT(*)
    ),
    4
  ) AS repeat_purchase_rate,

  ROUND(
    AVG(days_to_second_purchase),
    2
  ) AS average_days_to_second_purchase,

  COUNTIF(
    is_repeat_customer
    AND second_purchase_datetime IS NULL
  ) AS invalid_repeat_records

FROM
  `bright-gearbox-402817.ecommerce_retention.customer_repeat_purchase_metrics`;
