{{
  config(
    materialized='table'
  )
}}

WITH stg_users AS 
(
    SELECT DISTINCT user_id
    FROM {{ ref('stg_users') }}
),

stg_orders AS 
(
    SELECT DISTINCT user_id 
    FROM {{ ref('stg_orders') }}
),

stg_events AS 
(
    SELECT DISTINCT user_id 
    FROM {{ ref('stg_events') }}
),

user_all_with_duplicates AS(
    SELECT *
    FROM stg_users
    UNION ALL
    SELECT * 
    FROM stg_orders
    UNION ALL
    SELECT *
    FROM stg_events
),

removing_duplicates_users AS(
    SELECT DISTINCT(user_id)
    FROM user_all_with_duplicates
),

unit_all as(
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
    from removing_duplicates_users
    FULL JOIN {{ ref('stg_users') }}
    USING(user_id)
)

SELECT*
FROM unit_all
