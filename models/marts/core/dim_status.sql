{{ config(
  materialized='table'
) }}

WITH stg_status AS 
(
    SELECT DISTINCT(status)
    FROM stg_orders
)

SELECT  *

FROM stg_status