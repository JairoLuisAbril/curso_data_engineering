
{{
  config(
    materialized='table'
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
          order_id
        ,tracking_id
        , user_id 
        , created_at
        , address_id
        , estimated_delivery_at
        , delivered_at 
        , shipping_service
        , status
        , promo_id
        , shipping_cost
        , order_cost
        , order_total
        , _fivetran_synced AS date_load
    FROM src_orders
    )

SELECT * FROM renamed_casted