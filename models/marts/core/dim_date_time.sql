{{ config(
  materialized='table'
) }}

WITH dim_date_time AS 
(
    {{ dbt_utils.date_spine(
    datepart="second",
    start_date="cast('00:00:00' as time)",
    end_date="cast('23:59:59' as time)"
   )
}}
)

SELECT
     {{ dbt_utils.generate_surrogate_key(['date_second']) }} time_id
    , date_second AS time
    , CASE 
        WHEN date_second < '12:00:00' THEN 'am'
        ELSE 'pm' END AS am_or_pm
    , extract (hour from date_second) AS hour_time

FROM dim_date_time