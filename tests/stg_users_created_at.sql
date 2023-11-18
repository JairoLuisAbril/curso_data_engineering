SELECT *
FROM {{ ref('stg_users') }}
WHERE updated_at < created_at