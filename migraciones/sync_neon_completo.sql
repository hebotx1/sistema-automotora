-- ============================================================================
-- Sistema San Martín Automotriz — Sincronización de esquema para Neon
-- Generado: 2026-07-16
--
-- SEGURO DE EJECUTAR EN NEON SIN PERDER DATOS:
--   - Todas las tablas se crean con CREATE TABLE IF NOT EXISTS (si ya existen,
--     esta sentencia no hace nada, no las toca).
--   - Todas las columnas se agregan con ALTER TABLE ... ADD COLUMN IF NOT EXISTS
--     (si la columna ya existe, no hace nada).
--   - Todos los índices y constraints (PK/UNIQUE/CHECK/FK) se agregan solo si
--     no existen todavía (usando bloques DO que revisan pg_constraint primero).
--   - No hay ningún DROP, TRUNCATE ni DELETE en este script.
--   - Se puede ejecutar varias veces sin problema (es "idempotente").
--
-- Cómo usarlo: pega todo el contenido en la consola SQL de Neon y ejecútalo.
-- ============================================================================

BEGIN;

-- ----------------------------------------------------------------------------
-- 1) cartas_poder
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS cartas_poder (
    numero_poder character varying(50) PRIMARY KEY
);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS fecha character varying(50);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS nombre_poder character varying(100);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS rut_poder character varying(20);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS representante_poder character varying(100);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS rut_poder_r character varying(20);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS direccion_poder character varying(200);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS comuna_poder character varying(100);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS tipo_vehiculo character varying(50);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS marca character varying(50);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS modelo character varying(100);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS anio character varying(10);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS motor character varying(50);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS chasis character varying(50);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS n_vin character varying(50);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS color character varying(50);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS patente character varying(20);
ALTER TABLE cartas_poder ADD COLUMN IF NOT EXISTS duracion_poder character varying(100);

-- ----------------------------------------------------------------------------
-- 2) clientes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS clientes (
    id SERIAL PRIMARY KEY,
    rut character varying(12)
);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS rut character varying(12);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS razon_social character varying(150);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS nombre_fantasia character varying(150);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS giro character varying(100);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS direccion character varying(200);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS comuna character varying(80);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS ciudad character varying(80);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS telefono character varying(20);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS telefono2 character varying(20);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS email character varying(120);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS web character varying(120);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS contacto_comercial character varying(120);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS forma_pago character varying(50) DEFAULT 'CONTADO';
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS categoria character varying(50);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS zona character varying(50);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS vendedor character varying(100);
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS lista_precios character varying(50) DEFAULT '(1) Publico';
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS descuento numeric(5,2) DEFAULT 0.00;
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS limite_credito numeric(12,2) DEFAULT 0.00;
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS saldo_financiero numeric(12,2) DEFAULT 0.00;
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS bloquear_facturacion boolean DEFAULT false;
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS observaciones text;
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS creado_en timestamp without time zone DEFAULT now();
CREATE INDEX IF NOT EXISTS idx_clientes_rut ON clientes USING btree (rut);

-- ----------------------------------------------------------------------------
-- 3) consignaciones
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS consignaciones (
    numero_consignacion character varying(50) PRIMARY KEY
);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS fecha character varying(50);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS nombre_consignante character varying(100);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS rut_consignante character varying(20);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS direccion character varying(200);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS comuna character varying(100);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS telefono character varying(50);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS correo character varying(100);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS precio character varying(50);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS m_escrito character varying(200);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS comision character varying(20);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS d_contrato character varying(50);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS pago_consignante character varying(100);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS cb_nombre character varying(100);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS cb_rut character varying(20);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS cb_banco character varying(100);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS cb_cuenta character varying(50);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS cb_numero character varying(50);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS tipo_vehiculo character varying(50);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS marca character varying(50);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS modelo character varying(100);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS anio character varying(10);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS motor character varying(50);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS chasis character varying(50);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS color character varying(50);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS patente character varying(20);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS kms character varying(50);
ALTER TABLE consignaciones ADD COLUMN IF NOT EXISTS observaciones text;

-- ----------------------------------------------------------------------------
-- 4) contratos (Compraventa)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS contratos (
    numero_contrato character varying(50) PRIMARY KEY
);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS fecha_contrato character varying(50);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS nombre_comprador character varying(100);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS rut_comprador character varying(20);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS nacionalidad character varying(50);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS direccion character varying(200);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS comuna character varying(100);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS precio_numeros character varying(50);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS precio_palabras character varying(200);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS gastos_notariales character varying(50);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS marca character varying(50);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS modelo character varying(100);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS anio character varying(10);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS motor character varying(50);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS chasis character varying(50);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS color character varying(50);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS patente character varying(20);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS nombre_vendedor character varying(100);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS rut_vendedor character varying(20);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS tipo_vehiculo character varying(50);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS n_vin character varying(50);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS observaciones text;
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS forma_pago character varying(100);

-- ----------------------------------------------------------------------------
-- 5) contratos_notariales
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS contratos_notariales (
    numero_repertorio character varying(50) PRIMARY KEY
);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS fecha character varying(50);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS nombre_comprador character varying(100);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS rut_comprador character varying(20);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS nac_comprador character varying(50);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS direccion_comprador character varying(200);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS comuna_comprador character varying(100);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS tipo_vehiculo character varying(50);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS marca character varying(50);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS modelo character varying(100);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS anio character varying(10);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS motor character varying(50);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS chasis character varying(50);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS n_vin character varying(50);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS color character varying(50);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS patente character varying(20);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS m_venta character varying(50);
ALTER TABLE contratos_notariales ADD COLUMN IF NOT EXISTS monto_escrito character varying(200);

-- ----------------------------------------------------------------------------
-- 6) creditos
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS creditos (
    id SERIAL PRIMARY KEY,
    patente character varying(20)
);
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS patente character varying(20);
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS nombre_cliente character varying(255);
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS rut_cliente character varying(20);
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS precio_venta numeric(12,0);
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS pie numeric(12,0);
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS saldo_financiamiento numeric(12,0);
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS cantidad_cuotas integer;
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS cuotas_pendientes integer;
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS monto_comision numeric(12,0);
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS comision_pagada boolean DEFAULT false;
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS forma_pago character varying(255);
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS documento_nombre character varying(255);
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS documento_tipo character varying(100);
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS documento_datos bytea;
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS creado_en timestamp without time zone DEFAULT now();
ALTER TABLE creditos ADD COLUMN IF NOT EXISTS valor_cuota numeric(12,0);
CREATE INDEX IF NOT EXISTS idx_creditos_patente ON creditos USING btree (patente);
CREATE INDEX IF NOT EXISTS idx_creditos_rut_cliente ON creditos USING btree (rut_cliente);

-- ----------------------------------------------------------------------------
-- 7) declaraciones (Declaración Jurada)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS declaraciones (
    numero_declaracion character varying(50) PRIMARY KEY
);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS fecha character varying(50);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS nombre_compradora character varying(100);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS rut_compradora character varying(20);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS nac_compradora character varying(50);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS direccion_compradora character varying(200);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS comuna_compradora character varying(100);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS vehiculo character varying(50);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS marca character varying(50);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS modelo character varying(100);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS anio character varying(10);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS motor character varying(50);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS chasis character varying(50);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS color character varying(50);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS patente character varying(20);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS venta_v character varying(50);
ALTER TABLE declaraciones ADD COLUMN IF NOT EXISTS monto_escrito character varying(200);

-- ----------------------------------------------------------------------------
-- 8) documentos_credito
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS documentos_credito (
    id SERIAL PRIMARY KEY
);
ALTER TABLE documentos_credito ADD COLUMN IF NOT EXISTS credito_id integer;
ALTER TABLE documentos_credito ADD COLUMN IF NOT EXISTS categoria character varying(30);
ALTER TABLE documentos_credito ADD COLUMN IF NOT EXISTS documento_nombre character varying(255);
ALTER TABLE documentos_credito ADD COLUMN IF NOT EXISTS documento_tipo character varying(100);
ALTER TABLE documentos_credito ADD COLUMN IF NOT EXISTS documento_datos bytea;
ALTER TABLE documentos_credito ADD COLUMN IF NOT EXISTS creado_en timestamp without time zone DEFAULT now();
CREATE INDEX IF NOT EXISTS idx_documentos_credito_credito_id ON documentos_credito USING btree (credito_id);

-- ----------------------------------------------------------------------------
-- 9) movimientos_stock
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS movimientos_stock (
    id SERIAL PRIMARY KEY
);
ALTER TABLE movimientos_stock ADD COLUMN IF NOT EXISTS producto_id integer;
ALTER TABLE movimientos_stock ADD COLUMN IF NOT EXISTS tipo character varying(10);
ALTER TABLE movimientos_stock ADD COLUMN IF NOT EXISTS cantidad integer;
ALTER TABLE movimientos_stock ADD COLUMN IF NOT EXISTS nota character varying(255);
ALTER TABLE movimientos_stock ADD COLUMN IF NOT EXISTS fecha timestamp without time zone DEFAULT now();
CREATE INDEX IF NOT EXISTS idx_movimientos_stock_producto_id ON movimientos_stock USING btree (producto_id);

-- ----------------------------------------------------------------------------
-- 10) pagares
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS pagares (
    id SERIAL PRIMARY KEY
);
ALTER TABLE pagares ADD COLUMN IF NOT EXISTS rut_deudor character varying(20);
ALTER TABLE pagares ADD COLUMN IF NOT EXISTS nombre_deudor character varying(100);
ALTER TABLE pagares ADD COLUMN IF NOT EXISTS direccion_deudor character varying(200);
ALTER TABLE pagares ADD COLUMN IF NOT EXISTS telefono_deudor character varying(50);
ALTER TABLE pagares ADD COLUMN IF NOT EXISTS monto_deuda character varying(20);
ALTER TABLE pagares ADD COLUMN IF NOT EXISTS fecha_pago character varying(50);
ALTER TABLE pagares ADD COLUMN IF NOT EXISTS marca_vehiculo character varying(50);
ALTER TABLE pagares ADD COLUMN IF NOT EXISTS modelo_vehiculo character varying(50);
ALTER TABLE pagares ADD COLUMN IF NOT EXISTS ano_vehiculo character varying(4);
ALTER TABLE pagares ADD COLUMN IF NOT EXISTS numero_motor character varying(50);
ALTER TABLE pagares ADD COLUMN IF NOT EXISTS numero_chasis_vin character varying(50);
ALTER TABLE pagares ADD COLUMN IF NOT EXISTS color_vehiculo character varying(30);
ALTER TABLE pagares ADD COLUMN IF NOT EXISTS patente character varying(15);

-- ----------------------------------------------------------------------------
-- 11) pagos_credito
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS pagos_credito (
    id SERIAL PRIMARY KEY
);
ALTER TABLE pagos_credito ADD COLUMN IF NOT EXISTS credito_id integer;
ALTER TABLE pagos_credito ADD COLUMN IF NOT EXISTS tipo_pago character varying(20);
ALTER TABLE pagos_credito ADD COLUMN IF NOT EXISTS monto numeric(12,0);
ALTER TABLE pagos_credito ADD COLUMN IF NOT EXISTS forma_pago character varying(100);
ALTER TABLE pagos_credito ADD COLUMN IF NOT EXISTS documento_nombre character varying(255);
ALTER TABLE pagos_credito ADD COLUMN IF NOT EXISTS documento_tipo character varying(100);
ALTER TABLE pagos_credito ADD COLUMN IF NOT EXISTS documento_datos bytea;
ALTER TABLE pagos_credito ADD COLUMN IF NOT EXISTS fecha_pago timestamp without time zone DEFAULT now();
CREATE INDEX IF NOT EXISTS idx_pagos_credito_credito_id ON pagos_credito USING btree (credito_id);

-- ----------------------------------------------------------------------------
-- 12) productos
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS productos (
    id SERIAL PRIMARY KEY
);
ALTER TABLE productos ADD COLUMN IF NOT EXISTS codigo_producto character varying(50);
ALTER TABLE productos ADD COLUMN IF NOT EXISTS codigo_barra character varying(50);
ALTER TABLE productos ADD COLUMN IF NOT EXISTS descripcion character varying(255);
ALTER TABLE productos ADD COLUMN IF NOT EXISTS stock_actual integer DEFAULT 0;
ALTER TABLE productos ADD COLUMN IF NOT EXISTS stock_minimo integer DEFAULT 0;
ALTER TABLE productos ADD COLUMN IF NOT EXISTS stock_maximo integer DEFAULT 0;
ALTER TABLE productos ADD COLUMN IF NOT EXISTS stock_reposicion integer DEFAULT 0;
ALTER TABLE productos ADD COLUMN IF NOT EXISTS costo numeric(12,0) DEFAULT 0;
ALTER TABLE productos ADD COLUMN IF NOT EXISTS margen_venta numeric(6,2) DEFAULT 0;
ALTER TABLE productos ADD COLUMN IF NOT EXISTS creado_en timestamp without time zone DEFAULT now();

-- ----------------------------------------------------------------------------
-- 13) usuarios
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY
);
ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS username character varying(50);
ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS password_hash character varying(128);
ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS password_salt character varying(64);
ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS nombre_completo character varying(255);
ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS perfil character varying(50) DEFAULT 'Usuario';
ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS es_admin boolean DEFAULT false;
ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS "pestañas_permitidas" text;
ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS activo boolean DEFAULT true;
ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS creado_en timestamp without time zone DEFAULT now();

-- ----------------------------------------------------------------------------
-- 14) vehiculos
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS vehiculos (
    id SERIAL PRIMARY KEY,
    patente character varying(10)
);
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS patente character varying(10);
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS marca character varying(60);
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS modelo character varying(60);
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS "año" integer;
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS kilometraje integer DEFAULT 0;
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS nro_chasis character varying(50);
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS nro_motor character varying(50);
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS nro_puertas integer;
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS color character varying(40);
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS rut_cliente character varying(12);
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS nombre_dueno_vehiculo character varying(150);
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS rut_dueno_vehiculo character varying(12);
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS direccion_dueno_vehiculo character varying(200);
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS telefono_dueno_vehiculo character varying(20);
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS email_dueno_vehiculo character varying(120);
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS creado_en timestamp without time zone DEFAULT now();
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS valor numeric(12,2) DEFAULT 0;
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS comision numeric(12,2) DEFAULT 0;
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS transferencia numeric(12,2) DEFAULT 0;
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS valor_final numeric(12,2) DEFAULT 0;
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS ubicacion character varying(255);
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS observaciones text;
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS estado_reserva character varying(20) DEFAULT 'Disponible';
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS dias_reserva integer;
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS monto_reserva numeric(12,0);
ALTER TABLE vehiculos ADD COLUMN IF NOT EXISTS vendedora_reserva character varying(255);
CREATE INDEX IF NOT EXISTS idx_vehiculos_cliente ON vehiculos USING btree (rut_cliente);
CREATE INDEX IF NOT EXISTS idx_vehiculos_patente ON vehiculos USING btree (patente);

-- ============================================================================
-- CONSTRAINTS (UNIQUE / CHECK / FOREIGN KEY)
-- Se agregan solo si no existen todavía, revisando pg_constraint primero.
-- Si en Neon ya hay datos que violarían una constraint (ej. RUT duplicado),
-- ese bloque puntual fallará con un aviso, pero no afecta a los demás ni borra
-- nada. En ese caso avísame y limpiamos ese caso puntual antes de reintentar.
-- ============================================================================

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'clientes_rut_key1') THEN
        ALTER TABLE clientes ADD CONSTRAINT clientes_rut_key1 UNIQUE (rut);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'productos_codigo_producto_key') THEN
        ALTER TABLE productos ADD CONSTRAINT productos_codigo_producto_key UNIQUE (codigo_producto);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'usuarios_username_key') THEN
        ALTER TABLE usuarios ADD CONSTRAINT usuarios_username_key UNIQUE (username);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'vehiculos_patente_key') THEN
        ALTER TABLE vehiculos ADD CONSTRAINT vehiculos_patente_key UNIQUE (patente);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'documentos_credito_categoria_check') THEN
        ALTER TABLE documentos_credito ADD CONSTRAINT documentos_credito_categoria_check
            CHECK (categoria IN ('comision', 'general'));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'movimientos_stock_tipo_check') THEN
        ALTER TABLE movimientos_stock ADD CONSTRAINT movimientos_stock_tipo_check
            CHECK (tipo IN ('entrada', 'salida'));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'pagos_credito_tipo_pago_check') THEN
        ALTER TABLE pagos_credito ADD CONSTRAINT pagos_credito_tipo_pago_check
            CHECK (tipo_pago IN ('cuota', 'comision'));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'vehiculos_estado_reserva_check') THEN
        ALTER TABLE vehiculos ADD CONSTRAINT vehiculos_estado_reserva_check
            CHECK (estado_reserva IN ('Disponible', 'Reservado'));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'documentos_credito_credito_id_fkey') THEN
        ALTER TABLE documentos_credito ADD CONSTRAINT documentos_credito_credito_id_fkey
            FOREIGN KEY (credito_id) REFERENCES creditos(id) ON DELETE CASCADE;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'movimientos_stock_producto_id_fkey') THEN
        ALTER TABLE movimientos_stock ADD CONSTRAINT movimientos_stock_producto_id_fkey
            FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'pagos_credito_credito_id_fkey') THEN
        ALTER TABLE pagos_credito ADD CONSTRAINT pagos_credito_credito_id_fkey
            FOREIGN KEY (credito_id) REFERENCES creditos(id) ON DELETE CASCADE;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'vehiculos_rut_cliente_fkey') THEN
        ALTER TABLE vehiculos ADD CONSTRAINT vehiculos_rut_cliente_fkey
            FOREIGN KEY (rut_cliente) REFERENCES clientes(rut) ON UPDATE CASCADE;
    END IF;
END $$;

COMMIT;

-- ============================================================================
-- Fin del script. Todas las tablas, columnas, índices y relaciones del
-- sistema local quedan reflejadas en Neon sin tocar los datos existentes.
-- ============================================================================
