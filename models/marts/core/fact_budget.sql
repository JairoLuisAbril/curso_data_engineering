{{
  config(
    materialized='table'
  )
}}

WITH stg_budget AS 
(
    SELECT *
    FROM {{ ref('stg_budget') }}
)

SELECT *
FROM stg_budget