# Sistema de Gestion para una Distribuidora de Medicamentos - Grupo 36

Este proyecto consiste en el desarrollo de una Base de Datos para la gestion de Stock, Ingresos y Egresos de una Distribuidora de Medicamentos.

## Contexto Académico

El sistema fue desarrollado en el marco de la Materia Base de datos 2 de la Tecnicatura Universitaria en Programación - UTN FRGP.

### Integrantes del equipo

- Giselle, Olano
- Gomer, Maximo Eliseo

---

## Descripción del Sistema

La Base de Datos le permite al usuario:

- Registrar y administrar lotes de medicamentos
- Almacenar ingresos de mercaderia
- Almacenar entregas de los medicamentos
- Consultar el historial de ingresos
- Buscar lotes de medicamentos cercanos a su fecha de vencimiento
- Consultar cantidades disponibles de lotes activos
- Visualizar los medicamentos que mayor ganancia generan

---

## Componentes Técnicos

### Vistas
- VW_MedicamentosVendidosUltimos30Dias
- VW_ResumenEntregasUltimos30Dias
- VW_StockMedicamentos
- VW_ResumenIngresosUltimos30Dias
- VW_MedicamentosMayorRecaudacion
- VW_ClientesYComprasFrecuentes
- VW_GananciaPorMedicamento

### Triggers
- tr_actualizarStockLotes
- tr_bajaLotesVencidos

### Funciones
- fn_lotesPorVencer
- fn_formatearDinero

### Procedimientos Almacenados
- sp_insertarIngreso
- sp_insertarEntrega
- sp_insertarLote
- sp_insertarDetalleEntrega
- sp_bajaLote
- sp_buscarStockMedicamento
- sp_buscarLotesIngreso
