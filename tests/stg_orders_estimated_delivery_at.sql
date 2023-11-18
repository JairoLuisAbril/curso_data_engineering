
SELECT *
FROM {{ ref('stg_orders') }}
WHERE  estimated_delivery_at < created_at
