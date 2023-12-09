{% snapshot dim_sellers_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='sellers_id',
      strategy='timestamp',
      updated_at='date_load',
    )
}}

WITH distinct_stg_sellers AS (
    SELECT DISTINCT (sellers_id)
    FROM {{ ref('stg_sellers') }}
),

distinct_stg_orders AS (
    SELECT DISTINCT (sellers_id)
    FROM {{ ref('stg_orders') }}
),

union_all_with_duplicates AS 
(
    SELECT *
    FROM distinct_stg_sellers
    UNION ALL
    SELECT *
    FROM distinct_stg_orders
),

removing_duplicates AS 
(
    SELECT DISTINCT(sellers_id)
    FROM union_all_with_duplicates
)

SELECT *
FROM removing_duplicates
FULL JOIN
{{ ref('stg_sellers') }} AS sellers
USING (sellers_id)



{% endsnapshot %}
