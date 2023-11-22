{{
  config(
    materialized='table'
  )
}}

WITH stg_addresses AS 
(
    SELECT DISTINCT address_id
    FROM {{ ref('stg_addresses') }}
),

stg_users AS 
(
    SELECT DISTINCT address_id 
    FROM {{ ref('stg_users') }}
),

address_all_with_duplicates AS 
(
    SELECT *
    FROM stg_addresses
    UNION ALL
    SELECT *
    FROM stg_users
),

removing_duplicates AS 
(
    SELECT DISTINCT(address_id)
    FROM address_all_with_duplicates
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['address_id']) }} AS address_id_key
    , address
    , zipcode
    , state
    , country
    , date_load
FROM removing_duplicates
FULL JOIN {{ ref('stg_addresses') }}
USING(address_id)