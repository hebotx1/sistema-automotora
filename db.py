"""Capa de acceso a la base de datos."""
import logging
from contextlib import contextmanager

import psycopg2
import streamlit as st

logger = logging.getLogger(__name__)


def conectar_bd():
    cfg = st.secrets["db"]
    return psycopg2.connect(
        dbname=cfg["dbname"],
        user=cfg["user"],
        password=cfg["password"],
        host=cfg["host"],
        port=cfg.get("port", 5432),
    )


@contextmanager
def get_cursor():
    """Context manager: abre conexión, da un cursor, hace commit/rollback y cierra todo."""
    con = conectar_bd()
    try:
        cur = con.cursor()
        yield cur
        con.commit()
    except Exception:
        con.rollback()
        raise
    finally:
        con.close()


def fetch_one_as_dict(cur, query, params):
    cur.execute(query, params)
    cols = [d[0] for d in cur.description]
    fila = cur.fetchone()
    return dict(zip(cols, fila)) if fila else None
