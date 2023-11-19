{{ config(
  materialized='table'
) }}

WITH dim_date_month AS 
(
  {{ dbt_date.get_date_dimension("2019-01-01", "2060-12-31") }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['date_day']) }} date_key
    , date_day as date
    , day_of_month
    , month_of_year
    , year_number
    , day_of_week_name as day_of_week
    , week_of_year
    , quarter_of_year
FROM dim_date_month