
{{
  config(
    materialized='view'
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
            order_id  
          , user_id
          , address_id
          , CASE 
              WHEN status = 'preparing' THEN 'undefined'
              ELSE COALESCE(tracking_id, 'undefined')
            END AS tracking_id 
          , to_date(created_at) AS created_at_date
          , to_time(created_at) AS created_at_time
          , to_date(estimated_delivery_at) AS estimated_delivery_at_date
          , to_time(estimated_delivery_at) AS estimated_delivery_at_time
          , to_date(delivered_at) AS delivered_at_date
          , to_time(delivered_at) AS delivered_at_time
          , status AS status          
          , CASE
              WHEN status = 'preparing' THEN 'undefined'
              ELSE COALESCE(shipping_service, 'undefined')
            END AS shipping_service
          , decode
            (promo_id,
            'task-force', 'task-force',
            'instruction set', 'instruction set',
            'leverage', 'leverage',
            'Optional', 'optional',
            'Mandatory', 'mandatory',
            'Digitized', 'digitized',
            '','no promotion') AS promo_name
          , {{ dbt_utils.generate_surrogate_key(['promo_name']) }} AS promo_id
          , shipping_cost::float AS shipping_cost
          , order_cost::float AS order_cost
          , order_total
          , _fivetran_synced AS date_load
    FROM src_orders 

 /*   UNION ALL

    SELECT 
         {{ dbt_utils.generate_surrogate_key(['promo_name']) }} AS promo_id
    from src_orders*/
)



SELECT * FROM renamed_casted 