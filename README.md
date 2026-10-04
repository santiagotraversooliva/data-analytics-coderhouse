# Data Analytics: Sistema de Ventas y Rentabilidad (RetailPro)

Repositorio oficial del backend analítico para RetailPro. Este proyecto diagnostica y audita la caída del 14% del margen neto en el último trimestre, cruzando ingresos comerciales versus sobrecostos logísticos.

## 🗂️ Arquitectura de Datos (3NF)
El modelo relacional consta de 8 tablas normalizadas y organizadas lógicamente:
- **Dimensiones:** `clientes`, `productos`, `territorios`
- **Tabla de Hechos:** `ventas`
- **Centros de Costo:** `compras`, `logistica`, `marketing`, `administracion`

## 🚀 Ejecución de Scripts SQL
**Importante:** Debido a las restricciones de integridad referencial (Foreign Keys), los scripts deben ejecutarse en este orden estricto para evitar errores de compilación:
1. `ddl_esquema.sql` (Crea las tablas sin dependencias).
2. `dml_cargas.sql` (Inserta datos en dimensiones primero, luego en ventas).
3. `m5_consultas_joins.sql` (Genera las vistas analíticas).
