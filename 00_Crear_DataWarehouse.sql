-- Data Warehouse de fraude con tarjetas de crédito
-- Ejecutar primero en MySQL Workbench. Luego ejecutar los KTR en el orden indicado.
CREATE DATABASE IF NOT EXISTS credit_card_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE credit_card_db;

-- Tabla de aterrizaje: la llena 01_Carga_Staging.ktr
CREATE TABLE IF NOT EXISTS credit_card_fraud_test (
  nombre_tarjeta VARCHAR(150) NULL,
  fecha DATE NULL,
  hora INT NULL,
  monto VARCHAR(20) NULL,
  tipo_tarjeta INT NULL,
  intentos_cvv INT NULL,
  comprador_recurrente INT NULL,
  devoluciones INT NULL,
  reclamaciones INT NULL,
  total_compras INT NULL,
  autorizacion INT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS dim_tarjeta (
  tarjeta_key INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre_tarjeta VARCHAR(150) NOT NULL,
  tipo_tarjeta INT NOT NULL,
  UNIQUE KEY uq_dim_tarjeta (nombre_tarjeta, tipo_tarjeta)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS dim_fecha (
  fecha_key INT NOT NULL PRIMARY KEY,
  fecha DATE NOT NULL UNIQUE,
  dia TINYINT NOT NULL,
  mes TINYINT NOT NULL,
  anio SMALLINT NOT NULL,
  trimestre TINYINT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS dim_autorizacion (
  autorizacion_key INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  codigo_autorizacion INT NOT NULL UNIQUE,
  descripcion VARCHAR(40) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS dim_comprador (
  comprador_key INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  comprador_recurrente TINYINT NOT NULL UNIQUE,
  descripcion VARCHAR(40) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS fact_transacciones (
  transaccion_key BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  tarjeta_key INT NOT NULL,
  fecha_key INT NOT NULL,
  autorizacion_key INT NOT NULL,
  comprador_key INT NOT NULL,
  hora INT NULL,
  monto DECIMAL(12,2) NULL,
  intentos_cvv INT NULL,
  devoluciones INT NULL,
  reclamaciones INT NULL,
  total_compras INT NULL,
  CONSTRAINT fk_fact_tarjeta FOREIGN KEY (tarjeta_key) REFERENCES dim_tarjeta(tarjeta_key),
  CONSTRAINT fk_fact_fecha FOREIGN KEY (fecha_key) REFERENCES dim_fecha(fecha_key),
  CONSTRAINT fk_fact_autorizacion FOREIGN KEY (autorizacion_key) REFERENCES dim_autorizacion(autorizacion_key),
  CONSTRAINT fk_fact_comprador FOREIGN KEY (comprador_key) REFERENCES dim_comprador(comprador_key)
) ENGINE=InnoDB;

-- Consultas de verificación posteriores a la ejecución de Pentaho:
SELECT 'staging' AS tabla, COUNT(*) AS registros FROM credit_card_fraud_test
UNION ALL SELECT 'dim_tarjeta', COUNT(*) FROM dim_tarjeta
UNION ALL SELECT 'dim_fecha', COUNT(*) FROM dim_fecha
UNION ALL SELECT 'dim_autorizacion', COUNT(*) FROM dim_autorizacion
UNION ALL SELECT 'dim_comprador', COUNT(*) FROM dim_comprador
UNION ALL SELECT 'fact_transacciones', COUNT(*) FROM fact_transacciones;

SELECT * FROM dim_tarjeta ORDER BY tarjeta_key LIMIT 10;
SELECT * FROM dim_fecha ORDER BY fecha_key LIMIT 10;
SELECT * FROM dim_autorizacion ORDER BY autorizacion_key;
SELECT * FROM dim_comprador ORDER BY comprador_key;
SELECT * FROM fact_transacciones ORDER BY transaccion_key LIMIT 10;
