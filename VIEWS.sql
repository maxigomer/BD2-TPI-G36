USE BDMedicamentos
GO

--VW_MedicamentosVendidosUltimos30Dias: Vista que muestra los medicamentos más vendidos en los últimos treinta días

CREATE VIEW VW_MedicamentosVendidosUltimos30Dias AS
SELECT M.NombreComercial AS Medicamento,
L.Nombre as Laboratorio,
SUM(D.Cantidad) AS UnidadesVendidas,
dbo.fn_formatearDinero(SUM(D.ImporteFinal)) AS ImporteTotal
FROM Medicamentos M
INNER JOIN Laboratorios L ON M.IDLaboratorio = L.IDLaboratorio
INNER JOIN Lotes LO ON M.IDMedicamento = LO.IDMedicamento
INNER JOIN DetalleEntrega D ON LO.IDLote = D.IDLote
INNER JOIN Entregas E ON D.IDEntrega = E.IDEntrega
WHERE E.Fecha >= DATEADD(DAY, -30, GETDATE())
GROUP BY
M.IDMedicamento,
M.NombreComercial,
L.Nombre
GO


--VW_ResumenEntregasUltimos30Dias: Vista que muestra un resumen de las entregas de los últimos treinta días 

CREATE VIEW VW_ResumenEntregasUltimos30Dias AS
SELECT
    E.IDEntrega,
    C.NombreCliente,
    E.Fecha,
    dbo.fn_formatearDinero(E.Importe) AS Importe,
    D.Calle + ' ' + D.Altura + ', ' + D.Localidad AS Direccion
FROM Entregas E
INNER JOIN Clientes C ON E.IDCliente = C.IDCliente,
DireccionCliente D WHERE E.IDDireccion = D.IDDireccionCliente AND E.Fecha >= DATEADD(DAY, -30, GETDATE())
GO


--VW_StockMedicamentos: Vista que muestra los medicamentos que se encuentran actualmente en stock

CREATE VIEW VW_StockMedicamentos AS
SELECT
M.IDMedicamento,
M.NombreComercial,
SUM(L.Stock) AS StockDisponible
FROM Medicamentos M
INNER JOIN Lotes L ON M.IDMedicamento = L.IDMedicamento
WHERE L.FechaVencimiento >= GETDATE()
GROUP BY
M.IDMedicamento,
M.NombreComercial;
GO


--VW_ResumenIngresosUltimos30Dias: Vista que muestra un resumen de los ingresos de los últimos treinta días

CREATE VIEW VW_ResumenIngresosUltimos30Dias AS
SELECT
I.IDIngreso,
L.Nombre AS Laboratorio,
COUNT(DISTINCT lo.IDLote) AS CantidadLotes,
dbo.fn_formatearDinero(I.Importe) AS Importe,
I.Fecha,
STRING_AGG(m.NombreComercial, ', ') AS Medicamentos
FROM Ingresos I
INNER JOIN Laboratorios L ON I.IdLaboratorio = L.IDLaboratorio
LEFT JOIN Lotes Lo ON I.IDIngreso = Lo.IdIngreso
LEFT JOIN Medicamentos M ON Lo.IdMedicamento = M.IDMedicamento
WHERE I.Fecha >= DATEADD(DAY, -30, GETDATE())
GROUP BY I.IDIngreso, L.Nombre, I.Importe, I.Fecha;
GO


--VW_MedicamentosMayorRecaudacion: Vista que muestra los medicamentos que más recaudan

CREATE VIEW VW_MedicamentosMayorRecaudacion AS
SELECT TOP 3 WITH TIES M.IDMedicamento,
M.NombreComercial,
M.Tipo,
SUM(D.Cantidad) AS CantidadVendida,
dbo.fn_formatearDinero(SUM(D.ImporteFinal)) AS TotalRecaudado
FROM Medicamentos M
INNER JOIN Lotes L ON M.IDMedicamento = L.IDMedicamento
INNER JOIN DetalleEntrega D ON L.IDLote = D.IDLote
GROUP BY M.IDMedicamento, M.NombreComercial, M.Tipo
ORDER BY SUM(D.ImporteFinal) DESC;
GO


--VW_ClientesYComprasFrecuentes: Vista que muestra los clientes que mas compran y los medicamentos que compran

CREATE VIEW VW_ClientesYComprasFrecuentes AS
SELECT DISTINCT TOP 3 C.NombreCliente,
C.ApellidoResponsable + ', ' + C.NombreResponsable AS NombreCompletoResponsable,
dbo.fn_formatearDinero(SUM(E.Importe)) AS ImporteTotal,
SUM(D.Cantidad) AS CantidadComprada,
M.NombreComercial AS MedicamentoComprado
FROM Clientes C
INNER JOIN Entregas E ON C.IDCliente = E.IDCliente
INNER JOIN DetalleEntrega D ON E.IDEntrega = D.IDEntrega
INNER JOIN Lotes L ON D.IDLote = L.IDLote
INNER JOIN Medicamentos M ON L.IDMedicamento = M.IDMedicamento
GROUP BY C.ApellidoResponsable, C.NombreResponsable, C.NombreCliente, M.NombreComercial
ORDER BY CantidadComprada DESC;
GO

