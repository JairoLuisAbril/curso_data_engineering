{{
  config(
    materialized='view'
    ,unique_key='product_id'
  )
}}

WITH src_products AS (
    SELECT          
          product_id::varchar(128) AS product_id 
        , name::varchar(64) AS products_name
        , price::float AS price_usd
        , inventory::integer AS inventory
        , _fivetran_synced AS date_load
    FROM {{ source('sql_server_dbo', 'products') }}

    UNION ALL

    SELECT
         null AS product_id
        , 'No products' AS products_name
        , '0' AS price_usd
        , '0' AS inventory
        , '2023-11-11 11:11:35.851000' AS date_load
    ),

renamed_casted AS (
    SELECT 
           product_id
        ,  products_name
        ,  price_usd
        ,  inventory
        ,  date_load

    FROM src_products
    )

SELECT * FROM renamed_casted