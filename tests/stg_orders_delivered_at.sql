
SELECT *
FROM {{ ref('stg_orders') }}
WHERE delivered_at_date_utc < created_at_date_utc AND delivered_at_time_utc < created_at_time_utc



