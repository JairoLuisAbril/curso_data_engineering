{{ config(
  materialized='table'
) }}

WITH stg_status AS 
(
    SELECT DISTINCT(status)
    FROM {{ ref('stg_orders') }}
)

SELECT       
    {{ dbt_utils.generate_surrogate_key(['status']) }} AS  status_id
    , status
FROM stg_status