SELECT
    order_cost_usd,
    shipping_cost_usd,
    order_total_usd,
    discount
FROM {{ ref('stg_orders') }}
JOIN {{ ref('stg_promos') }}
USING(promo_id)
WHERE (order_cost_usd + shipping_cost_usd) - discount != order_total_usd

