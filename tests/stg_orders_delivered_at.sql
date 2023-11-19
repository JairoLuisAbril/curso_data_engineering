
SELECT *
FROM {{ ref('stg_orders') }}
WHERE delivered_at_date < created_at_date AND delivered_at_time < created_at_time

/* comprueba si hay algún caso en el que la fecha de entrega sea anterior a la fecha en que se realizó el pedido, lo que no tendría sentido lógico e indicaría algún tipo de problema con los datos */


