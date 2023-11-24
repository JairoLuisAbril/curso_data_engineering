{{
  config(
    materialized='view'
  )
}}

WITH src_order_items AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'order_items') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['order_id', 'product_id']) }} AS order_item_id
        ,  order_id
        , product_id
        , quantity::integer AS quantity
        , _fivetran_synced AS date_load
    FROM src_order_items
    )

SELECT * FROM renamed_casted order by order_id