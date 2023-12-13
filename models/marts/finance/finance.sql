{{
  config(
    materialized='table'
  )
}}

WITH dim_sellers AS(
    SELECT
        sellers_id
        , first_name
        , last_name
        , salary AS fixed_salary
        , commission
        , date_load
    FROM {{ ref("dim_sellers") }}
),

fact_order_items AS(
        SELECT
        order_item_id
        , price_total_order_item_usd
        , sellers_id
    FROM {{ ref("fact_order_items") }}
)

SELECT
      sellers_id
    , first_name
    , last_name
    , COUNT(DISTINCT order_item_id) AS TOTAL_ORDER_SELLERS
    , SUM (price_total_order_item_usd) AS TOTAL_SALES_SELLERS
    , commission AS COMMISSION_PRC
    , (commission/100)*TOTAL_SALES_SELLERS::decimal(7,1) AS TOTAL_BENEFITS_COMMISSION
    , fixed_salary + TOTAL_BENEFITS_COMMISSION AS CURRENT_SALARY
    , date_load AS DATE
FROM dim_sellers
JOIN fact_order_items
USING(sellers_id)
GROUP BY  sellers_id
        , first_name
        , last_name
        , commission
        , date_load
        , fixed_salary