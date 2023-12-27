from pydantic import BaseModel

class Usuario():

    def __init__(self, nombre, email, contraseña, privilegio):
        self.nombre = nombre
        self.email = email
        self.contraseña = contraseña
        self.privilegio = privilegio