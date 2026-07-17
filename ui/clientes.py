"""Pestaña: Registrar / Modificar Clientes."""
import logging

import streamlit as st
from psycopg2 import errors as pg_errors

from db import fetch_one_as_dict, get_cursor
from validators import email_valido, rut_valido

logger = logging.getLogger(__name__)


def render():
    accion = st.radio(
        "¿Qué deseas hacer?",
        ["➕ Registrar nuevo cliente", "✏️ Modificar cliente existente"],
        horizontal=True,
        key="accion_cliente",
    )

    if accion == "➕ Registrar nuevo cliente":
        _render_crear()
    else:
        _render_modificar()


def _render_crear():
    st.subheader("Registrar Nuevo Cliente")

    with st.form("form_nuevo_cliente", clear_on_submit=True):
        st.markdown("**Datos obligatorios**")
        c1, c2 = st.columns(2)
        with c1:
            rut_n = st.text_input("RUT *")
            razon_n = st.text_input("Razón Social *")
            fantasia_n = st.text_input("Nombre Fantasía")
            giro_n = st.text_input("Giro")
            direccion_n = st.text_input("Dirección")
            comuna_n = st.text_input("Comuna")
        with c2:
            ciudad_n = st.text_input("Ciudad")
            telefono_n = st.text_input("Teléfono")
            telefono2_n = st.text_input("Teléfono 2")
            email_n = st.text_input("E-Mail")
            web_n = st.text_input("Web")
            contacto_n = st.text_input("Contacto Comercial")

        st.markdown("**Datos comerciales**")
        c3, c4 = st.columns(2)
        with c3:
            forma_pago_n = st.selectbox("Forma de Pago", ["CONTADO", "CRÉDITO 30 DÍAS", "CRÉDITO 60 DÍAS"])
        with c4:
            observaciones_n = st.text_area("Observaciones")

        guardar_cliente = st.form_submit_button("💾 Guardar Cliente")

    if not guardar_cliente:
        return

    if not rut_n or not razon_n:
        st.error("⚠️ El RUT y la Razón Social son obligatorios.")
        return
    if not rut_valido(rut_n):
        st.error("⚠️ El RUT ingresado no es válido.")
        return
    if not email_valido(email_n):
        st.error("⚠️ El E-Mail ingresado no es válido.")
        return

    try:
        with get_cursor() as cur:
            cur.execute(
                """
                INSERT INTO clientes (
                    rut, razon_social, nombre_fantasia, giro,
                    direccion, comuna, ciudad,
                    telefono, telefono2, email, web, contacto_comercial,
                    forma_pago, observaciones
                ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
                """,
                (
                    rut_n.strip(), razon_n.upper(), fantasia_n.upper() or None, giro_n.upper() or None,
                    direccion_n or None, comuna_n.upper() or None, ciudad_n.upper() or None,
                    telefono_n or None, telefono2_n or None, email_n or None, web_n or None, contacto_n or None,
                    forma_pago_n, observaciones_n or None,
                ),
            )
        st.success(f"✅ Cliente **{razon_n.upper()}** registrado correctamente.")
    except pg_errors.UniqueViolation:
        st.error("❌ Ese RUT ya existe en el sistema.")
    except Exception:
        logger.exception("Error al registrar cliente")
        st.error("❌ Ocurrió un error al registrar el cliente.")


def _render_modificar():
    st.subheader("Modificar Cliente Existente")
    rut_mod = st.text_input("Ingresa el RUT a buscar:", key="rut_modificar")

    if st.button("🔎 Buscar Cliente"):
        if not rut_mod.strip():
            st.warning("Ingresa un RUT para buscar.")
        else:
            try:
                with get_cursor() as cur:
                    fila = fetch_one_as_dict(cur, "SELECT * FROM clientes WHERE rut = %s", (rut_mod.strip(),))
                if fila:
                    st.session_state["cliente_mod"] = fila
                    st.success("Cliente encontrado. Edita los campos y guarda.")
                else:
                    st.error("No se encontró ningún cliente con ese RUT.")
            except Exception:
                logger.exception("Error al buscar cliente")
                st.error("Ocurrió un error al buscar el cliente.")

    if "cliente_mod" not in st.session_state:
        return

    c = st.session_state["cliente_mod"]
    with st.form("form_mod_cliente"):
        c1, c2 = st.columns(2)
        with c1:
            razon_m = st.text_input("Razón Social *", value=c.get("razon_social", ""))
            fantasia_m = st.text_input("Nombre Fantasía", value=c.get("nombre_fantasia", "") or "")
            giro_m = st.text_input("Giro", value=c.get("giro", "") or "")
            dir_m = st.text_input("Dirección", value=c.get("direccion", "") or "")
            comuna_m = st.text_input("Comuna", value=c.get("comuna", "") or "")
        with c2:
            ciudad_m = st.text_input("Ciudad", value=c.get("ciudad", "") or "")
            tel_m = st.text_input("Teléfono", value=c.get("telefono", "") or "")
            tel2_m = st.text_input("Teléfono 2", value=c.get("telefono2", "") or "")
            email_m = st.text_input("E-Mail", value=c.get("email", "") or "")
            obs_m = st.text_area("Observaciones", value=c.get("observaciones", "") or "")

        actualizar = st.form_submit_button("💾 Actualizar Cliente")

    if not actualizar:
        return

    if not email_valido(email_m):
        st.error("⚠️ El E-Mail ingresado no es válido.")
        return

    try:
        with get_cursor() as cur:
            cur.execute(
                """
                UPDATE clientes SET
                    razon_social=%s, nombre_fantasia=%s, giro=%s,
                    direccion=%s, comuna=%s, ciudad=%s,
                    telefono=%s, telefono2=%s, email=%s, observaciones=%s
                WHERE rut=%s
                """,
                (
                    razon_m.upper(), fantasia_m.upper() or None, giro_m.upper() or None,
                    dir_m or None, comuna_m.upper() or None, ciudad_m.upper() or None,
                    tel_m or None, tel2_m or None, email_m or None, obs_m or None,
                    c["rut"],
                ),
            )
        st.success("✅ Cliente actualizado correctamente.")
        del st.session_state["cliente_mod"]
    except Exception:
        logger.exception("Error al actualizar cliente")
        st.error("❌ Ocurrió un error al actualizar el cliente.")
