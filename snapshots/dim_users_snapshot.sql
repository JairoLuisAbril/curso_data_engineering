{% snapshot dim_users_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='user_id',
      strategy='timestamp',
      updated_at='date_load'
    )
}}


WITH distinct_stg_users AS
(
    SELECT DISTINCT(user_id)
    FROM {{ ref('stg_users') }}
),

distinct_stg_events AS 
(
    SELECT DISTINCT(user_id)
    FROM {{ ref('stg_events') }}
),

distinct_stg_orders AS 
(
    SELECT DISTINCT(user_id)
    FROM {{ ref('stg_orders') }}
),

union_all_with_duplicates AS 
(
    SELECT *
    FROM distinct_stg_users
    UNION ALL
    SELECT *
    FROM distinct_stg_events
    UNION ALL
    SELECT *
    FROM distinct_stg_orders
),

removing_duplicates AS 
(
    SELECT DISTINCT(user_id)
    FROM union_all_with_duplicates
)

SELECT *
FROM removing_duplicates
FULL JOIN
{{ ref('stg_users') }} AS users
USING (user_id)

{% endsnapshot %}