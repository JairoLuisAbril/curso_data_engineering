{{
  config(
    materialized='table'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    SELECT     
        {{ dbt_utils.generate_surrogate_key(['promo_id','discount','status','_fivetran_synced']) }} as promo_id
        , promo_id AS name_promo
        , discount
        , status
        , _fivetran_synced AS date_load
    FROM src_promos
    )

SELECT * FROM renamed_casted