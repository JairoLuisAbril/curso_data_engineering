{{
  config(
    materialized='table'
  )
}}

WITH stg_promos AS (
    SELECT *
    FROM {{ ref('stg_promos') }}
)

SELECT *
FROM stg_promos