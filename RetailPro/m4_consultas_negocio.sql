-- Módulo 4 - Consultas SQL de negocio
-- RetailPro
-- Alumna: Agustina Villegas

-- Consulta 1: Resumen ejecutivo mensual

SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- Consulta 2: Ranking de productos

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- Consulta 3: Clientes recurrentes

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- Consulta 4: Meses por encima o por debajo del promedio

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,

    -- comparo lo que se facturo en cada mes con el promedio mensual
    CASE
        WHEN SUM(cantidad * precio_unitario) > 
            (
                -- primero calculo el promedio de los totales mensuales
                SELECT AVG(total_mensual)
                FROM (
                    -- sumo cuanto se facturo en cada mes
                    SELECT SUM(cantidad * precio_unitario) AS total_mensual
                    FROM ventas
                    GROUP BY MONTH(fecha_venta)
                ) AS resumen_mensual
            )
        THEN 'Por encima'

        WHEN SUM(cantidad * precio_unitario) <
            (
                -- vuelvo a comparar con el promedio mensual
                SELECT AVG(total_mensual)
                FROM (
                    SELECT SUM(cantidad * precio_unitario) AS total_mensual
                    FROM ventas
                    GROUP BY MONTH(fecha_venta)
                ) AS resumen_mensual
            )
        THEN 'Por debajo'

        -- Si no es mayor ni menor, es igual al promedio
        ELSE 'Igual al promedio'

    END AS comparacion_promedio

FROM ventas
GROUP BY MONTH(fecha_venta);

-- Hallazgos principales:
-- 1. El producto 1 fue el que más facturó, con $3600 en total
-- 2. El cliente 1 fue el que más gastó, con $2640 en 2 pedidos
-- 3. Todas las ventas son de marzo, por eso el total del mes es igual al promedio mensual
