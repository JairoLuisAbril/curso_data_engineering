{{
  config(
    materialized='view' 
  )
}}

WITH stg_order_items AS
(
    SELECT *
    FROM {{ref("fact_order_items_snapshot")}}

/*{% if is_incremental() %}

	  where fact_order_items_snapshot.date_load > (select max(this.date_load) from {{ this }} as this)

{% endif %}*/

)


SELECT *
FROM stg_order_items
WHERE dbt_valid_to IS NULL
