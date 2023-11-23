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
    event_id,
    event_type_id,
    user_id,
    session_id,
    order_id,
    product_id,
    {{ dbt_utils.generate_surrogate_key(['created_at_date']) }} AS created_date_id,
    {{ dbt_utils.generate_surrogate_key(['created_at_time_utc']) }} AS created_time_id
FROM stg_events