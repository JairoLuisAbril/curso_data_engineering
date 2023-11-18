SELECT *
FROM {{ ref('stg_orders') }} 
WHERE status = 'shipped'  AND estimated_delivery_at is  null 
                            AND delivered_at is not null 
                            AND tracking_id =''
                            AND shipping_service=''