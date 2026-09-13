-- ============================================================================
-- Archivo: modulo2_unidad1_diseno.sql
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Creación de la tabla: clientes
-- ----------------------------------------------------------------------------
CREATE TABLE clientes (
    -- id_cliente: Entero como identificador numérico de cada cliente.
    id_cliente INT,

    -- nombre: Texto de longitud variable de hasta 100 caracteres.
    nombre VARCHAR(100),

    -- perfil_bio: Tipo TEXT para permitir bloques descriptivos extensos o notas
    perfil_bio TEXT,

    -- fecha_registro: Tipo DATE para almacenar estrictamente año, mes y día (AAAA-MM-DD).
    fecha_registro DATE
);

-- ----------------------------------------------------------------------------
-- 2. Creación de la tabla: productos
-- ----------------------------------------------------------------------------
CREATE TABLE productos (
    -- id_producto: Entero como identificador numérico de catálogo.
    id_producto INT,

    -- descripcion: Texto de hasta 255 caracteres para la descripción del producto.
    descripcion VARCHAR(255),

    -- precio: DECIMAL(10,2) asegura almacenamiento exacto de dinero con coma fija.
    -- Se evita FLOAT.
    precio DECIMAL(10, 2),

    -- esta_activo: Tipo BIT (1 para activo/TRUE, 0 para inactivo/FALSE).
    esta_activo BIT
);