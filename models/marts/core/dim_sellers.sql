{{
  config(
    materialized='table'
  )
}}

WITH stg_sellers AS (
    SELECT DISTINCT *
    FROM {{ ref('stg_sellers') }}
)

SELECT *
FROM stg_sellers