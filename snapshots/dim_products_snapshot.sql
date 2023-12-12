{% snapshot dim_products_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='product_id',
      strategy='timestamp',
      updated_at='date_load',
    )
}}


WITH stg_products AS (
    SELECT DISTINCT product_id,date_load
    FROM {{ ref('stg_products') }}
),

stg_budget AS (
    SELECT DISTINCT product_id,date_load
    FROM {{ ref('stg_budget') }}
),

stg_events AS (
    SELECT DISTINCT product_id,date_load
    FROM {{ ref('stg_events') }}
),

products_all_with_duplicates AS (
    SELECT *
    FROM stg_products
    UNION ALL
    SELECT *
    FROM stg_budget
    UNION ALL
    SELECT *
    FROM stg_events
),

removing_duplicates AS (
    SELECT DISTINCT product_id
    FROM products_all_with_duplicates
)

    SELECT 
           product_id
        ,  products_name
        ,  price_usd
        ,  inventory
        ,  date_load

    FROM removing_duplicates
    FULL JOIN
    {{ ref('stg_products') }} AS stg_products
    USING (product_id)

{% endsnapshot %}