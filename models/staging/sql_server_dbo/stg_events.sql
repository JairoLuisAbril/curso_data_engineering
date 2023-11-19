{{
  config(
    materialized='view'
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
        , CASE 
            WHEN order_id='' then 'wihtout order_id'
            ELSE order_id
            END AS order_id
        , user_id
        , CASE 
            WHEN product_id='' then 'wihtout product_id selected'
            ELSE product_id
            END AS product_id
        , session_id
        , to_date(created_at) AS created_at_date
        , to_time(created_at) AS created_at_time
        , page_url::varchar(128) AS page_url
        , _fivetran_synced AS date_load
    FROM src_events
    )

SELECT * FROM renamed_casted