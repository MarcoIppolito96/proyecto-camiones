import json
from fastapi import FastAPI
from models import *
import requests

app = FastAPI()

usuarios = []  # Lista para almacenar los usuarios

# Datos del nuevo usuario a crear
def crear_usuario():
    nuevo_usuario = Usuario("Markito96","marcoippolito96@email.com", "markito21nob", "Administrador")
    nuevo_usuario_json = json.dumps(nuevo_usuario)

    # URL de la API
    url = "http://http://127.0.0.1/:8000/crear_usuario/"  # Reemplaza con la dirección y puerto correctos

    # Realizar la solicitud POST para crear un nuevo usuario
    response = requests.post(url, json=json.dumps(nuevo_usuario_json))

    # Verificar la respuesta
    if response.status_code == 200:
        print("Usuario creado exitosamente")
        print("Detalles del usuario creado:", response.json())
    else:
        print("Error al crear el usuario:", response.text)


@app.get("/")
def obtener_usuarios():
    if not usuarios:
        return {"mensaje": "No hay usuarios registrados aún."}
    usuarios_registrados = []
    for usuario in usuarios:
        usuarios_registrados.append({
            "nombre": usuario.nombre,
            "email": usuario.email,
            "contraseña": usuario.contraseña,
            "privilegio": usuario.privilegio
        })
    return {"Usuarios": usuarios_registrados}

@app.post("/crear_usuario/")
def crear_usuario(usuario: Usuario):
    nuevo_usuario = Usuario(
        nombre=usuario.nombre,
        email=usuario.email,
        contraseña=usuario.contraseña,
        privilegio=usuario.privilegio
    )
    usuarios.append(nuevo_usuario)
    return {"mensaje": "Usuario creado exitosamente", "detalles_usuario": nuevo_usuario.dict()}
