{{
  config(
    materialized='table'
  )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
    ),

renamed_casted AS (
    SELECT
          event_id
        , event_type
        , order_id
        , user_id
        , product_id
        , session_id
        , created_at
        , page_url
        , _fivetran_synced AS date_load
    FROM src_events
    )

SELECT * FROM renamed_casted