SELECT *
FROM {{ ref('stg_orders') }} 
WHERE status = 'preparing'  AND estimated_delivery_at is not null 
                            AND delivered_at is not null 
                            AND tracking_id is not null 
                            AND shipping_service !=''