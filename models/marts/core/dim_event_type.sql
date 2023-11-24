{{
  config(
    materialized='table'
  )
}}

WITH stg_event_types_id AS (
    SELECT DISTINCT event_type_id,event_type
    FROM {{ ref('stg_events') }}
)

SELECT *
FROM stg_event_types_id