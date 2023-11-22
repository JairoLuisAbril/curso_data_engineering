SELECT *
FROM {{ ref('stg_orders') }} 
WHERE status = 'preparing'  AND estimated_delivery_at_date is not null 
                            AND estimated_delivery_at_time_utc is not null 
                            AND delivered_at_date is not null
                            AND delivered_at_time_utc is not null  
                            AND tracking_id is not null 
                            AND shipping_service !=''