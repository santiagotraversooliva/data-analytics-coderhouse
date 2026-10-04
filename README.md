# Data Analytics: Sistema de Ventas y Rentabilidad (RetailPro)

Repositorio oficial del backend analítico para RetailPro. Este proyecto diagnostica y audita la caída del 14% del margen neto en el último trimestre, cruzando ingresos comerciales versus sobrecostos logísticos.

## 🗂️ Arquitectura de Datos (3NF)
El modelo relacional consta de tablas normalizadas y organizadas lógicamente:
- **Dimensiones:** `clientes`, `productos`, `territorios`
- **Tabla de Hechos:** `ventas`
- **Centros de Costo:** `compras`, `logistica`, `marketing`, `administracion`

## 🚀 Ejecución de Scripts SQL
**Importante:** Debido a las restricciones de integridad referencial (Foreign Keys), los scripts deben ejecutarse en este orden estricto:
1. Ejecutar `ventas_tech_db.sql`
2. Ejecutar `m4_consultas_negocio.sql` 
3. Ejecutar `m5_consultas_joins.sql` 
