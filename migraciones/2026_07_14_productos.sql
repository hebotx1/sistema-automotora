-- Crea las tablas para la nueva pestaña de Productos (catálogo + stock).

CREATE TABLE IF NOT EXISTS productos (
    id                  SERIAL PRIMARY KEY,
    codigo_producto     VARCHAR(50)   NOT NULL UNIQUE,
    codigo_barra        VARCHAR(50),
    descripcion         VARCHAR(255)  NOT NULL,
    stock_actual        INTEGER       NOT NULL DEFAULT 0,
    stock_minimo        INTEGER       NOT NULL DEFAULT 0,
    stock_maximo        INTEGER       NOT NULL DEFAULT 0,
    stock_reposicion    INTEGER       NOT NULL DEFAULT 0,
    costo               NUMERIC(12,0) NOT NULL DEFAULT 0,
    margen_venta        NUMERIC(6,2)  NOT NULL DEFAULT 0,
    creado_en           TIMESTAMP     NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS movimientos_stock (
    id            SERIAL PRIMARY KEY,
    producto_id   INTEGER      NOT NULL REFERENCES productos(id) ON DELETE CASCADE,
    tipo          VARCHAR(10)  NOT NULL,
    cantidad      INTEGER      NOT NULL,
    nota          VARCHAR(255),
    fecha         TIMESTAMP    NOT NULL DEFAULT now()
);

ALTER TABLE movimientos_stock
    DROP CONSTRAINT IF EXISTS movimientos_stock_tipo_check;

ALTER TABLE movimientos_stock
    ADD CONSTRAINT movimientos_stock_tipo_check
    CHECK (tipo IN ('entrada', 'salida'));

CREATE INDEX IF NOT EXISTS idx_movimientos_stock_producto_id ON movimientos_stock (producto_id);
