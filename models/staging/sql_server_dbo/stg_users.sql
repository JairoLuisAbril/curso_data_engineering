{{
  config(
    materialized='view'
    , unique_key='user_id'
  )
}}

WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

renamed_casted AS (
    SELECT
          user_id
        , first_name::varchar(64) as first_name
        , last_name::varchar(64) as last_name
        , address_id
        , phone_number::varchar(64) AS phone_number
        , email::varchar(64) AS email 
        , to_date(created_at) AS created_at_date
        , to_time(created_at) AS created_at_time_utc
        , to_date(updated_at) AS updated_at_date
        , to_time(updated_at) AS updated_at_time_utc
        , _fivetran_synced AS date_load
    FROM src_users
    )

SELECT * FROM renamed_casted