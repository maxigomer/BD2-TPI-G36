USE BDMedicamentos
GO

--fn_lotesPorVencer: Función que devuelve los lotes próximos a vencer según la cantidad de días ingresados como parámetro

CREATE FUNCTION fn_lotesPorVencer (
@DiasMargen INT
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        M.NombreComercial,
        L.IDLote,
        L.Stock,
        L.FechaVencimiento,
        DATEDIFF(day, GETDATE(), L.FechaVencimiento) AS DiasRestantes
    FROM Lotes L
    INNER JOIN Medicamentos M ON L.IDMedicamento = M.IDMedicamento
    WHERE L.FechaVencimiento BETWEEN GETDATE() AND DATEADD(day, @DiasMargen, GETDATE())
      AND L.Stock > 0
);
GO


--fn_formatearDinero: Función que devuelve el importe ingresado en formato moneda, con dos decimales y el signo de moneda ($)

CREATE FUNCTION fn_formatearDinero (
@Importe DECIMAL(12,2)
)
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN '$ ' + CONVERT(VARCHAR, CAST(@Importe AS MONEY), 1);
END;
GO

