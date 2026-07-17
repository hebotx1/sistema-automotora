-- Agrega a "vehiculos" los campos: ubicación, observaciones y datos de reserva.
-- Ejecutar una sola vez contra la base de datos (pgAdmin, psql, etc.).

ALTER TABLE vehiculos
    ADD COLUMN IF NOT EXISTS ubicacion         VARCHAR(255),
    ADD COLUMN IF NOT EXISTS observaciones     TEXT,
    ADD COLUMN IF NOT EXISTS estado_reserva    VARCHAR(20) NOT NULL DEFAULT 'Disponible',
    ADD COLUMN IF NOT EXISTS dias_reserva      INTEGER,
    ADD COLUMN IF NOT EXISTS monto_reserva     NUMERIC(12, 0),
    ADD COLUMN IF NOT EXISTS vendedora_reserva VARCHAR(255);

ALTER TABLE vehiculos
    DROP CONSTRAINT IF EXISTS vehiculos_estado_reserva_check;

ALTER TABLE vehiculos
    ADD CONSTRAINT vehiculos_estado_reserva_check
    CHECK (estado_reserva IN ('Disponible', 'Reservado'));
