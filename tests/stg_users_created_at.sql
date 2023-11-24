SELECT *
FROM {{ ref('stg_users') }}
WHERE updated_at_date < created_at_date AND updated_at_time_utc < created_at_time_utc