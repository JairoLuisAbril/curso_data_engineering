
SELECT *
FROM {{ ref('stg_orders') }}
WHERE  status='preparing' and tracking_id is null
