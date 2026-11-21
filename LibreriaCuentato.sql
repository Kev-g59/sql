create database if not exists LibreriaCuentato;
Use LibreriaCuentato;
drop table if exists Transaccion;
drop table if exists Detallespedido;
drop table if exists Pedido;
drop table if exists Libro_Autor;
drop table if exists Cliente;
drop table if exists Autor;
drop table if exists Libro;
drop table if exists Categoria;
drop table if exists Editorial;

create table Autor(
	AutorID int auto_increment primary key,
    Nombre varchar(100) not null,
    FechaNacimiento date,
    Nacionalidad varchar(50)
);

create table Categoria(
	CategoriaID int auto_increment primary key,
	Nombre varchar(50) not null unique
);

create table Editorial(
	EditorialID int auto_increment primary key,
	Nombre varchar(90) not null unique,
	Pais varchar(50)
);

create table Libro(
	LibroID int auto_increment primary key,
	Titulo varchar(200) not null,
	EditorialID int not null,
	CategoriaID int not null,
	FechaDePublicacion date,
	ISBN varchar(20) not null unique,
	Precio decimal(10,2) not null,
	stock int not null,
    constraint chk_precio_positivo check (precio>=0),
	constraint chk_stock_positivo check (stock>=0),
	constraint chk_isbn check (char_length(ISBN) in (10,13)),
	constraint FK_Libro_Editorial foreign key (EditorialID) references Editorial(EditorialID) on delete restrict on update cascade,
	constraint FK_Libro_Categoria foreign key (CategoriaID) references Categoria(CategoriaID) on delete restrict on update cascade
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
	CorreoElectronico varchar(100) not null unique,
	Telefono varchar(15),
	Direccion text,
	constraint chk_telefono check (Telefono regexp '^[0-9]{7,15}$'),
	constraint chk_correo check (CorreoElectronico like '%@%.%')
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
	Cantidad int not null,
	PrecioUnitario Decimal (10,2) not null,
	constraint chk_cantidad check (Cantidad>0),
	constraint chk_precio_unitario check (PrecioUnitario>=0),
	foreign key (PedidoID) references Pedido(PedidoID) on delete restrict on update cascade,
	foreign key (LibroID) references Libro(LibroID) on delete restrict on update cascade
);

create table Transaccion(
	TransaccionID int auto_increment primary key,
	PedidoID int not null unique,
	MetodoPago enum('efectivo','tarjeta_credito','tarjeta_debito','transferencia','pse','nequi') not null,
	MontoTotal decimal (10,2) not null check (MontoTotal>=0),
	FechaTransaccion datetime not null default current_timestamp,
	constraint FK_Transaccion_Pedido foreign key (PedidoID) references Pedido(PedidoID) on delete restrict on update cascade
);
create index IX_Libro_Titulo on Libro(Titulo);
