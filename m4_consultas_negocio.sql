-- ============================================================================
-- Nombre del archivo: m4_consultas_negocio.sql
-- Módulo 4: Sintaxis SQL y Manipulación de Datos
-- Proyecto Integrador: RetailPro / TechStore
-- Autor: Santiago Traverso Oliva
-- Base de datos: Ventas_Tech_DB
-- Descripción: Extracción de métricas de negocio, rankings, recurrencia de 
--              clientes y desempeño temporal sobre la tabla ventas.
-- ============================================================================

USE Ventas_Tech_DB;
GO

-- ----------------------------------------------------------------------------
-- Consulta 1: Resumen ejecutivo mensual
-- Objetivo: Obtener total facturado, volumen de transacciones y ticket promedio
-- agrupados cronológicamente por mes.
-- Compatible con SQL Server (MONTH) y PostgreSQL (EXTRACT)
-- ----------------------------------------------------------------------------
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    ROUND(AVG(cantidad * precio_unitario), 2) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes ASC;

/* 
-- Versión alternativa para motores PostgreSQL:
SELECT 
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    ROUND(AVG(cantidad * precio_unitario), 2) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes ASC;
*/


-- ----------------------------------------------------------------------------
-- Consulta 2: Ranking de productos (Top 5 por facturación)
-- Objetivo: Identificar los 5 productos que mayor volumen monetario generan,
-- mostrando las unidades físicas totales vendidas y el ingreso acumulado.
-- ----------------------------------------------------------------------------
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

/* 
-- Versión alternativa con sintaxis LIMIT (PostgreSQL / MySQL):
SELECT 
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;
*/


-- ----------------------------------------------------------------------------
-- Consulta 3: Clientes recurrentes
-- Objetivo: Detectar compradores con más de una transacción (fidelización / B2B)
-- evaluando pedidos totales y facturación histórica acumulada.
-- ----------------------------------------------------------------------------
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;


-- ----------------------------------------------------------------------------
-- Consulta 4: Meses por encima/por debajo del promedio general
-- Objetivo: Comparar la facturación de cada mes frente a la media mensual global
-- mediante lógica condicional (CASE WHEN) y subconsulta de agregación.
-- ----------------------------------------------------------------------------
WITH metricas_mensuales AS (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_mes
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT 
    mes,
    total_mes AS total_facturado,
    CASE 
        WHEN total_mes >= (SELECT AVG(total_mes) FROM metricas_mensuales) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS rendimiento_vs_promedio
FROM metricas_mensuales
ORDER BY mes ASC;


-- ----------------------------------------------------------------------------
-- BLOQUE DE CIERRE: 3 HALLAZGOS CONCRETOS DE NEGOCIO (RETAILPRO)
-- ----------------------------------------------------------------------------
/*
HALLAZGO 1 - Alta concentración del catálogo en el Top 1:
Al analizar el ranking de productos (Consulta 2), el producto id_producto = 1 
(Laptop Pro 15) concentra $3,600.00 del total facturado, representando más del 50% 
de los ingresos brutos del período analizado, lo que denota una alta dependencia 
comercial de la línea de computación de gama alta.

HALLAZGO 2 - Recurrencia y volumen de clientes mayoristas / B2B:
La Consulta 3 revela que los clientes id_cliente = 1, 2, 4 y 5 presentan pedidos 
recurrentes (más de 1 transacción). En particular, el cliente 1 alcanza un gasto 
acumulado de $2,640.00 en solo 2 compras, lo que evidencia un perfil corporativo (B2B) 
con alto ticket promedio frente al resto de la cartera.

HALLAZGO 3 - Distribución temporal de las ventas:
Al evaluar la performance mensual (Consultas 1 y 4), la totalidad de las 10 transacciones 
cargadas en el dataset de prueba se concentran en el mes de marzo (mes 3) con una facturación 
total de $6,664.00, superando el promedio teórico al registrar un pico de actividad de reposición 
que servirá de punto de partida para contrastar la rentabilidad neta en Power BI.
*/