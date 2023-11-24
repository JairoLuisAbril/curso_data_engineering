{{
  config(
    materialized='view'
    , unique_key='promo_id'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    SELECT     
         lower(promo_id) AS promo_id
        , discount
        , status
        , _fivetran_synced AS date_load
    FROM src_promos

    UNION ALL

    SELECT
         'no promotion' 
        , 0 
        , 'inactive' 
        , '2023-11-11 11:11:35.244000' 
    ),

renamed_cast AS(
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['promo_id']) }} AS promo_id
        , promo_id AS promo_name
        , discount::decimal AS discount
        , status::varchar(60) AS status
        , date_load
    
    FROM renamed_casted
    )

SELECT * FROM renamed_cast