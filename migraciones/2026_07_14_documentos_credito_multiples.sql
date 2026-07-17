-- Permite adjuntar varios documentos de respaldo (comisión y general) a un crédito,
-- en vez de un solo documento por registro.

CREATE TABLE IF NOT EXISTS documentos_credito (
    id                SERIAL PRIMARY KEY,
    credito_id        INTEGER      NOT NULL REFERENCES creditos(id) ON DELETE CASCADE,
    categoria         VARCHAR(30)  NOT NULL,
    documento_nombre  VARCHAR(255),
    documento_tipo    VARCHAR(100),
    documento_datos   BYTEA,
    creado_en         TIMESTAMP    NOT NULL DEFAULT now()
);

ALTER TABLE documentos_credito
    DROP CONSTRAINT IF EXISTS documentos_credito_categoria_check;

ALTER TABLE documentos_credito
    ADD CONSTRAINT documentos_credito_categoria_check
    CHECK (categoria IN ('comision', 'general'));

CREATE INDEX IF NOT EXISTS idx_documentos_credito_credito_id ON documentos_credito (credito_id);
