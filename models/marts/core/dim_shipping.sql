{{
  config(
    materialized='table'
  )
}}

WITH shipping_services AS (
    SELECT DISTINCT
        shipping_service_id,
        shipping_service,
        sum(shipping_cost_usd) AS total_shipping_cost_usd,
        count(shipping_service) AS total_shipping_service,
        avg(shipping_cost_usd) AS avg_shipping_service_cost

    FROM {{ ref('stg_orders') }}
    GROUP BY shipping_service_id, shipping_service
)

SELECT
    shipping_service_id,
    shipping_service,
    total_shipping_cost_usd,
    total_shipping_service,
    avg_shipping_service_cost
FROM shipping_services
