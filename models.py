from pydantic import BaseModel
from datetime import date

class Chofer(BaseModel):
    dni: str
    nombre: str
    apellido: str
    direccion: str
    telefono_fijo: str
    telefono_celular: str
    edad: int
    email: str
    registro_automotor: str

class Cliente(BaseModel):
    nombre: str
    apellido: str
    razonsocial: str
    dni: str
    cuit: str
    direccion: str
    telefono: str
    email: str

class Camion(BaseModel):
    patente: str
    marca: str
    modelo: str
    año: int
    tipo_remolque: int

class Viajes(BaseModel):
    ciudad_destino: int
    ciudad_origen: int
    kilometros: int
    cod_cliente: int
    camion: str
    chofer: str
    fecha_salida_estimada: date
    fecha_llegada_estimada: date
    fecha_salida_real: date
    fecha_salida_estimada: date

class Remolques(BaseModel):
    nombre: str

class Producto(BaseModel):
    codigo: str
    descripcion: str
    importeUnitario: float

class Factura(BaseModel):
    numero: int
    fecha: date
    productos: list[Producto]
    subtotal: float
    valorIva: float
    total: float

