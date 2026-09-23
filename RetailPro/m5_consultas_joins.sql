-- Semana 5- Consultas con JOIN y UNION
-- cruzamos las tablas de RetailPro para mejorar el análisis
-- y preparar la información para el Power BI


-- Consulta 1 - Vista base del proyecto
-- una vista completa de cada operación y poder usarla en Power BI

SELECT
    v.fecha_venta,
    v.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.nombre_producto,
    ca.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias ca
    ON p.id_categoria = ca.id_categoria;


-- Consulta 2 Clientes sin ventas
-- Busco clientes registrados que no realizaron ninguna compra

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


-- Consulta 3 Productos sin ventas
-- busco los productos que todavía no registraron ninguna venta

SELECT
    p.nombre_producto,
    ca.nombre_categoria AS categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
LEFT JOIN categorias ca
    ON p.id_categoria = ca.id_categoria
WHERE v.id_venta IS NULL;


-- Consulta 4 - Consolidado por canal
-- Como mi modelo no tiene un canal de venta, creo 2 grupos a partir
-- de los períodos disponibles para aplicar UNION ALL sin inventar datos.
-- Uso un CTE para organizar la consulta y luego junto las ventas por canal

WITH ventas_por_canal AS (

    SELECT
        v.fecha_venta,
        (v.cantidad * v.precio_unitario) AS total_venta,
        'Primer período' AS canal
    FROM ventas v
    WHERE v.fecha_venta BETWEEN '2024-03-05' AND '2024-03-10'

    UNION ALL

    SELECT
        v.fecha_venta,
        (v.cantidad * v.precio_unitario) AS total_venta,
        'Segundo período' AS canal
    FROM ventas v
    WHERE v.fecha_venta BETWEEN '2024-03-11' AND '2024-03-15'
)

SELECT
    canal,
    SUM(total_venta) AS ventas_totales
FROM ventas_por_canal
GROUP BY canal;