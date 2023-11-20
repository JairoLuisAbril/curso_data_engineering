
SELECT *
FROM {{ ref('stg_orders') }}
WHERE  estimated_delivery_at_date_utc < created_at_date_utc AND estimated_delivery_at_time_utc < created_at_time_utc
