SELECT *
FROM {{ ref('stg_orders') }} 
WHERE status = 'shipped'    AND estimated_delivery_at_date_utc is null 
                            AND estimated_delivery_at_time_utc is null 
                            AND delivered_at_date_utc is not null
                            AND delivered_at_time_utc is not null  
                            AND tracking_id =''
                            AND shipping_service=''