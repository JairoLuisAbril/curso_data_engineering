{{
  config(
    materialized='table'
  )
}}

WITH cte_users AS (
    SELECT * 
    FROM {{ref('stg_sql_server_dbo_users') }}
    ),

 cte_address AS (
    SELECT * 
    FROM {{ref('stg_sql_server_dbo_addresses') }}
    )

SELECT
    u.user_id
    , u.first_name
    , u.last_name
    , a.address_id
    , a.zipcode
FROM cte_users u
JOIN cte_address a
ON u.address_id=a.address_id
