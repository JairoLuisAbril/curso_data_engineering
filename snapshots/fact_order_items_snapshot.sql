{% snapshot fact_order_items_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='order_item_id',
      strategy='timestamp',
      updated_at='date_load'
    )
}}

WITH stg_order_items AS 
(
    SELECT *
    FROM {{ ref("stg_order_items") }}
    --WHERE date_load = (select max(date_load) from {{ ref('stg_order_items') }})   -- se hace la snapshot incremental

),

stg_products AS 
(
    SELECT 
        product_id,
        price_usd
    FROM {{ ref("stg_products") }}

),

stg_orders AS 
(
    SELECT *
    FROM {{ ref("stg_orders") }}
    --WHERE date_load = (select max(date_load) from {{ ref('stg_orders') }})   -- se hace la snapshot incremental

),

stg_orders_quantity AS (
    SELECT order_id, 
           SUM(quantity) AS total_quantity
    FROM {{ ref('stg_orders') }} 
    JOIN {{ ref('stg_order_items') }} 
    USING(order_id)
    GROUP BY order_id
    ),

union_order_items AS (
    SELECT
          order_item_id
        , sellers_id
        , order_id
        , user_id
        , created_at_date
        , created_at_time_utc
        , product_id
        , quantity
        , total_quantity AS total_quantity_order_item
        , price_usd AS price_unit_product_usd
        , shipping_cost_usd
        , status_id
        , shipping_service_id
        , address_id
        , estimated_delivery_at_date
        , estimated_delivery_at_time_utc
        , delivered_at_date
        , delivered_at_time_utc
        , tracking_id
        , promo_id
        , date_load
    FROM stg_order_items
    JOIN stg_orders
    USING(order_id)
    JOIN stg_products
    USING(product_id)
    JOIN stg_orders_quantity
    USING(order_id)
    order by order_id


)
   
SELECT
          order_item_id
        , order_id
        , sellers_id
        , user_id
        , address_id
        , created_at_date
        , created_at_time_utc
        , product_id
        , quantity AS quantity_products
        , total_quantity_order_item
        , price_unit_product_usd
        , (price_unit_product_usd*quantity) AS price_total_order_item_usd
        , shipping_service_id
        , (shipping_cost_usd*(quantity/total_quantity_order_item))::decimal(7,3) AS shipping_cost_item_usd
        , promo_id        
        , status_id
        , estimated_delivery_at_date
        , estimated_delivery_at_time_utc
        , delivered_at_date
        , delivered_at_time_utc
        , tracking_id
        , date_load
FROM union_order_items   

{% endsnapshot %}