SELECT *
FROM {{ ref('stg_orders') }} 
WHERE status = 'delivered'  AND estimated_delivery_at is null 
                            AND delivered_at is null 
                            AND tracking_id ='' 
                            AND shipping_service=''