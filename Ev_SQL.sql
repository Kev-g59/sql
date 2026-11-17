create database if not exists LibreriaCuentato;
Use LibreriaCuentato;
drop table if exists Transaccion;
drop table if exists Detallespedido;
drop table if exists Pedido;
drop table if exists Libro_Autor;
drop table if exists Cliente;
drop table if exists Autor;
drop table if exists Libro;

create table Autor(
	AutorID int auto_increment primary key,
    Nombre varchar(100) not null,
    FechaNacimiento date,
    Nacionalidad varchar(50)
);

create table Libro(
	LibroID int auto_increment primary key,
	Titulo varchar(200) not null,
	Editorial varchar(90) not null,
	Categorioa varchar(50) not null,
	FechaDePublicacion date,
	ISBN varchar(20) not null unique,
	Precio decimal(10,2) not null, 
	Stock int not null,
    constraint chk_precio_positivo check (precio>=0),
	constraint chk_stock_positivo check (stock>=0)
);

create table Libro_Autor(
	LibroID int,
	AutorID int,
	primary key (LibroID,AutorID),
	foreign key (LibroID) references Libro(LibroID) on delete cascade on update cascade,
	foreign key (AutorID) references Autor(AutorID) on delete cascade on update cascade

);

create table Cliente(
	ClienteID  int auto_increment primary key,
	NombreCompleto varchar(150) not null,
	CorreoElectronico varchar(100) not null,
	Telefono varchar(20),
	Direccion text
);

create table Pedido (
	PedidoID int auto_increment primary key,
	ClienteID int not null,
	FechaCompra datetime not null default current_timestamp,
	estado enum('pendiente','procesado','completado') not null default 'pendiente',
	constraint FK_Pedido_Cliente foreign key (ClienteID) references Cliente(ClienteID) on delete restrict on update cascade
);

create table Detallespedido(
	DetalleID int auto_increment primary key,
	PedidoID int not null,
	LibroID int not null,
	Cantidad int not null check (cantidad>=0),
	PrecioUnitario Decimal (10,2) not null,
	foreign key (PedidoID) references Pedido(PedidoID) on delete restrict on update cascade, 
	foreign key (LibroID) references Libro(LibroID) on delete restrict on update cascade
);

create table Transaccion(
	TransaccionID int auto_increment primary key,
	PedidoID int not null unique,
	MetodoPago varchar(60) not null,
	MontoTotal decimal (10,2) not null check (MontoTotal>=0),
	FechaTransaccion datetime not null default current_timestamp,
	constraint FK_Transaccion_Pedido foreign key (PedidoID) references Pedido(PedidoID) on delete restrict on update cascade
);
create index IX_Libro_Titulo on Libro(Titulo);
create index IX_Libro_Categoria on Libro(Categoria)

