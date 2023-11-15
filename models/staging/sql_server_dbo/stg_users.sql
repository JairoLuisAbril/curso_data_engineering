{{
  config(
    materialized='table'
  )
}}

WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

renamed_casted AS (
    SELECT
          user_id
        , updated_at
        , first_name
        , last_name
        , address_id 
        , phone_number
        , email        
        , created_at
        , total_orders
        , _fivetran_synced AS date_load
    FROM src_users
    )

SELECT * FROM renamed_casted