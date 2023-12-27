CREATE TABLE choferes(DNI varchar(15) PRIMARY KEY,
NOMBRE varchar(25),
APELLIDO varchar(25),
DIRECCION varchar(55),
TELEFONO_FIJO varchar(25) NULL,
TELEFONO_CELULAR varchar(25),
EDAD integer,
email char(50),
REGISTRO_AUTOMOTOR varchar(20))

CREATE TABLE remolques (
    ID integer IDENTITY PRIMARY KEY,
    DESCRIPCION varchar(60)
);

CREATE TABLE camiones (
    PATENTE varchar(10) PRIMARY KEY,
    MARCA varchar(20),
    MODELO varchar(30),
    AÑO int,
    TIPO_REMOLQUE integer,
    FOREIGN KEY(TIPO_REMOLQUE) REFERENCES remolques(ID)
);

CREATE TABLE choferes_camiones (
    ID integer IDENTITY PRIMARY KEY,
    DNI_CHOFER varchar(15),
    PATENTE_CAMION varchar(10),
    FOREIGN KEY(DNI_CHOFER) REFERENCES choferes(DNI),
    FOREIGN KEY(PATENTE_CAMION) REFERENCES camiones(PATENTE),
    FECHA_ASIGNACION DATE,
    FECHA_DESOBLIGACION DATE NULL
);

CREATE TABLE clientes(
  CODIGO integer IDENTITY PRIMARY KEY,
  NOMBRE varchar(40),
  APELLIDO varchar(20) NULL,
  RAZON_SOCIAL varchar(50) NULL,
  DNI varchar(10) NULL,
  CUIT varchar(15) NULL,
  DIRECCION varchar(35),
  TELEFONO varchar(15),
  EMAIL varchar(50),
  ES_EMPRESA BIT NULL,
  CHECK (
    (ES_EMPRESA = 0) OR
    (ES_EMPRESA = 1 AND RAZON_SOCIAL IS NOT NULL AND CUIT IS NOT NULL)
  )
);

CREATE TABLE provincias(
  	ID integer IDENTITY PRIMARY KEY,
  	NOMBRE varchar(30)
);

CREATE TABLE ciudades(
  	ID integer IDENTITY PRIMARY KEY,
  	NOMBRE varchar(30),
  	CODIGO_POSTAL integer,
  	PROVINCIA integer,
  	FOREIGN KEY(PROVINCIA) REFERENCES provincias(ID)
);

CREATE TABLE viajes(
  	CODIGO integer IDENTITY PRIMARY KEY,
  	CIUDAD_DESTINO integer,
  	FOREIGN KEY(CIUDAD_DESTINO) REFERENCES ciudades(ID),
  	CIUDAD_ORIGEN integer,
  	FOREIGN KEY(CIUDAD_ORIGEN) REFERENCES ciudades(ID),
  	KILOMETROS integer,
  	COD_CLIENTE integer,
  	FOREIGN KEY(COD_CLIENTE) REFERENCES clientes(CODIGO),
  	CAMION varchar(10),
  	FOREIGN KEY(CAMION) REFERENCES camiones(PATENTE),
  	CHOFER varchar(15),
  	FOREIGN KEY(CHOFER) REFERENCES choferes(DNI),
  	FECHA_SALIDA_ESTIMADA DATE,
  	FECHA_LLEGADA_ESTIMADA DATE,
  	FECHA_SALIDA_REAL DATE,
  	FECHA_LLEGADA_REAL DATE
);
---------------- INSERTADO DE DATOS -----------------------------
-- Insertar datos en la tabla remolques
INSERT INTO remolques (DESCRIPCION)
VALUES 
('Remolque tipo A'),
('Remolque tipo B'),
('Remolque tipo C');

-- Insertar datos para camiones
INSERT INTO camiones (PATENTE, MARCA, MODELO, AÑO, TIPO_REMOLQUE)
VALUES
('ABC123', 'Mercedes Benz', 'Actros', 2022, 1),
('XYZ789', 'Volvo', 'Gama FH', 2020, 2),
('DEF456', 'Iveco', 'S-Way', 2018, 1),
('GHI789', 'Mercedes Benz', 'Atego 1729', 2017, 3),
('JKL012', 'Volvo', 'Gama FH', 2023, 2),
('MNO345', 'Mercedes Benz', 'Actros', 2019, 3);


-- Insertar datos para choferes
INSERT INTO choferes (DNI, NOMBRE, APELLIDO, DIRECCION, TELEFONO_FIJO, TELEFONO_CELULAR, EDAD, email, REGISTRO_AUTOMOTOR)
VALUES
('33695214', 'Juan', 'Perez', 'Calle 123', '4391236', '3416874132', 35, 'juan@gmail.com', 'REG123'),
('30269851', 'Luis', 'Gomez', 'Av. Principal 1836', '4264621', '3425896321', 40, 'luis@gmail.com', 'REG456'),
('38563215', 'María', 'Lopez', 'Calle 567', '4215698', '3435894230', 28, 'maria@gmail.com', 'REG789'),
('27548896', 'Carlos', 'Martinez', 'Av. Central', NULL, '342546812', 45, 'carlos@gmail.com', 'REG012'),
('32152369', 'Laura', 'Rodriguez', 'Av. Norte', '4387964', '3416987324', 33, 'laura@gmail.com', 'REG345'),
('36478523', 'Sofía', 'Garcia', 'Calle 890', NULL, '345698741', 30, 'sofia@gmail.com', 'REG678'),
('32012584', 'Pedro', 'Sánchez', 'Av. Sur', NULL, '3415213649', 37, 'pedro@gmail.com', 'REG901'),
('41102356', 'Ana', 'Fernández', 'Calle 432', NULL, '3415961028', 25, 'ana@gmail.com', 'REG234'),
('29013350', 'Diego', 'Ramirez', 'Av. Oeste', NULL, '3412864179', 42, 'diego@gmail.com', 'REG567'),
('37047810', 'Julieta', 'Díaz', 'Calle 987', NULL, '3478421003', 29, 'julieta@gmail.com', 'REG890');


-- Insertar datos para clientes
INSERT INTO clientes (NOMBRE, APELLIDO, RAZON_SOCIAL, DNI, CUIT, DIRECCION, TELEFONO, EMAIL)
VALUES
('Juan', 'Lopez', NULL, '30251400', NULL, 'Av.Carballo 123', '3416521350', 'juanlopez30@gmail.com'),
('Lucas', 'Gonzales', NULL, '31236520', NULL, 'Rodriguez 456', '34124853621', 'lucas_gonzales23@gmail.com'),
('Cristian', 'Gomez', NULL, '33265123', NULL, 'Callao 789', '3417894523', 'cris.gomez@hotmail.com'),
('Marcos', 'Perez', NULL, '38562100', NULL, 'Pellegrini 122', '3416123231', 'marcoz_perez_94@gmail.com'),
('Abratecnica SRL', NULL, 'Abratecnica SRL', NULL, '30-26070831-9', 'Viamonte 1278', '4364571', 'abratecnica@gmail.com'),
('Pericos SA', NULL, 'Pericos SA', NULL, '30-87421035-6', 'Guemes 345', '4385620', 'ventas@pericos.com.ar'),
('El Sol', NULL, 'Pinturas El Sol36 SA', NULL, '30-87421035-6', 'Guemes 345', '4385620', 'ventas@pericos.com.ar'),
('Cristina', 'Herrera', NULL, '13562314', NULL, 'Rodriguez 2000', '3414587203', 'cris.herrera12@hotmail.es'),
('Ma2c Donals', NULL, 'Arcos Dorados S.R.L', NULL, '30-61025233-4', 'Pellegrini 956', '4387412', 'atencion@arcosdorados.com.ar'),
('Jose', 'Sandoval', NULL, '17231146', NULL, 'Pueyrredon 405', '3412321005', 'sandoval_jose13@hotmail.com'),
('TechSolutions Inc.', NULL, 'TecnoSoluciones S.A.', NULL, '30-87563201-6', 'Calle Tecno 123', '9876543210', 'info@techsolutions.com'),
('GreenHarvest', NULL, 'EcoFarms Ltd.', NULL, '30-51237899-8', 'Camino Orgánico 45', '5127890432', 'contact@greenharvestfarms.com'),
('FashionFusion', NULL, 'StyleMasters Group', NULL, '30-33567822-4', 'Avenida Chic 789', '3335557777', 'hello@fashionfusion.com'),
('Smarthouse Innovations', NULL, 'SmartTech Solutions LLC', NULL, '30-99988877-5', 'Bulevar de la Innovación 56', '1234567890', 'contact@smarthouseinnovations.com'),
('MediCare Connect', NULL, 'HealthTech Alliance', NULL, '30-74125896-3', 'Calle del Centro Médico 789', '9876543210', 'info@medicareconnect.com'),
('Ana', 'García', NULL, '29384756', NULL, 'Bulevar del Atardecer 123', '987654321', 'ana.garcia@email.com'),
('Carlos', 'Vargas', NULL, '37456321', NULL, 'Calle del Roble 56', '789012345', 'cvargas@email.com'),
('María', 'López', NULL, '12345678', NULL, 'Avenida del Jardín 789', '555666777', 'maria.lopez@email.com'),
('David', 'Martínez', NULL, '18765432', NULL, 'Calle del Arce 34', '333222111', 'david.martinez@email.com'),
('Luisa', 'Hernández', NULL, '26781234', NULL, 'Calle del Pino 789', '111222333', 'luisa.hernandez@email.com');

-- Insertar provincias
INSERT INTO provincias(NOMBRE)
VALUES
('Santa Fe'),
('Buenos Aires'),
('Cordoba'),
('Entre Rios');

-- Insertar ciudades
INSERT INTO ciudades(NOMBRE, CODIGO_POSTAL, PROVINCIA)
VALUES
('Rosario', 2000, 1),--1
('Santa Fe', 3000, 1),--2
('San Nicolas', 2900, 2),--3
('La Plata', 1900, 2),--4
('Marco Juarez', 2580, 3),--5
('Cordoba', 5000, 3),--6
('Parana', 3100, 4),--7
('Gualeguaychu', 2820, 4);--8

-- Insertar datos para viajes
INSERT INTO viajes (CIUDAD_DESTINO, CIUDAD_ORIGEN, KILOMETROS, COD_CLIENTE, CAMION, CHOFER, FECHA_SALIDA_ESTIMADA, FECHA_LLEGADA_ESTIMADA, FECHA_SALIDA_REAL, FECHA_LLEGADA_REAL)
VALUES
(1, 3, 450, 1, 'ABC123', '38563215', '2022-01-15', '2022-01-15', '2022-01-15', '2022-01-15'),
(2, 5, 500, 14, 'XYZ789', '27548896', '2023-02-10', '2023-02-11', '2023-02-11', '2023-02-11'),
(1, 6, 700, 4, 'ABC123', '32152369', '2023-01-15', '2023-01-16', '2023-01-15', '2023-01-16'),
(2, 8, 290, 8, 'MNO345', '32012584', '2023-06-20', '2023-06-20', '2023-06-20', '2023-06-20'),
(1, 7, 40, 9, 'GHI789', '41102356', '2022-09-03', '2022-09-03', '2022-09-03', '2022-09-03'),
(6, 1, 350, 1, 'JKL012', '29013350', '2023-01-20', '2023-01-20', '2023-01-20', '2023-01-20'),
(6, 3, 600, 14, 'DEF456', '37047810', '2023-02-10', '2023-02-11', '2023-02-10', '2023-02-12'),
(6, 8, 563, 4, 'ABC123', '27548896', '2023-03-15', '2023-01-16', '2023-03-15', '2023-01-16'),
(5, 4, 178, 8, 'XYZ789', '30269851', '2022-07-10', '2022-02-10', '2022-07-10', '2022-02-10'),
(5, 7, 65, 9, 'MNO345', '29013350', '2023-10-10', '2023-10-10', '2023-10-10', '2023-10-10');

-- Insertar datos en la tabla choferes_camiones
INSERT INTO choferes_camiones (DNI_CHOFER, PATENTE_CAMION, FECHA_ASIGNACION, FECHA_DESOBLIGACION)
VALUES ('27548896', 'DEF456', '2023-11-06', '2023-11-07');

-- ITEM 4.A)
SELECT COUNT(*) AS CantidadDeViajes
FROM viajes
INNER JOIN ciudades AS ciudad_origen ON viajes.CIUDAD_ORIGEN = ciudad_origen.ID
INNER JOIN ciudades AS ciudad_destino ON viajes.CIUDAD_DESTINO = ciudad_destino.ID
INNER JOIN provincias ON ciudad_destino.PROVINCIA = provincias.ID
WHERE provincias.NOMBRE = 'Santa Fe';

-- ITEM 4.B)
SELECT
    viajes.CODIGO AS CodigoViaje,
    ciudad_origen.NOMBRE AS CiudadOrigen,
    ciudad_destino.NOMBRE AS CiudadDestino,
    viajes.KILOMETROS,
    clientes.NOMBRE AS NombreCliente,
    camiones.MARCA AS MarcaCamion,
    camiones.MODELO AS ModeloCamion,
    choferes.NOMBRE + ' ' + choferes.APELLIDO AS NombreChofer,
    viajes.FECHA_SALIDA_ESTIMADA,
    viajes.FECHA_LLEGADA_ESTIMADA,
    viajes.FECHA_SALIDA_REAL,
    viajes.FECHA_LLEGADA_REAL
FROM
    viajes
INNER JOIN ciudades AS ciudad_origen ON viajes.CIUDAD_ORIGEN = ciudad_origen.ID
INNER JOIN ciudades AS ciudad_destino ON viajes.CIUDAD_DESTINO = ciudad_destino.ID
INNER JOIN provincias ON ciudad_origen.PROVINCIA = provincias.ID
INNER JOIN clientes ON viajes.COD_CLIENTE = clientes.CODIGO
INNER JOIN camiones ON viajes.CAMION = camiones.PATENTE
INNER JOIN choferes ON viajes.CHOFER = choferes.DNI
WHERE
    provincias.NOMBRE = 'Cordoba'
    AND YEAR(viajes.FECHA_SALIDA_ESTIMADA) = 2023
    AND MONTH(viajes.FECHA_SALIDA_ESTIMADA) <= 6;
    
-- ITEM 4.C)
SELECT TOP 3
    ch.NOMBRE + ' ' + ISNULL(ch.APELLIDO, '') AS Chofer,
    SUM(v.KILOMETROS) AS KilometrosRecorridos
FROM
    viajes v
INNER JOIN
    choferes ch ON v.CHOFER = ch.DNI
WHERE
    YEAR(v.FECHA_SALIDA_ESTIMADA) = 2023
GROUP BY
    ch.NOMBRE, ch.APELLIDO
ORDER BY
    KilometrosRecorridos DESC;
    
-- ITEM 4.D)
SELECT 
    c.NOMBRE AS ClienteNombre,
    v.COD_CLIENTE,
    ch.NOMBRE AS ChoferNombre,
    v.KILOMETROS,
    v.FECHA_SALIDA_ESTIMADA,
    v.FECHA_LLEGADA_ESTIMADA
FROM
    viajes AS v
JOIN
    clientes AS c ON v.COD_CLIENTE = c.CODIGO
JOIN
    choferes AS ch ON v.CHOFER = ch.DNI
WHERE
    YEAR(v.FECHA_SALIDA_ESTIMADA) = 2023
ORDER BY
    v.KILOMETROS DESC;


/* Ejercicio 1)
En este diagrama de Entidades creemos que en todas las tablas los atributos no primarios dependen unicamente de la llave 
primaria y no hay dependencias transitivas. Por lo tanto las relaciones presentadas estan en la 3FN.
*/

--Ejercicio 2)
--Agregamos el campo ES_EMPRESA con tipo de dato BIT(1 o 0) para validar si ese cliente es una empresa o una persona física
-- Y agregamos el check constraint en el campo ES_EMPRESA para validar segun lo cargado si es empresa o persona
/*CREATE TABLE clientes(
  CODIGO integer IDENTITY PRIMARY KEY,
  NOMBRE varchar(40),
  APELLIDO varchar(20) NULL,
  RAZON_SOCIAL varchar(50) NULL,
  DNI varchar(10) NULL,
  CUIT varchar(15) NULL,
  DIRECCION varchar(35),
  TELEFONO varchar(15),
  EMAIL varchar(50),
  ES_EMPRESA BIT NULL, -- Lo dejamos en NULL por que al ser el TP2 un agregado del TP1 nos resulta mas facil updatear los campos luego
  CHECK (
    (ES_EMPRESA = 0) OR
    (ES_EMPRESA = 1 AND RAZON_SOCIAL IS NOT NULL AND CUIT IS NOT NULL)
  )
);*/

-- Actualizamos los registros existentes en la tabla clientes:
UPDATE clientes
SET ES_EMPRESA = 1  -- Si es una empresa
WHERE CODIGO IN (5, 6, 7, 9, 11, 12, 13, 14, 15);

UPDATE clientes
SET ES_EMPRESA = 0  -- Si no es una empresa
WHERE CODIGO IN (1, 2, 3, 4, 8, 10, 16, 17, 18, 19, 20);

--Ahora si cambiamos el campo ES_EMPRESA para que no pueda ser NULL
ALTER TABLE clientes
ALTER COLUMN ES_EMPRESA BIT NOT NULL;

-- Ejercicio 3)
/* Para la tabla viajes:
Ponemos indices en CIUDAD_ORIGEN y CIUDAD_DESTINO ya que se utilizan en JOIN con la tabla ciudades
En campo COD_CLIENTE ya que se utiliza en join con la tabla clientes.
En el campo CAMION que se utiliza en JOIN con la tabla camiones.
En el campo CHOFER que se utiliza en JOIN con la tabla choferes.
*/

CREATE INDEX idx_viajes_ciudad_origen ON viajes(CIUDAD_ORIGEN);
CREATE INDEX idx_viajes_ciudad_destino ON viajes(CIUDAD_DESTINO);
CREATE INDEX idx_viajes_cod_cliente ON viajes(COD_CLIENTE);
CREATE INDEX idx_viajes_camion ON viajes(CAMION);
CREATE INDEX idx_viajes_chofer ON viajes(CHOFER);

/* Para la tabla clientes:
Ponemos índice en el campo CODIGO ya que se utiliza en JOIN con la tabla viajes
*/
CREATE INDEX idx_clientes_codigo ON clientes(CODIGO);

/* Para la tabla ciudades:
Ponemos índice en el campo PROVINCIA ya que se utiliza en JOIN con la tabla provincias
*/
CREATE INDEX idx_ciudades_provincia ON ciudades(PROVINCIA);

/* Para la tabla choferes_camiones:
Ponemos índice en los campos DNI_CHOFER y PATENTE_CAMION ya que se utilizan en JOIN con las tablas
choferes y camiones
*/

CREATE INDEX idx_choferes_camiones_dni_chofer ON choferes_camiones(DNI_CHOFER);
CREATE INDEX idx_choferes_camiones_patente_camion ON choferes_camiones(PATENTE_CAMION);

--Ejercicio 4)
-- Creaamos el Stored Procedure
CREATE PROCEDURE ActualizarViajeEnvio
    @CodigoViaje INT,
    @NuevaFechaLlegadaEstimada DATE
AS
BEGIN
    -- Verificamos si el viaje ya ha llegado/concluído antes de realizar la actualización
    IF EXISTS (
        SELECT 1
        FROM viajes
        WHERE CODIGO = @CodigoViaje
            AND FECHA_LLEGADA_REAL IS NOT NULL
    )
    BEGIN
        -- Si el viaje ya había llegado, mostramos un mensaje indicando que no se puede actualicar
        PRINT 'No se puede actualizar la fecha de llegada estimada para un viaje que ya ha llegado.';
    END
    ELSE
    BEGIN
        -- Sino, Actualizamos la fecha de llegada estimada
        UPDATE viajes
        SET FECHA_LLEGADA_ESTIMADA = @NuevaFechaLlegadaEstimada
        WHERE CODIGO = @CodigoViaje;

        -- Por último, mostramos un mensaje de éxito
        PRINT 'Fecha de llegada estimada actualizada exitosamente.';
    END
END;

--Ejercicio 5)
-- Creamos el Stored Procedure
CREATE PROCEDURE ObtenerPatenteCamionAsignado
    @DNIChofer VARCHAR(15),
    @FechaConsulta DATE,
    @MensajeResultado NVARCHAR(255) OUTPUT,
    @PatenteCamion VARCHAR(10) OUTPUT
AS
BEGIN
    -- Verificamos si el chofer existe y tiene un camión asignado en la fecha dada
    IF EXISTS (
        SELECT 1
        FROM choferes_camiones AS cc
        INNER JOIN camiones AS c ON cc.PATENTE_CAMION = c.PATENTE
        WHERE cc.DNI_CHOFER = @DNIChofer
            AND @FechaConsulta BETWEEN cc.FECHA_ASIGNACION AND ISNULL(cc.FECHA_DESOBLIGACION, '9999-12-31')
    )
    BEGIN
        -- Si el chofer tiene un camión asignado, obtenemos la patente
        SELECT @PatenteCamion = c.PATENTE
        FROM choferes_camiones AS cc
        INNER JOIN camiones AS c ON cc.PATENTE_CAMION = c.PATENTE
        WHERE cc.DNI_CHOFER = @DNIChofer
            AND @FechaConsulta BETWEEN cc.FECHA_ASIGNACION AND ISNULL(cc.FECHA_DESOBLIGACION, '9999-12-31'); --Isnull es una funcion que si detecta en este caso FECHA_DESOBLIGACION en null toma como valor arbitrario el que le pusimos que es 9999-12-31 

        -- Configuramos el mensaje de éxito
        SET @MensajeResultado = 'El chofer tiene un camión asignado en la fecha dada.';
    END
    ELSE
    BEGIN
        -- Si el chofer no tiene un camión asignado, configuramos el mensaje correspondiente
        SET @MensajeResultado = 'El chofer no tiene un camión asignado en la fecha dada.';
    END
END;

----

DECLARE @Resultado NVARCHAR(255);
DECLARE @PatenteResultado VARCHAR(10);

-- Ejemplo de cómo llamar al Stored Procedure
EXEC ObtenerPatenteCamionAsignado @DNIChofer = '27548896', @FechaConsulta = '2023-11-06', @MensajeResultado = @Resultado OUTPUT, @PatenteCamion = @PatenteResultado OUTPUT;

-- Mostramos los resultados
PRINT @Resultado;
PRINT 'Patente del camión: ' + ISNULL(@PatenteResultado, 'N/A');