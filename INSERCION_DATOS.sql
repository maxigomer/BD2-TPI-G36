INSERT INTO Laboratorios (Nombre, Cuit)
VALUES
('Bayer Argentina', '30712345678'),
('Roemmers', '30723456789'),
('Bago', '30734567890');

INSERT INTO Direccion
(IDLaboratorio, Calle, Altura, Localidad, CP, Observaciones)
VALUES
(1, 'Av. Libertador', '7208', 'Buenos Aires', '1429', 'Casa central'),
(2, 'Fray Justo Santa Maria de Oro', '1744', 'Buenos Aires', '1414', NULL),
(3, 'Bernardo de Irigoyen', '248', 'Buenos Aires', '1072', 'Planta administrativa');

INSERT INTO Medicamentos
(NombreComercial, PrincipioActivo, Tipo, IDLaboratorio, PrecioUnitario)
VALUES
('Aspirina', 'Acido Acetilsalicilico', 'C', 1, 2500.00),
('Baycuten', 'Clotrimazol', 'P', 1, 4800.00),
('Amoxidal', 'Amoxicilina', 'P', 2, 6200.00),
('Tafirol', 'Paracetamol', 'C', 3, 1800.00);

INSERT INTO Clientes
(Cuit, NombreCliente, NombreResponsable, ApellidoResponsable, Telefono, Mail)
VALUES
('30555111222', 'Farmacia Central', 'Juan', 'Perez', '1134567890', 'jperez@farmaciacentral.com'),
('30666222333', 'Farmacia Norte', 'Maria', 'Gomez', '1145678901', 'mgomez@farmacianorte.com'),
('30777333444', 'Drogueria Sur', 'Carlos', 'Lopez', '1156789012', 'clopez@drogueriasur.com');

INSERT INTO DireccionCliente
(IDCliente, Calle, Altura, Localidad, CP, Observaciones)
VALUES
(1, 'Rivadavia', '1234', 'Buenos Aires', '1033', 'Local principal'),
(2, 'Mitre', '456', 'La Plata', '1900', NULL),
(3, 'Belgrano', '789', 'Mar del Plata', '7600', 'Deposito central');

INSERT INTO Ingresos
(IDLaboratorio, CantidadLotes, Importe, Fecha)
VALUES
(1, 2, 150000.00, '2025-01-10'),
(2, 1, 80000.00, '2025-02-15'),
(3, 1, 60000.00, '2025-03-20');

INSERT INTO Lotes
(IDMedicamento, IDIngreso, FechaVencimiento, Stock)
VALUES
(1, 1, '2027-01-01', 120),
(2, 1, '2027-02-01', 80),
(3, 2, '2027-03-01', 150),
(4, 3, '2027-04-01', 200),
(4, 1, '2026-06-26', 70);

INSERT INTO Entregas
(IDCliente, IDDireccion, Fecha, Importe)
VALUES
(1, 1, '2025-05-10', 12500.00),
(2, 2, '2025-05-15', 18600.00),
(3, 3, '2025-05-20', 9000.00),
(1, 1, DATEADD(DAY,-2,GETDATE()), 15000),
(2, 2, DATEADD(DAY,-5,GETDATE()), 24800),
(3, 3, DATEADD(DAY,-7,GETDATE()), 12600),
(1, 1, DATEADD(DAY,-10,GETDATE()), 9000),
(2, 2, DATEADD(DAY,-12,GETDATE()), 30000),
(3, 3, DATEADD(DAY,-15,GETDATE()), 6200),
(1, 1, DATEADD(DAY,-18,GETDATE()), 18000),
(2, 2, DATEADD(DAY,-21,GETDATE()), 21600),
(3, 3, DATEADD(DAY,-25,GETDATE()), 12500),
(1, 1, DATEADD(DAY,-29,GETDATE()), 37200);

INSERT INTO DetalleEntrega (IDEntrega, IDLote, Cantidad, ImporteFinal)
VALUES (1, 1, 5, 12500.00);

INSERT INTO DetalleEntrega (IDEntrega, IDLote, Cantidad, ImporteFinal)
VALUES (2, 3, 3, 18600.00);

INSERT INTO DetalleEntrega (IDEntrega, IDLote, Cantidad, ImporteFinal)
VALUES (3, 4, 5, 9000.00);

INSERT INTO DetalleEntrega (IDEntrega, IDLote, Cantidad, ImporteFinal)
VALUES (4, 1, 6, 15000.00);

INSERT INTO DetalleEntrega (IDEntrega, IDLote, Cantidad, ImporteFinal)
VALUES (5, 3, 4, 24800.00);

INSERT INTO DetalleEntrega (IDEntrega, IDLote, Cantidad, ImporteFinal)
VALUES (6, 4, 7, 12600.00);

INSERT INTO DetalleEntrega (IDEntrega, IDLote, Cantidad, ImporteFinal)
VALUES (7, 4, 5, 9000.00);

INSERT INTO DetalleEntrega (IDEntrega, IDLote, Cantidad, ImporteFinal)
VALUES (8, 1, 12, 30000.00);

INSERT INTO DetalleEntrega (IDEntrega, IDLote, Cantidad, ImporteFinal)
VALUES (9, 3, 1, 6200.00);

INSERT INTO DetalleEntrega (IDEntrega, IDLote, Cantidad, ImporteFinal)
VALUES (10, 4, 10, 18000.00);

INSERT INTO DetalleEntrega (IDEntrega, IDLote, Cantidad, ImporteFinal)
VALUES (11, 4, 12, 21600.00);

INSERT INTO DetalleEntrega (IDEntrega, IDLote, Cantidad, ImporteFinal)
VALUES (12, 1, 5, 12500.00);

INSERT INTO DetalleEntrega (IDEntrega, IDLote, Cantidad, ImporteFinal)
VALUES (13, 3, 6, 37200.00);
