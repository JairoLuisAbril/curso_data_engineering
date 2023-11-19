{{
  config(
    materialized='table'
  )
}}

WITH stg_users AS 
(
    SELECT *
    FROM {{ ref('stg_users') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_id_key
    , first_name
    , last_name
    , email
    , phone_number
    , address_id
    , created_at_date
    , created_at_time
    , updated_at_date
    , updated_at_time
FROM stg_users