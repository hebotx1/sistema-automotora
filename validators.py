"""Validaciones simples reutilizadas en los formularios."""
import re


def limpiar_rut(rut: str) -> str:
    return re.sub(r"[.\-\s]", "", rut or "").upper()


def rut_valido(rut: str) -> bool:
    """Valida el dígito verificador de un RUT chileno (formato 12345678K, sin puntos/guion)."""
    rut = limpiar_rut(rut)
    if not rut or len(rut) < 2 or not rut[:-1].isdigit():
        return False
    cuerpo, dv = rut[:-1], rut[-1]
    suma, multiplo = 0, 2
    for c in reversed(cuerpo):
        suma += int(c) * multiplo
        multiplo = 2 if multiplo == 7 else multiplo + 1
    resto = 11 - (suma % 11)
    dv_esperado = {10: "K", 11: "0"}.get(resto, str(resto))
    return dv == dv_esperado


def limpiar_patente(patente: str) -> str:
    return re.sub(r"[.\-\s]", "", patente or "").upper()


def email_valido(email: str) -> bool:
    if not email:
        return True  # campo opcional
    return re.match(r"^[^@\s]+@[^@\s]+\.[^@\s]+$", email) is not None
