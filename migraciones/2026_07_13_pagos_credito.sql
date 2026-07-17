-- Agrega el valor de la cuota a "creditos" y crea la tabla "pagos_credito"
-- para llevar el historial de pagos de cuotas y de la comisión (con su documento de respaldo).

ALTER TABLE creditos
    ADD COLUMN IF NOT EXISTS valor_cuota NUMERIC(12, 0);

CREATE TABLE IF NOT EXISTS pagos_credito (
    id                SERIAL PRIMARY KEY,
    credito_id        INTEGER      NOT NULL REFERENCES creditos(id) ON DELETE CASCADE,
    tipo_pago         VARCHAR(20)  NOT NULL,
    monto             NUMERIC(12, 0),
    forma_pago        VARCHAR(100),
    documento_nombre  VARCHAR(255),
    documento_tipo    VARCHAR(100),
    documento_datos   BYTEA,
    fecha_pago        TIMESTAMP    NOT NULL DEFAULT now()
);

ALTER TABLE pagos_credito
    DROP CONSTRAINT IF EXISTS pagos_credito_tipo_pago_check;

ALTER TABLE pagos_credito
    ADD CONSTRAINT pagos_credito_tipo_pago_check
    CHECK (tipo_pago IN ('cuota', 'comision'));

CREATE INDEX IF NOT EXISTS idx_pagos_credito_credito_id ON pagos_credito (credito_id);
