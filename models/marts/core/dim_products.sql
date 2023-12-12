{{
  config(
    materialized='table'
  )
}}

WITH dim_products_snapshot AS (
    SELECT *
    FROM {{ ref('dim_products_snapshot') }}
)

SELECT 
       product_id
    ,  products_name
    ,  price_usd
    ,  inventory
    ,  date_load
FROM dim_products_snapshot
WHERE dbt_valid_to IS NULL AND products_name IS NOT NULL