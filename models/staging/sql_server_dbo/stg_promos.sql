{{
  config(
    materialized='view'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    SELECT     
         promo_id::varchar(60) AS promo_name
        , discount
        , status
        , _fivetran_synced AS date_load
    FROM src_promos

    UNION ALL

    SELECT
         'no promotion' AS promo_name
        , 0 AS discount
        , 'inactive' AS status
        , '2023-11-11 11:11:35.244000' AS date_load
    ),

renamed_cast AS(
    SELECT 
          decode(
            promo_name
            , 'task-force', 'task-force'
            , 'instruction set', 'instruction set'
            , 'leverage', 'leverage'
            , 'Optional', 'optional'
            , 'Mandatory', 'mandatory'
            , 'Digitized', 'digitized'
            , 'no promotion', 'no promotion') AS promo_name
        ,{{ dbt_utils.generate_surrogate_key(['promo_name']) }} AS promo_id
        , discount::decimal AS discount
        , status::varchar(60) AS status
        , date_load
    
    FROM renamed_casted
    )

SELECT * FROM renamed_cast