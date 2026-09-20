-- ============================================================================
-- Nombre del archivo: m5_consultas_joins.sql
-- Módulo: M5 — Consultas con JOINs para el proyecto
-- Base de Datos: Ventas_Tech_DB (RetailPro / TechStore)
-- Autor: Santiago Traverso Oliva
-- Descripción: Enriquecimiento analítico con INNER JOIN, detección de registros
--              huérfanos con LEFT JOIN y consolidación de orígenes con UNION ALL.
-- ============================================================================

USE Ventas_Tech_DB;
GO

-- ----------------------------------------------------------------------------
-- PASO PREVIO: Garantizar casos de prueba para LEFT JOIN (Consultas 2 y 3)
-- ----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM clientes WHERE id_cliente = 6)
BEGIN
    INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro)
    VALUES (6, 'Martín Palermo', 'martin@mail.com', 'Santa Fe', '2024-03-20');
END;
GO

IF NOT EXISTS (SELECT 1 FROM productos WHERE id_producto = 7)
BEGIN
    INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo)
    VALUES (7, 'Cámara Web 4K', 2, 85.00, 25, 1);
END;
GO

-- ----------------------------------------------------------------------------
-- CONSULTA 1: Vista base del proyecto (INNER JOIN)
-- ----------------------------------------------------------------------------
SELECT 
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad AS region,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c 
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p 
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat 
    ON p.id_categoria = cat.id_categoria;
GO

-- ----------------------------------------------------------------------------
-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)
-- ----------------------------------------------------------------------------
SELECT 
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v 
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
GO


-- ----------------------------------------------------------------------------
-- CONSULTA 3: Productos sin ventas (LEFT JOIN)
-- ----------------------------------------------------------------------------
SELECT 
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS cat 
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v 
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;
GO

-- ----------------------------------------------------------------------------
-- CONSULTA 4: Consolidado por canal (UNION ALL + GROUP BY)
-- ----------------------------------------------------------------------------
SELECT 
    canal,
    SUM(total) AS total_facturado,
    COUNT(*) AS cantidad_pedidos
FROM (
    -- Origen 1: Transacciones del canal Online
    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Online' AS canal
    FROM ventas
    WHERE (cantidad * precio_unitario) >= 500.00

    UNION ALL

    -- Origen 2: Transacciones del canal Presencial
    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Presencial' AS canal
    FROM ventas
    WHERE (cantidad * precio_unitario) < 500.00
) AS ventas_consolidadas
GROUP BY canal;
GO