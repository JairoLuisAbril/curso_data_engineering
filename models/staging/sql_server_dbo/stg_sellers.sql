{{
  config(
    materialized='view'
  )
}}

WITH src_sellers AS (
    SELECT           
          {{ dbt_utils.generate_surrogate_key(['sellers_id']) }} AS sellers_id
        , first_name::varchar(50) AS first_name
        , last_name::varchar(50) AS last_name
        , salary::decimal AS salary
        , commission::int AS commission
        , {{ dbt_utils.generate_surrogate_key(['address_id']) }} AS address_id
        , TO_DATE(contract_start_date) AS contract_start_date_at_date
        , TO_TIME(contract_start_date) AS contract_start_date_at_time_utc
        , TO_DATE(contract_end_date) AS contract_end_date_at_date
        , TO_TIME(contract_end_date) AS contract_end_date_at_time_utc
        , _fivetran_synced AS date_load 
    FROM {{ source('sql_server_dbo', 'sellers') }}
    ),

renamed_casted AS (
    SELECT *
    FROM src_sellers
    )

SELECT * FROM renamed_casted