-- Crea la tabla "creditos" para la nueva pestaña de Créditos.

CREATE TABLE IF NOT EXISTS creditos (
    id                    SERIAL PRIMARY KEY,
    patente               VARCHAR(20)  NOT NULL,
    nombre_cliente        VARCHAR(255),
    rut_cliente           VARCHAR(20),
    precio_venta          NUMERIC(12, 0),
    pie                   NUMERIC(12, 0),
    saldo_financiamiento  NUMERIC(12, 0),
    cantidad_cuotas       INTEGER,
    cuotas_pendientes     INTEGER,
    monto_comision        NUMERIC(12, 0),
    comision_pagada       BOOLEAN      NOT NULL DEFAULT FALSE,
    forma_pago            VARCHAR(255),
    documento_nombre      VARCHAR(255),
    documento_tipo        VARCHAR(100),
    documento_datos       BYTEA,
    creado_en             TIMESTAMP    NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_creditos_patente ON creditos (patente);
CREATE INDEX IF NOT EXISTS idx_creditos_rut_cliente ON creditos (rut_cliente);
