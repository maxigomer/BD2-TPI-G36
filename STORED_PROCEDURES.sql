USE BDMedicamentos
GO

--sp_insertarIngreso: Registra el ingreso de lotes de medicamentos

CREATE PROCEDURE sp_insertarIngreso (
@IDLaboratorio INT, @CantidadLotes INT, @Importe DECIMAL(12,2), @Fecha DATETIME
)
AS
BEGIN
    BEGIN TRY

    IF NOT EXISTS (SELECT 1 FROM Laboratorios WHERE IDLaboratorio = @IDLaboratorio)
    BEGIN
        RAISERROR('El IDLaboratorio proporcionado no existe en la base de datos.', 16, 1);
        RETURN;
    END

    IF (@Fecha > GETDATE())
    BEGIN
        RAISERROR('La fecha de ingreso no puede ser mayor a la fecha y hora actual.', 16, 1);
    END

    INSERT INTO Ingresos (IDLaboratorio, CantidadLotes, Importe, Fecha) VALUES (@IDLaboratorio, @CantidadLotes, @Importe, @Fecha);
    PRINT 'Ingreso registrado correctamente.';
    
    END TRY
    BEGIN CATCH
        PRINT 'Ocurrió un error en el procedimiento:';
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO


--sp_insertarEntrega: Registra la entrega de lotes de medicamentos

CREATE PROCEDURE sp_insertarEntrega(
@IDCliente INT, @IDDireccionCliente INT, @Fecha DATETIME, @Importe DECIMAL(12,2)
)
AS
BEGIN

BEGIN TRY

    IF NOT EXISTS (SELECT 1 FROM Clientes WHERE IDCliente = @IDCliente)
    BEGIN
        RAISERROR('El IDCliente proporcionado no existe en la base de datos.', 16, 2);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM DireccionCliente WHERE IDDireccionCliente = @IDDireccionCliente)
    BEGIN
        RAISERROR('El IDDireccionCliente proporcionado no existe en la base de datos.', 16, 2);
        RETURN;
    END

    IF (@Fecha > GETDATE())
    BEGIN
        RAISERROR('La fecha de entrega no puede ser mayor a la fecha y hora actual.', 16, 2);
    END

INSERT INTO Entregas(IDCliente, IDDireccion, Fecha, Importe) VALUES (@IDCliente, @IDDireccionCliente, @Fecha, @Importe)
PRINT 'Entrega registrada correctamente.';
    
    END TRY
    BEGIN CATCH
        PRINT 'Ocurrió un error en el procedimiento:';
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO


--sp_insertarLote: Registra un lote de medicamentos

CREATE PROCEDURE sp_insertarLote(
@idMedicamento INTEGER,
@idIngreso INTEGER,
@fechaVencimiento DATE,
@stock INTEGER
)
AS
BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM Medicamentos WHERE IDMedicamento = @idMedicamento)
		BEGIN
			RAISERROR('No existe el medicamento ingresado.',16,1);
			RETURN;
		END

		IF NOT EXISTS(SELECT 1 FROM Ingresos WHERE IDIngreso = @idIngreso)
		BEGIN
			RAISERROR('No existe el ingreso seleccionado.',16,1);
			RETURN;
		END

		IF (@fechaVencimiento <= GETDATE())
		BEGIN
			RAISERROR('La fecha de vencimiento no es valida.',16,1);
			RETURN;
		END

		IF (@stock < 1)
		BEGIN
			RAISERROR('Ingrese un numero mayor a 0.',16,1);
			RETURN;
		END

		IF ((SELECT COUNT(*) FROM Lotes WHERE IDIngreso = @idIngreso) >= (SELECT CantidadLotes FROM Ingresos WHERE IDIngreso = @idIngreso))
		BEGIN
			RAISERROR('Ya se alcanzó la cantidad máxima de lotes para este ingreso.',16,1);
			RETURN;
		END

		INSERT INTO Lotes (IDMedicamento,IDIngreso,FechaVencimiento,Stock) VALUES (@idMedicamento,@idIngreso,@fechaVencimiento,@stock)
	END TRY
	BEGIN CATCH
		PRINT 'Ocurrió un error en el procedimiento:';
        PRINT ERROR_MESSAGE();
	END CATCH
END;
GO


--sp_insertarDetalleEntrega: Registra los detalles de la entrega de los lotes de medicamentos

CREATE PROCEDURE sp_insertarDetalleEntrega(
@idEntrega INTEGER,
@idLote INTEGER,
@cantidad INTEGER,
@importeFinal DECIMAL(12,2)
)
AS
BEGIN
	BEGIN TRY
		IF(@cantidad < 1)
			BEGIN
				RAISERROR('Ingrese una cantidad mayor a 0.',16,1)
				RETURN;
			END
		IF NOT EXISTS (SELECT 1 FROM Entregas WHERE IDEntrega = @idEntrega)
			BEGIN
				RAISERROR('No existe el id de Entrega ingresado.',16,1)
				RETURN;
			END
		IF NOT EXISTS (SELECT 1 FROM Lotes WHERE IDLote = @idLote)
			BEGIN
				RAISERROR('No existe el id de Lote ingresado.',16,1)
				RETURN;
			END
		IF(@importeFinal < 1)
			BEGIN
				RAISERROR('Ingrese un importe valido',16,1)
				RETURN;
			END
		INSERT INTO DetalleEntrega (IDEntrega,IDLote,Cantidad,ImporteFinal) VALUES(@idEntrega,@idLote,@cantidad,@importeFinal)

	END TRY
	BEGIN CATCH
		PRINT 'Ocurrió un error en el procedimiento:';
        PRINT ERROR_MESSAGE();
	END CATCH
END;
GO


--sp_bajaLote: Realiza una baja lógica del lote ingresado, cambiando su stock a 0

CREATE PROCEDURE sp_bajaLote(
@IDLote INT, @IDMedicamento INT
)
AS
BEGIN
 BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM Lotes WHERE IDLote = @IDLote AND IDMedicamento = @IDMedicamento)
    BEGIN
        RAISERROR('El ID de lote y medicamento proporcionado no existe.', 16, 1);
    END

    UPDATE Lotes
    SET Stock = 0
    WHERE IDLote = @IDLote AND IDMedicamento = @IDMedicamento AND Stock > 0;
    PRINT 'Se dio de baja el lote correctamente. Stock cambiado a 0.';

END TRY
    BEGIN CATCH
        PRINT 'Ocurrió un error en el procedimiento:';
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO


--sp_buscarStockMedicamento: Permite buscar el stock disponible del medicamento ingresado

CREATE PROCEDURE sp_buscarStockMedicamento(
@idMedicamento INTEGER
)
AS
BEGIN
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM Medicamentos WHERE IDMedicamento = @idMedicamento)
		BEGIN
			RAISERROR('No existe el medicamento ingresado.',16,1)
			RETURN;
		END
		
		SELECT 
		M.IDMedicamento,
		M.NombreComercial,
		SUM(L.Stock) AS StockDisponible
		FROM Medicamentos M
		INNER JOIN Lotes L ON M.IDMedicamento = L.IDMedicamento
		WHERE L.FechaVencimiento >= GETDATE() AND @idMedicamento = M.IDMedicamento
		GROUP BY
		M.IDMedicamento,
		M.NombreComercial;
	END TRY
	BEGIN CATCH
		PRINT 'Ocurrió un error en el procedimiento:';
        PRINT ERROR_MESSAGE();
	END CATCH
END;
GO


--sp_buscarLotesIngreso: permite consultar el ingreso del lote ingresado

CREATE PROCEDURE sp_buscarLotesIngreso(
@idIngreso INTEGER
)
AS
BEGIN
	BEGIN TRY
		IF NOT EXISTS ( SELECT 1 FROM Ingresos WHERE IDIngreso = @idIngreso)
		BEGIN
			RAISERROR('No existe el Ingreso seleccionado.',16,1);
			RETURN;
		END

		SELECT * FROM Lotes WHERE IDIngreso = @idIngreso;
	END TRY
	BEGIN CATCH
		PRINT 'Ocurrió un error en el procedimiento:';
        PRINT ERROR_MESSAGE();
	END CATCH
END;
GO

