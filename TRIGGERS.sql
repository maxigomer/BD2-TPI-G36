USE BDMedicamentos
GO

--tr_actualizarStockLotes: Al insertar la información de la entrega en DetalleEntrega se resta la cantidad vendida del stock del lote

CREATE TRIGGER tr_actualizarStockLotes ON DetalleEntrega
INSTEAD OF INSERT
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @idEntrega INTEGER
			DECLARE @idLote INTEGER
			DECLARE @cantidad INTEGER
			DECLARE @importeFinal DECIMAL

			SELECT @idEntrega = IDEntrega, @idLote = IDLote, @cantidad = Cantidad, @importeFinal = ImporteFinal FROM INSERTED

			IF (@cantidad > (SELECT Stock FROM Lotes WHERE IDLote = @idLote))
				BEGIN
					RAISERROR('Cantidad ingresada mayor al stock disponible', 16, 2);
					RETURN;
				END

		    IF EXISTS (
			SELECT 1 
			FROM Lotes L
			INNER JOIN inserted I ON L.IDLote = I.IDLote
			WHERE L.FechaVencimiento < GETDATE()
			)
			BEGIN
        		RAISERROR('No se puede vender un lote de medicamentos vencido.', 16, 2);
			END

			UPDATE Lotes SET Stock = Stock - @cantidad WHERE @idLote = IDLote;

			INSERT INTO DetalleEntrega(IDEntrega,IDLote,Cantidad,ImporteFinal) VALUES (@idEntrega,@idLote,@cantidad,@importeFinal)

		COMMIT TRANSACTION
		PRINT 'Trigger ejecutado: Se actualizo el stock correctamente.';
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT 'Ocurrió un error en el procedimiento:';
        PRINT ERROR_MESSAGE();
	END CATCH
END;
GO


--tr_bajaLotesVencidos: Después de insertar un lote en la tabla Lotes se cambia el stock de todos los lotes vencidos a 0

CREATE TRIGGER tr_bajaLotesVencidos ON Lotes
AFTER INSERT
AS
BEGIN
	UPDATE Lotes SET Stock = 0 WHERE FechaVencimiento < GETDATE() AND Stock > 0;
	PRINT 'Trigger ejecutado: Se dieron de baja todos los lotes vencidos correctamente. Stock cambiado a 0.';
END;
GO

