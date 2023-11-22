{{ config(
  materialized='table'
) }}

WITH dim_date_month AS 
(
  {{ dbt_date.get_date_dimension("2019-01-01", "2060-12-31") }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['date_day']) }} date_id
    , date_day AS date
    , day_of_week_name AS day_of_week
    , day_of_month
    , week_of_year
    , month_of_year
    , year_number
    , quarter_of_year AS quarter_of_the_year
FROM dim_date_month