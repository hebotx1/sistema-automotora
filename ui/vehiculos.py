"""Pestaña: Registrar / Modificar Vehículos."""
import logging

import streamlit as st
from psycopg2 import errors as pg_errors

from db import fetch_one_as_dict, get_cursor
from validators import limpiar_patente

logger = logging.getLogger(__name__)


def render():
    accion = st.radio(
        "¿Qué deseas hacer?",
        ["➕ Registrar nuevo vehículo", "✏️ Modificar vehículo existente"],
        horizontal=True,
        key="accion_veh",
    )

    if accion == "➕ Registrar nuevo vehículo":
        _render_crear()
    else:
        _render_modificar()


def _render_crear():
    st.subheader("Registrar Nuevo Vehículo")

    estado_reserva_v = st.radio(
        "Estado del Vehículo",
        ["Disponible", "Reservado"],
        horizontal=True,
        key="estado_reserva_nuevo",
    )

    with st.form("form_nuevo_vehiculo", clear_on_submit=True):
        st.markdown("**Datos del Vehículo**")
        v1, v2 = st.columns(2)
        with v1:
            patente_v = st.text_input("Patente *")
            marca_v = st.text_input("Marca")
            modelo_v = st.text_input("Modelo")
            anio_v = st.number_input("Año", min_value=1900, max_value=2100, step=1, value=2020)
            km_v = st.number_input("Kilometraje", min_value=0, step=1000)
        with v2:
            chasis_v = st.text_input("Nro de Chasis")
            motor_v = st.text_input("Nro de Motor")
            puertas_v = st.number_input("Nro de Puertas", min_value=0, max_value=10, step=1, value=4)
            color_v = st.text_input("Color")

        st.markdown("**Ubicación y Observaciones**")
        u1, u2 = st.columns(2)
        with u1:
            ubicacion_v = st.text_input("Ubicación")
        with u2:
            observaciones_v = st.text_area("Observaciones", height=100)

        if estado_reserva_v == "Reservado":
            st.markdown("**Datos de la Reserva**")
            r1, r2, r3 = st.columns(3)
            with r1:
                dias_reserva_v = st.number_input("Días de Reserva", min_value=0, step=1)
            with r2:
                monto_reserva_v = st.number_input("Monto de la Reserva", min_value=0, step=1000)
            with r3:
                vendedora_v = st.text_input("Vendedora que atendió")
        else:
            dias_reserva_v = None
            monto_reserva_v = None
            vendedora_v = ""

        st.markdown("**Datos del Cliente (quien trae el vehículo)**")
        d1, d2 = st.columns(2)
        with d1:
            rut_cli_v = st.text_input("RUT Cliente *")
        with d2:
            st.markdown("_El nombre se consulta automáticamente desde la BD_")

        st.markdown("**Datos del Dueño del Vehículo** _(si es distinto al cliente)_")
        e1, e2 = st.columns(2)
        with e1:
            nombre_dueno_v = st.text_input("Nombre Dueño Vehículo")
            rut_dueno_v = st.text_input("RUT Dueño Vehículo")
            dir_dueno_v = st.text_input("Dirección Dueño Vehículo")
        with e2:
            tel_dueno_v = st.text_input("Teléfono Dueño Vehículo")
            email_dueno_v = st.text_input("E-Mail Dueño Vehículo")

        guardar_veh = st.form_submit_button("💾 Guardar Vehículo")

    if not guardar_veh:
        return

    if not patente_v or not rut_cli_v:
        st.error("⚠️ La Patente y el RUT del cliente son obligatorios.")
        return

    patente_limpia = limpiar_patente(patente_v)

    try:
        with get_cursor() as cur:
            cur.execute("SELECT razon_social FROM clientes WHERE rut=%s", (rut_cli_v.strip(),))
            cli = cur.fetchone()
            if not cli:
                st.error(f"❌ No existe un cliente con RUT {rut_cli_v}. Regístralo primero.")
                return

            cur.execute(
                """
                INSERT INTO vehiculos (
                    patente, marca, modelo, año, kilometraje,
                    nro_chasis, nro_motor, nro_puertas, color,
                    ubicacion, observaciones,
                    estado_reserva, dias_reserva, monto_reserva, vendedora_reserva,
                    rut_cliente,
                    nombre_dueno_vehiculo, rut_dueno_vehiculo,
                    direccion_dueno_vehiculo, telefono_dueno_vehiculo, email_dueno_vehiculo
                ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
                """,
                (
                    patente_limpia, marca_v.upper() or None, modelo_v.upper() or None,
                    anio_v, km_v,
                    chasis_v or None, motor_v or None, puertas_v, color_v.upper() or None,
                    ubicacion_v or None, observaciones_v or None,
                    estado_reserva_v, dias_reserva_v, monto_reserva_v, vendedora_v or None,
                    rut_cli_v.strip(),
                    nombre_dueno_v.upper() or None, rut_dueno_v or None,
                    dir_dueno_v or None, tel_dueno_v or None, email_dueno_v or None,
                ),
            )
        st.success(f"✅ Vehículo **{patente_limpia}** registrado. Cliente: {cli[0]}")
    except pg_errors.UniqueViolation:
        st.error("❌ Esa patente ya está registrada.")
    except Exception:
        logger.exception("Error al registrar vehículo")
        st.error("❌ Ocurrió un error al registrar el vehículo.")


def _render_modificar():
    st.subheader("Modificar Vehículo Existente")
    pat_mod = st.text_input("Ingresa la Patente a buscar:", key="pat_modificar")

    if st.button("🔎 Buscar Vehículo"):
        if not pat_mod.strip():
            st.warning("Ingresa una patente.")
        else:
            try:
                with get_cursor() as cur:
                    fila = fetch_one_as_dict(
                        cur, "SELECT * FROM vehiculos WHERE patente = %s", (limpiar_patente(pat_mod),)
                    )
                if fila:
                    st.session_state["vehiculo_mod"] = fila
                    st.success("Vehículo encontrado.")
                else:
                    st.error("No se encontró ningún vehículo con esa patente.")
            except Exception:
                logger.exception("Error al buscar vehículo")
                st.error("Ocurrió un error al buscar el vehículo.")

    if "vehiculo_mod" not in st.session_state:
        return

    v = st.session_state["vehiculo_mod"]

    estado_reserva_m = st.radio(
        "Estado del Vehículo",
        ["Disponible", "Reservado"],
        horizontal=True,
        index=0 if (v.get("estado_reserva") or "Disponible") == "Disponible" else 1,
        key=f"estado_reserva_mod_{v['patente']}",
    )

    with st.form("form_mod_vehiculo"):
        mv1, mv2 = st.columns(2)
        with mv1:
            marca_m = st.text_input("Marca", value=v.get("marca", "") or "")
            modelo_m = st.text_input("Modelo", value=v.get("modelo", "") or "")
            anio_m = st.number_input("Año", value=int(v.get("año") or 2020), min_value=1900, max_value=2100)
            km_m = st.number_input("Kilometraje", value=int(v.get("kilometraje") or 0), min_value=0)
        with mv2:
            chasis_m = st.text_input("Nro Chasis", value=v.get("nro_chasis", "") or "")
            motor_m = st.text_input("Nro Motor", value=v.get("nro_motor", "") or "")
            puertas_m = st.number_input("Puertas", value=int(v.get("nro_puertas") or 4), min_value=0, max_value=10)
            color_m = st.text_input("Color", value=v.get("color", "") or "")

        st.markdown("**Ubicación y Observaciones**")
        u1, u2 = st.columns(2)
        with u1:
            ubicacion_m = st.text_input("Ubicación", value=v.get("ubicacion", "") or "")
        with u2:
            observaciones_m = st.text_area("Observaciones", value=v.get("observaciones", "") or "", height=100)

        if estado_reserva_m == "Reservado":
            st.markdown("**Datos de la Reserva**")
            r1, r2, r3 = st.columns(3)
            with r1:
                dias_reserva_m = st.number_input(
                    "Días de Reserva", value=int(v.get("dias_reserva") or 0), min_value=0, step=1
                )
            with r2:
                monto_reserva_m = st.number_input(
                    "Monto de la Reserva", value=int(v.get("monto_reserva") or 0), min_value=0, step=1000
                )
            with r3:
                vendedora_m = st.text_input("Vendedora que atendió", value=v.get("vendedora_reserva", "") or "")
        else:
            dias_reserva_m = None
            monto_reserva_m = None
            vendedora_m = ""

        nombre_d_m = st.text_input("Nombre Dueño", value=v.get("nombre_dueno_vehiculo", "") or "")
        rut_d_m = st.text_input("RUT Dueño", value=v.get("rut_dueno_vehiculo", "") or "")
        dir_d_m = st.text_input("Dirección Dueño", value=v.get("direccion_dueno_vehiculo", "") or "")
        tel_d_m = st.text_input("Teléfono Dueño", value=v.get("telefono_dueno_vehiculo", "") or "")
        email_d_m = st.text_input("E-Mail Dueño", value=v.get("email_dueno_vehiculo", "") or "")

        actualizar_v = st.form_submit_button("💾 Actualizar Vehículo")

    if not actualizar_v:
        return

    try:
        with get_cursor() as cur:
            cur.execute(
                """
                UPDATE vehiculos SET
                    marca=%s, modelo=%s, año=%s, kilometraje=%s,
                    nro_chasis=%s, nro_motor=%s, nro_puertas=%s, color=%s,
                    ubicacion=%s, observaciones=%s,
                    estado_reserva=%s, dias_reserva=%s, monto_reserva=%s, vendedora_reserva=%s,
                    nombre_dueno_vehiculo=%s, rut_dueno_vehiculo=%s,
                    direccion_dueno_vehiculo=%s, telefono_dueno_vehiculo=%s,
                    email_dueno_vehiculo=%s
                WHERE patente=%s
                """,
                (
                    marca_m.upper() or None, modelo_m.upper() or None, anio_m, km_m,
                    chasis_m or None, motor_m or None, puertas_m, color_m.upper() or None,
                    ubicacion_m or None, observaciones_m or None,
                    estado_reserva_m, dias_reserva_m, monto_reserva_m, vendedora_m or None,
                    nombre_d_m.upper() or None, rut_d_m or None,
                    dir_d_m or None, tel_d_m or None, email_d_m or None,
                    v["patente"],
                ),
            )
        st.success("✅ Vehículo actualizado correctamente.")
        del st.session_state["vehiculo_mod"]
    except Exception:
        logger.exception("Error al actualizar vehículo")
        st.error("❌ Ocurrió un error al actualizar el vehículo.")
