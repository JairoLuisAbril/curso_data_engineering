{{
  config(
    materialized='view'
  )
}}

WITH src_orders AS (
    SELECT
          order_id
        , user_id
        , address_id
        , CASE
            WHEN status = 'preparing' THEN 'undefined'
            ELSE COALESCE(tracking_id, 'undefined')
          END AS tracking_id
        , TO_DATE(created_at) AS created_at_date
        , TO_TIME(created_at) AS created_at_time_utc
        , TO_DATE(estimated_delivery_at) AS estimated_delivery_at_date
        , TO_TIME(estimated_delivery_at) AS estimated_delivery_at_time_utc
        , TO_DATE(delivered_at) AS delivered_at_date
        , TO_TIME(delivered_at) AS delivered_at_time_utc
        , status::varchar(60) AS status
        , CASE
            WHEN status = 'preparing' THEN 'undefined'
            ELSE COALESCE(shipping_service, 'undefined')
          END AS shipping_service
        , DECODE(
            promo_id,
            'task-force', 'task-force',
            'instruction set', 'instruction set',
            'leverage', 'leverage',
            'Optional', 'optional',
            'Mandatory', 'mandatory',
            'Digitized', 'digitized',
            '', 'no promotion'
          ) AS promo_id
        , shipping_cost::float AS shipping_cost_usd
        , order_cost::float AS order_cost_usd
        , order_total::float AS order_total_usd
        , _fivetran_synced AS date_load

    FROM {{ source('sql_server_dbo', 'orders') }}
),

renamed_casted AS (
    SELECT
        order_id
        , user_id
        , address_id
        , tracking_id
        , created_at_date
        , created_at_time_utc
        , estimated_delivery_at_date
        , estimated_delivery_at_time_utc
        , delivered_at_date
        , delivered_at_time_utc
        , {{ dbt_utils.generate_surrogate_key(['status']) }} AS  status_id
        , status
        , {{ dbt_utils.generate_surrogate_key(['shipping_service']) }} AS shipping_service_id
        , shipping_service
        , {{ dbt_utils.generate_surrogate_key(['promo_id']) }} AS promo_id
        , shipping_cost_usd
        , order_cost_usd
        , order_total_usd
        , date_load

    FROM src_orders  order by order_id

)

SELECT * FROM renamed_casted 