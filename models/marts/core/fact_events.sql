{{
  config(
    materialized='table'
  )
}}

WITH stg_events AS 
(
    SELECT *
    FROM {{ ref("stg_events") }}
)

SELECT
    event_id
    , event_type_id
    , page_url
    , user_id
    , session_id
    , order_id
    , product_id
    , created_at_date
    , created_at_time_utc
FROM stg_events