SELECT *
FROM {{ ref('stg_orders') }} 
WHERE status = 'shipped'    AND estimated_delivery_at_date is null 
                            AND estimated_delivery_at_time is null 
                            AND delivered_at_date is not null
                            AND delivered_at_time is not null  
                            AND tracking_id =''
                            AND shipping_service=''