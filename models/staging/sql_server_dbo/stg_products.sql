{{
  config(
    materialized='view'
  )
}}

WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
    ),

renamed_casted AS (
    SELECT
          product_id::varchar(128) AS product_id 
        , name::varchar(64) AS name_products 
        , price::float AS products_price_usd
        , inventory::integer AS inventory_products
        , _fivetran_synced AS date_load
    FROM src_products
    )

SELECT * FROM renamed_casted