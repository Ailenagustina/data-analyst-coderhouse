# Módulo 6 - Pipeline ETL

## Transformaciones realizadas

- Eliminé los registros duplicados de clientes y productos.
- Reemplacé los datos faltantes de clientes por "Sin datos" para no perder registros válidos.
- Reemplacé el precio faltante de productos por 75, tomando como referencia productos similares.
- Reemplacé la categoría faltante por "Sin categoría".
- Revisé y corregí los tipos de datos de las columnas.
- Renombré las consultas como Dim_Clientes, Dim_Productos, Dim_Categorias y Fact_Ventas.
- Combiné Fact_Ventas con Dim_Productos utilizando Merge por id_producto.
- Agregué nombre_producto y categoria a la tabla de ventas.
- Agregué comentarios en el código M para explicar algunas de las transformaciones realizadas.

## Resultado final

- Dim_Clientes: 11 registros
- Dim_Productos: 12 registros
- Dim_Categorias: 4 registros
- Fact_Ventas: 50 registros
