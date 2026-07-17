"""Pestaña: Buscar y Listar Registros."""
import logging

import pandas as pd
import streamlit as st

from db import get_cursor

logger = logging.getLogger(__name__)


def render():
    st.subheader("Buscar y Listar Registros")
    tipo_busqueda = st.selectbox("¿Qué deseas buscar?", ["Clientes", "Vehículos"])
    texto_buscar = st.text_input("Buscar por RUT, nombre o patente:")

    if not st.button("🔎 Buscar"):
        return

    try:
        with get_cursor() as cur:
            if tipo_busqueda == "Clientes":
                cur.execute(
                    """
                    SELECT rut, razon_social, giro, telefono, email, ciudad, vendedor, saldo_financiero
                    FROM clientes
                    WHERE rut ILIKE %s OR razon_social ILIKE %s
                    ORDER BY razon_social
                    LIMIT 50
                    """,
                    (f"%{texto_buscar}%", f"%{texto_buscar}%"),
                )
                cols = ["RUT", "Razón Social", "Giro", "Teléfono", "E-Mail", "Ciudad", "Vendedor", "Saldo"]
            else:
                cur.execute(
                    """
                    SELECT v.patente, v.marca, v.modelo, v.año, v.kilometraje, v.color,
                           v.ubicacion, v.estado_reserva, v.dias_reserva, v.monto_reserva,
                           v.vendedora_reserva, v.observaciones,
                           v.rut_cliente, c.razon_social
                    FROM vehiculos v
                    LEFT JOIN clientes c ON c.rut = v.rut_cliente
                    WHERE v.patente ILIKE %s OR v.marca ILIKE %s OR v.rut_cliente ILIKE %s
                    ORDER BY v.patente
                    LIMIT 50
                    """,
                    (f"%{texto_buscar}%", f"%{texto_buscar}%", f"%{texto_buscar}%"),
                )
                cols = [
                    "Patente", "Marca", "Modelo", "Año", "KM", "Color",
                    "Ubicación", "Estado", "Días Reserva", "Monto Reserva",
                    "Vendedora", "Observaciones",
                    "RUT Cliente", "Cliente",
                ]

            filas = cur.fetchall()

        if filas:
            df = pd.DataFrame(filas, columns=cols)
            st.dataframe(df, use_container_width=True)
            st.caption(f"{len(filas)} resultado(s) encontrado(s).")
        else:
            st.info("No se encontraron resultados.")
    except Exception:
        logger.exception("Error al buscar registros")
        st.error("❌ Ocurrió un error al realizar la búsqueda.")
