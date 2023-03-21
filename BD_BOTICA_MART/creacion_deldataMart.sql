CREATE DATABASE Botica_Linares

USE Botica_Linares

CREATE TABLE Admin(
IdAdmin int primary key not null,
Usuario varchar(50) not null,
Password varchar(50) not null
);

SELECT * FROM Dim_Cliente
SELECT *FROM MST_CLIENTE

CREATE TABLE Dim_Cliente(
Cliente_Skey INT IDENTITY PRIMARY KEY NOT NULL,
Cliente_Nombre VARCHAR(200) NULL,
Nombre_Empresa  VARCHAR(200) NULL,
Nro_Documento VARCHAR(200) NULL,
IdCliente INT NOT NULL
);	

SELECT * FROM MST_USUARIOS

CREATE TABLE Dim_Usuario(
Usuario_Skey INT IDENTITY PRIMARY KEY NOT NULL,
Nombre_Apellidos VARCHAR(100) NOT NULL,
DNI VARCHAR(50) NOT NULL,
Correo varchar(200) NULL,
Fecha_Creacion date not null,
Usuario VARCHAR(50) NOT NULL,
password varchar(50) NOT NULL,
IdUsuario INT NOT NULL
);

SELECT * FROM MST_producto

CREATE TABLE Dim_Producto(
Producto_Skey INT IDENTITY PRIMARY KEY NOT NULL,
Producto_Nombre VARCHAR(100) NULL,
Estado BIT NULL,
IdProducto INT NOT NULL,
);

SELECT * FROM MST_PROVEEDOR

CREATE TABLE Dim_Proveedor(
Proveedor_Skey INT IDENTITY PRIMARY KEY NOT NULL,
Proveedor_Nombre VARCHAR(100) NULL,
RUC VARCHAR(20) NULL,
Direccion VARCHAR (100) NULL,
IdProveedor INT NOT NULL
);

SELECT * FROM MST_VENTA  (FechaEmision)

CREATE TABLE Dim_Tiempo(
Tiempo_SKey int identity primary key not null,
Fecha_Actual date null,
Tiempo_Año int  null,
Tiempo_Semestre varchar(50)  null,
Tiempo_Trimestre varchar(50)  null,
Tiempo_Mes varchar(50)  null
);

SELECT * FROM mst_Venta_det

CREATE TABLE Hecho_Ventas(
Cliente_SKey int  not null,
foreign key (Cliente_SKey) references
[dbo].[Dim_Cliente](Cliente_SKey),
Usuario_SKey int  not null,
foreign key (Usuario_SKey) references
[dbo].[Dim_Usuario](Usuario_SKey),
Producto_SKey int not null,
foreign key (Producto_SKey) references
[dbo].[Dim_Producto](Producto_SKey),
Proveedor_SKey int  not null,
foreign key (Proveedor_SKey) references
[dbo].[Dim_Proveedor](Proveedor_SKey),
Tiempo_SKey int  not null,
foreign key (Tiempo_SKey) references
[dbo].[Dim_Tiempo](Tiempo_SKey),
Precio_Unitario MONEY NULL,
Cantidad MONEY NULL,
Total MONEY NULL
);


truncate table hecho_ventas
delete Dim_cliente
delete Dim_Usuario
delete Dim_producto
delete Dim_proveedor
delete Dim_tiempo
dbcc checkident (dim_cliente, reseed, 0)
dbcc checkident (dim_usuario, reseed, 0)
dbcc checkident (dim_producto, reseed, 0)
dbcc checkident (dim_proveedor, reseed, 0)
dbcc checkident (dim_tiempo, reseed, 0)


select * from DIM_TIEMPO

merge Botica_Linares.dbo.Dim_Tiempo AS do
USING(SELECT
DISTINCT CONVERT(CHAR(10),fechaEmision, 120) fecha,
YEAR(fechaEmision) año,
CAST(YEAR(fechaEmision) AS CHAR(4)) + ' ' +
'- S' + CAST((CASE WHEN DATEPART(MM,fechaEmision) <= 6 THEN 1
ELSE 2 END) AS CHAR(1)) sem,
CAST(YEAR(fechaEmision) AS CHAR(4)) + ' ' +
'- T' + CAST(DATEPART(QQ, fechaEmision) AS CHAR(1)) tri,
DATENAME(MM,fechaEmision) mes
FROM mst_venta
) AS temp
 ON temp.año = do.Tiempo_Skey
WHEN NOT MATCHED THEN
INSERT VALUES (fecha,año, sem, tri,mes);


SELECT * FROM HECHO_VENTAS

SELECT Cliente_SKey,Usuario_SKey,Producto_SKey,Proveedor_Skey,Tiempo_SKey
,vd.precioUnit,vd.cantidad,(vd.precioUnit*vd.cantidad)AS Total FROM mst_venta_det vd
INNER JOIN [dbo].[mst_Venta] v ON vd.IdVenta = v.Id
INNER JOIN [dbo].[mst_Producto] P ON vd.IdProducto = P.id
INNER JOIN [dbo].[mst_Proveedor] pr ON p.idproveedor=pr.id	
INNER JOIN [dbo].[mst_Usuarios] u on v.IdUsuario=u.Id
INNER JOIN [dbo].[mst_Cliente] c on v.IdCliente=c.Id
INNER JOIN Botica_Linares.dbo.Dim_Cliente DC ON
DC.IdCliente = c.Id
INNER JOIN Botica_Linares.dbo.Dim_Usuario DU ON
DU.IdUsuario = u.Id
INNER JOIN Botica_Linares.dbo.Dim_Producto DP ON
DP.IdProducto =p.Id
INNER JOIN Botica_Linares.dbo.Dim_Proveedor DPR ON
DPR.IdProveedor=pr.id
INNER JOIN Botica_Linares.dbo.Dim_Tiempo DT
ON DT.Fecha_Actual =
CONVERT(CHAR(10),v.FechaEmision,120)




