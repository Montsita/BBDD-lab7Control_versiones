DROP DATABASE IF EXISTS control_calidad;
CREATE DATABASE control_calidad;
USE control_calidad;

-- creo una tabla secundaria para almacenar los diferentes cursos y una descripcion de ellos
CREATE TABLE cursos (
    id INT primary key auto_increment,
    nombre VARCHAR(255),
    descripcion VARCHAR(255)
);

-- como un estudiante puede hacer muchos cursos y los cursos pueden ser hechos por muchos estudiantes, necesito crear una tabla intermedia para esta relacion de many to many
-- creo la tabla estudiantes para poder hacer la relacion many to many
CREATE TABLE Estudiantes (
	dni VARCHAR(20) primary key, -- pongo el dni como primary key para que nunca se repita seguro
    Nombre VARCHAR(100)
);

CREATE TABLE cursos_estudiantes (
    cursos_id INT,
    dni_estudiante VARCHAR (20),
    PRIMARY KEY (cursos_id, dni_estudiante),
    FOREIGN KEY (cursos_id) REFERENCES cursos(id),
    FOREIGN KEY (dni_estudiante) REFERENCES Estudiantes(dni)
);

-- a continuación añado los datos a las tablas de forma correcta
INSERT INTO cursos (nombre, descripcion) VALUES
('Matemáticas', 'Curso de matemáticas avanzadas'),
('Historia', 'Curso de historia universal'),
('Biología', 'Curso de biología general'),
('Física', 'Curso de física teórica'),
('Química', 'Curso de química orgánica');

INSERT INTO Estudiantes (dni, nombre) VALUES
("1567890R", 'Juan Pérez'),
("2567890H", 'Ana Gómez'),
("3567890J", 'Luis Rodríguez');

INSERT INTO cursos_estudiantes (cursos_id, dni_estudiante) VALUES
(1, '1567890R'),
(2, '1567890R'),
(3, '2567890H'),
(1, '3567890J'),
(4, '3567890J'),
(5, '3567890J');

-- creo una tabla proveedores ya que necesito tener toda la información en una tabla y poder acceder a ella desde los productos
CREATE TABLE proveedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    email VARCHAR(100),
    fecha_registro DATE
);

-- tambien he sacado los acentos
CREATE TABLE Productos (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Categoria VARCHAR(100),
    Proveedor VARCHAR(100),
    Precio DECIMAL(10, 2),
    proveedores_id INT,
    FOREIGN KEY (proveedores_id) REFERENCES proveedores(id) -- hago una clave foranea para poder acceder a los proveedores que me traen los productos
    -- Lo hago de esta manera para no tener tantas tablas many to many, por tanto un producto solo lo proveerá un proveedor, pero el mismo proveedor puede distribuir diferentes productos
);

-- Como esta tabla estaba almacenando múltiples números de teléfono en una sola columna, pero telefono no creo que sea un dato suficientemente importante para hacer una tabla
-- he añadido otro atributo más para añadir un segundo telefono y les he puesto a ambos int porque son numero no textos
-- y desde luego he sacado los acentos.
CREATE TABLE Clientes (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Email VARCHAR(100),
    Telefono_movil INT,
    telefono_fijo INT,
    Dirección VARCHAR(255)
);

CREATE TABLE Pedidos (
    ID INT PRIMARY KEY, 
    Fecha DATE,
    id_cliente INT,
    producto_id INT,
    Cantidades DECIMAL(10, 2), -- Corregido poniendo DECIMAL ya que cantidades pueden ser o no decimales, pero asi admite los dos posibles numeros
    Total DECIMAL(10, 2),
    Estado enum ("realizado", "completandose", "incompleto"), -- pongo un enum para que se puedan registrar tres posibles estados y despues a la hora de interactuar con este dato sea más facil
    FOREIGN KEY (producto_id) REFERENCES Productos(ID),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(ID) -- aqui relaciono los pedidos con clientes porque sin clientes no hay pedidos, le hago una relacion one to many
    			   									-- ya que un cliente puede hacer más de un pedido pero un pedido solo es hecho por un cliente
);
-- como un pedido puede tener diferentes productos pero un producto no se repite en un pedido, la cantidad si pero no el producto como tal
-- creo una relacion one to many que son mas correctas, ademas si se compra más de una unidad de el mismo producto se verá reflejado en cantidad
