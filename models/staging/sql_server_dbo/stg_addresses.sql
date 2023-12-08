{{
  config(
     materialized='view'
    ,unique_key='address_id'
  )
}}

WITH src_addresses AS (
    SELECT          
          {{ dbt_utils.generate_surrogate_key(['address_id'])}} AS address_id
        , address::varchar(64) AS address 
        , country::varchar(64) AS country 
        , state::varchar(64) AS state 
        , zipcode::integer AS zipcode
        , _fivetran_synced AS date_load
    FROM {{ source('sql_server_dbo', 'addresses') }}
    ),

renamed_casted AS (
    SELECT*
    FROM src_addresses
    )

SELECT * FROM renamed_casted