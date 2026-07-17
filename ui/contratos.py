"""Pestaña: Generar / Modificar Contratos de Compraventa."""
import logging

import streamlit as st
from psycopg2 import errors as pg_errors

from db import fetch_one_as_dict, get_cursor
from word_generator import PLANTILLA_COMPRAVENTA, generar_docx_desde_plantilla

logger = logging.getLogger(__name__)

CAMPOS_CONTRATO = [
    # (clave_form, columna_bd, etiqueta, placeholder)
    ("fecha", "fecha_contrato", "Fecha del Contrato", "Ej: 19.05.2026"),
    ("nombre", "nombre_comprador", "Nombre del Comprador *", "Ej: EDUARDO PALMA"),
    ("rut", "rut_comprador", "RUT del Comprador", "Ej: 16328681-5"),
    ("nacionalidad", "nacionalidad", "Nacionalidad", "Ej: chilena"),
    ("direccion", "direccion", "Dirección", "Ej: SECTOR HUILLINCO S/N"),
    ("comuna", "comuna", "Comuna/Ciudad", "Ej: COMUNA CHONCHI, CHILOE"),
    ("precio_num", "precio_numeros", "Precio en Números", "Ej: $10.990.000.-"),
    ("precio_pal", "precio_palabras", "Precio en Palabras", "Ej: DIEZ MILLONES NOVECIENTOS NOVENTA MIL"),
    ("gastos", "gastos_notariales", "Gastos Notariales", None),
    ("marca", "marca", "Marca", "Ej: NISSAN"),
    ("modelo", "modelo", "Modelo", "Ej: TERRANO 2.5 4X4 CABINA SIMPLE"),
    ("anio", "anio", "Año", "Ej: 2011"),
    ("motor", "motor", "N° Motor", "Ej: YD25257334T"),
    ("chasis", "chasis", "N° Chasis / VIN", "Ej: 3N63N6PD21Y2ZK878230"),
    ("color", "color", "Color", "Ej: ROJO"),
    ("patente", "patente", "Patente", "Ej: CXLJ.20-8"),
]

MARCADOR_POR_COLUMNA = {
    "fecha_contrato": "[FECHA_CONTRATO]",
    "nombre_comprador": "[NOMBRE_COMPRADOR]",
    "rut_comprador": "[RUT_COMPRADOR]",
    "nacionalidad": "[NACIONALIDAD]",
    "direccion": "[DIRECCION]",
    "comuna": "[COMUNA]",
    "precio_numeros": "[PRECIO_NUMEROS]",
    "precio_palabras": "[PRECIO_PALABRAS]",
    "gastos_notariales": "[GASTOS_NOTARIALES]",
    "marca": "[MARCA]",
    "modelo": "[MODELO]",
    "anio": "[AÑO]",
    "motor": "[MOTOR]",
    "chasis": "[CHASIS]",
    "color": "[COLOR]",
    "patente": "[PATENTE]",
}


def _generar_reemplazos(numero_contrato, valores_por_columna):
    reemplazos = {"[NÚMERO_CONTRATO]": numero_contrato}
    for columna, marcador in MARCADOR_POR_COLUMNA.items():
        reemplazos[marcador] = valores_por_columna.get(columna, "")
    return reemplazos


def _formulario_campos(valores_iniciales, columnas):
    """Dibuja los inputs en dos columnas y devuelve dict columna -> valor."""
    resultado = {}
    mitad = len(CAMPOS_CONTRATO) // 2
    for i, (clave, columna, etiqueta, placeholder) in enumerate(CAMPOS_CONTRATO):
        col = columnas[0] if i < mitad else columnas[1]
        with col:
            kwargs = {"value": valores_iniciales.get(columna, "")} if valores_iniciales else {}
            if placeholder and not valores_iniciales:
                kwargs["placeholder"] = placeholder
            resultado[columna] = st.text_input(etiqueta, key=f"contrato_{columna}_{id(valores_iniciales)}", **kwargs)
    return resultado


def _guardar_contrato_nuevo(numero_contrato, valores):
    columnas_sql = ["numero_contrato"] + list(valores.keys())
    placeholders = ", ".join(["%s"] * len(columnas_sql))
    with get_cursor() as cur:
        cur.execute(
            f"INSERT INTO contratos ({', '.join(columnas_sql)}) VALUES ({placeholders})",
            [numero_contrato] + list(valores.values()),
        )


def _actualizar_contrato(numero_contrato, valores):
    set_clause = ", ".join(f"{col}=%s" for col in valores)
    with get_cursor() as cur:
        cur.execute(
            f"UPDATE contratos SET {set_clause} WHERE numero_contrato=%s",
            list(valores.values()) + [numero_contrato],
        )


def render():
    accion = st.radio(
        "¿Qué deseas hacer?",
        ["➕ Crear y guardar nuevo contrato", "✏️ Modificar / Reimprimir contrato existente"],
        horizontal=True,
        key="accion_contrato",
    )

    if accion == "➕ Crear y guardar nuevo contrato":
        _render_crear()
    else:
        _render_modificar()


def _render_crear():
    st.subheader("Crear Nuevo Contrato de Compraventa")

    with st.form("form_nuevo_contrato", clear_on_submit=False):
        numero_contrato_val = st.text_input("Número de Contrato *", placeholder="Ej: 1539")
        col1, col2 = st.columns(2)
        valores = _formulario_campos(None, (col1, col2))
        generar = st.form_submit_button("💾 Guardar y Generar Contrato")

    if not generar:
        return

    if not numero_contrato_val or not valores["nombre_comprador"]:
        st.error("⚠️ El Número de Contrato y el Nombre son obligatorios.")
        return

    try:
        _guardar_contrato_nuevo(numero_contrato_val, valores)
        reemplazos = _generar_reemplazos(numero_contrato_val, valores)
        buffer = generar_docx_desde_plantilla(PLANTILLA_COMPRAVENTA, reemplazos)

        st.success(f"✅ ¡Contrato N°{numero_contrato_val} guardado y generado con éxito!")
        st.download_button(
            "📥 Descargar Documento",
            data=buffer,
            file_name=f"Contrato_{numero_contrato_val}_{valores['nombre_comprador']}.docx",
            mime="application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        )
    except pg_errors.UniqueViolation:
        st.error("❌ Ese Número de Contrato ya existe. Ve a la opción 'Modificar' si deseas reescribirlo.")
    except FileNotFoundError:
        st.error("❌ No se encontró la plantilla Plantilla_Compraventa.docx en la carpeta Plantillas/.")
    except Exception:
        logger.exception("Error al generar contrato nuevo")
        st.error("❌ Ocurrió un error al guardar/generar el contrato. Revisa el registro de errores.")


def _render_modificar():
    st.subheader("Modificar Contrato Existente")
    nro_mod = st.text_input("Ingresa el Número de Contrato a buscar (Ej: 1539):", key="nro_modificar")

    if st.button("🔎 Buscar Contrato"):
        if not nro_mod.strip():
            st.warning("Ingresa un número de contrato.")
        else:
            try:
                with get_cursor() as cur:
                    fila = fetch_one_as_dict(cur, "SELECT * FROM contratos WHERE numero_contrato = %s", (nro_mod.strip(),))
                if fila:
                    st.session_state["contrato_mod"] = fila
                    st.success("✅ Contrato encontrado. Edita los campos abajo y vuelve a generar.")
                else:
                    st.error("❌ No se encontró ningún contrato con ese número.")
            except Exception:
                logger.exception("Error al buscar contrato")
                st.error("❌ Ocurrió un error al buscar el contrato.")

    if "contrato_mod" not in st.session_state:
        return

    c = st.session_state["contrato_mod"]
    with st.form("form_mod_contrato"):
        col1, col2 = st.columns(2)
        valores = _formulario_campos(c, (col1, col2))
        actualizar_y_generar = st.form_submit_button("💾 Actualizar y Reimprimir Word")

    if not actualizar_y_generar:
        return

    try:
        _actualizar_contrato(c["numero_contrato"], valores)
        reemplazos = _generar_reemplazos(c["numero_contrato"], valores)
        buffer = generar_docx_desde_plantilla(PLANTILLA_COMPRAVENTA, reemplazos)

        st.success("✅ ¡Base de datos actualizada y contrato reimpreso!")
        st.download_button(
            "📥 Descargar Documento Actualizado",
            data=buffer,
            file_name=f"Contrato_{c['numero_contrato']}_Modificado.docx",
            mime="application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        )
        del st.session_state["contrato_mod"]
    except FileNotFoundError:
        st.error("❌ No se encontró la plantilla Plantilla_Compraventa.docx en la carpeta Plantillas/.")
    except Exception:
        logger.exception("Error al actualizar contrato")
        st.error("❌ Ocurrió un error al actualizar el contrato.")
