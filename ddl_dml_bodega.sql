-- ============================================================================
-- BodegaTech — Script de Inventario
-- Autor: Santiago Traverso Oliva
-- Fecha: 13/09/2026
-- Descripción: Creación de estructura DDL y operaciones DML sobre inventario
-- ============================================================================

-- ── SECCIÓN DDL ─────────────────────────────────────────────────────────────

-- Paso 1: Eliminación previa de la tabla para permitir reejecución limpia
DROP TABLE IF EXISTS inventario;

-- Paso 2: Creación de la tabla inventario con su PK y tipos de datos
CREATE TABLE inventario (
    -- id_producto: Identificador numérico entero único para cada producto (Clave Primaria).
    -- Cumple con la unicidad requerida y optimiza los índices de búsqueda.
    id_producto INT PRIMARY KEY,

    -- nombre_producto: Cadena de longitud variable hasta 100 caracteres.
    -- VARCHAR optimiza el espacio físico reservando solo los caracteres reales.
    nombre_producto VARCHAR(100) NOT NULL,

    -- categoria: Clasificación comercial del producto hasta 50 caracteres.
    categoria VARCHAR(50) NOT NULL,

    -- precio_unitario: Tipo DECIMAL(10,2) con coma fija exacta para valores monetarios.
    -- Evita los errores de redondeo de coma flotante propios del tipo FLOAT.
    precio_unitario DECIMAL(10, 2) NOT NULL,

    -- stock_actual: Cantidad entera de unidades disponibles en el almacén.
    stock_actual INT NOT NULL,

    -- stock_minimo: Umbral numérico entero para disparar órdenes de reposición.
    stock_minimo INT NOT NULL,

    -- fecha_ingreso: Tipo DATE para almacenar estrictamente año, mes y día (AAAA-MM-DD).
    -- Evita el sobrecosto de guardar horas no requeridas por el negocio.
    fecha_ingreso DATE NOT NULL,

    -- activo: TINYINT para representar el estado binario (1 = disponible, 0 = descontinuado).
    -- Compatible directamente con SQL Server ocupando únicamente 1 byte por registro.
    activo TINYINT NOT NULL
);


-- ── SECCIÓN DML ─────────────────────────────────────────────────────────────

-- Paso 3: Carga inicial de los 10 productos del catálogo
INSERT INTO inventario (id_producto, nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo)
VALUES 
    (1, 'Laptop Pro 15', 'Computación', 1200.00, 15, 3, '2024-01-10', 1),
    (2, 'Mouse Inalámbrico', 'Accesorios', 28.00, 80, 10, '2024-01-10', 1),
    (3, 'Monitor 4K 27"', 'Computación', 450.00, 12, 2, '2024-01-15', 1),
    (4, 'Teclado Mecánico', 'Accesorios', 95.00, 40, 5, '2024-01-15', 1),
    (5, 'Laptop Basic 14', 'Computación', 650.00, 20, 3, '2024-02-01', 1),
    (6, 'Auriculares BT Pro', 'Audio', 120.00, 35, 5, '2024-02-01', 1),
    (7, 'Hub USB-C 7 puertos', 'Accesorios', 45.00, 60, 10, '2024-02-10', 1),
    (8, 'Webcam HD 1080p', 'Accesorios', 85.00, 25, 5, '2024-02-10', 1),
    (9, 'SSD Externo 1TB', 'Almacenamiento', 130.00, 18, 3, '2024-03-01', 1),
    (10, 'Parlante Bluetooth', 'Audio', 60.00, 45, 8, '2024-03-01', 1);

-- Paso 4: Registro de ventas del día actualizando stock_actual (con cláusula WHERE obligatoria)

-- Venta de 3 unidades de Laptop Pro 15 (id: 1) -> Stock resultante: 15 - 3 = 12
UPDATE inventario 
SET stock_actual = stock_actual - 3 
WHERE id_producto = 1;

-- Venta de 12 unidades de Mouse Inalámbrico (id: 2) -> Stock resultante: 80 - 12 = 68
UPDATE inventario 
SET stock_actual = stock_actual - 12 
WHERE id_producto = 2;

-- Venta de 5 unidades de Auriculares BT Pro (id: 6) -> Stock resultante: 35 - 5 = 30
UPDATE inventario 
SET stock_actual = stock_actual - 5 
WHERE id_producto = 6;

-- Paso 5: Producto descontinuado por proveedor (Webcam HD 1080p, id: 8)
UPDATE inventario 
SET activo = 0 
WHERE id_producto = 8;

-- Paso 6: Consulta simple de validación para confirmar el estado final del inventario
SELECT * FROM inventario;