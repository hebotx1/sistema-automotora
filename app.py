"""Punto de entrada de la app. Solo monta las pestañas; la lógica vive en ui/*.py."""
import logging

import streamlit as st

from ui import buscar, clientes, contratos, vehiculos

logging.basicConfig(level=logging.INFO)

st.set_page_config(
    page_title="San Martín Automotriz",
    page_icon="🚗",
    layout="wide",
)

st.title("🚗 Sistema San Martín Automotriz")

tab1, tab2, tab3, tab4 = st.tabs([
    "📝 Generar Contrato",
    "👤 Clientes",
    "🚘 Vehículos",
    "🔍 Buscar",
])

with tab1:
    contratos.render()

with tab2:
    clientes.render()

with tab3:
    vehiculos.render()

with tab4:
    buscar.render()
