{{
  config(
    materialized='table'
  )
}}

WITH dim_users_snapshot AS 
(
    SELECT * 
    FROM {{ ref('dim_users_snapshot') }}
)

    select     
    {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_id_key
    , first_name
    , last_name
    , address_id
    , email
    , phone_number
    , created_at_date
    , created_at_time_utc
    , updated_at_date
    , updated_at_time_utc
    from dim_users_snapshot
    where dbt_valid_to is null