from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse, JSONResponse, RedirectResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
import psycopg2
from models import *
from fastapi.templating import Jinja2Templates
from fastapi import Request
from pydantic.error_wrappers import ValidationError
import os

templates = Jinja2Templates(directory="templates")

######## CONEXIONES #########
app = FastAPI()

# EXTERNO 

try:
    connection_params = {
        'user': 'camionesonline_user',
        'password':  'GdiALbTeSjFSvUGzLShc0YGgQmjFzGaS',
        'host': 'dpg-cnj5vcf79t8c73cq1mpg-a.oregon-postgres.render.com',  
        'port': '5432',  
        'database': 'camionesonline2'
    }
    conn = psycopg2.connect(**connection_params)
    cursor = conn.cursor()
    print("Conexion exitosa")
except Exception as e:
    print(f"Error al conectaaar: {str(e)}")

#conn = psycopg2.connect(**connection_params)

# INTERNO
"""
try:
    connection_params = {
        'user': 'postgres',
        'password':  'markito21',
        'host': 'localhost',  
        'port': '5432',  
        'database': 'camionesLocal'
    }
    conn = psycopg2.connect(**connection_params)
    cursor = conn.cursor()
    print("Conexion exitosa")
except Exception as e:
    print(f"Error al conectaaar: {str(e)}")"""

#########

app.mount("/templates", StaticFiles(directory="templates"), name="templates")

## RUTAS ##

# Ruta para la página de inicio de sesión
@app.get("/")
def inicio(request: Request):
    return templates.TemplateResponse("login.html", {"request": request})

# Ruta para manejar el inicio de sesión
@app.post("/")
def login(usuario: Usuario):
    try:
        with conn.cursor() as cursor:
            print(f"Usuario: {usuario}")
            query = f"""SELECT * FROM usuarios WHERE usuarios.nombre = '{usuario.nombre}'"""
            cursor.execute(query)
            usuarioDB = cursor.fetchone()
            print(usuarioDB)
            if usuarioDB:
                if usuarioDB[4]:
                    if usuario.contrasena == usuarioDB[3]:
                        return JSONResponse(content={"redirect_url": f"/inicio?usuario={usuario.nombre}"})
                    else:
                        with conn.cursor() as cursor:
                            id = usuarioDB[0]
                            query1 = f""" UPDATE usuarios
                                        SET intentos = intentos + 1
                                        WHERE id = '{id}';"""
                            cursor.execute(query1)
                            conn.commit()
                            query2 = f"""SELECT intentos FROM usuarios WHERE usuarios.nombre = '{usuario.nombre}'"""
                            cursor.execute(query2)
                            usuario = cursor.fetchone()
                            intentosUsuario = usuario[0]
                            if intentosUsuario == 1:
                                return JSONResponse(content={"mensaje": f"Le quedan 2 intentos"})
                            elif intentosUsuario == 2:
                                return JSONResponse(content={"mensaje": f"Le queda 1 intento"})
                            elif intentosUsuario >= 3:
                                query4 = f""" UPDATE usuarios
                                        SET activo = False
                                        WHERE id = '{id}';"""
                                cursor.execute(query4)
                                conn.commit() 
                            return JSONResponse(content={"mensaje": f"Se ha bloqueado al usuario por superar la cantidad de intentos."})
                else:
                    return JSONResponse(content={"mensaje": "El usuario esta bloqueado, comuniquese con el administrador para desbloquearlo."})
            else:
                print("Che es none, no se encontró el usuario")
                return JSONResponse(content={"mensaje": "No se encontró el usuario"})
    except Exception as e:
        print(f"Error: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")
    
@app.get("/inicio")
def inicio(request: Request):
    nombre_usuario = request.query_params.get('usuario', '')
    return templates.TemplateResponse("inicio.html", {"request": request, "nombre_usuario": nombre_usuario})

@app.get("/camiones")
def obtener_camiones(request: Request):
    query = """
    SELECT camiones.patente as Patente, camiones.marca as Marca, camiones.modelo AS Modelo, camiones.aÑo as Año, remolques.descripcion as TipoRemolque
    FROM camiones
    JOIN remolques ON camiones.tipo_remolque = remolques.id
    WHERE camiones.ACTIVO IS NULL or camiones.ACTIVO = True"""
    try:
        with conn.cursor() as cursor:
            cursor.execute(query)
            camiones = cursor.fetchall()
            return templates.TemplateResponse("camiones.html", {"request": request, "camiones": camiones})
    except Exception as e:
        print(f"Error al obtener datos de la base de datos: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")
    
@app.post("/camiones/{patente}")
def eliminarCamion(patente):
    try:
        with conn.cursor() as cursor:
            query = f"SELECT patente from camiones WHERE patente = '{patente}'"
            cursor.execute(query)
            result = cursor.fetchone()
            print(result[0])
            if result[0] is not None:
                query = f"""UPDATE camiones
                        SET activo= False
	                    WHERE patente = '{result[0]}'"""
                cursor.execute(query)
                conn.commit()
                return JSONResponse(content={"mensaje": f"Camion con patente: {result[0]} eliminado correctamente"})
    except Exception as e:
        print(f"Error al obtener datos de la base de datos: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")
    
@app.put("/camiones/{patente}")
def modificar_camion(patente: str, nuevo_camion: Camion, request: Request):
    try:
        with conn.cursor() as cursor:
            # Verificar si el camión existe
            query_buscar_camion = f"SELECT * FROM camiones WHERE patente = '{patente}'"
            cursor.execute(query_buscar_camion)
            camion_existente = cursor.fetchone()

            if not camion_existente:
                raise HTTPException(status_code=404, detail="Camión no encontrado")

            # Imprime los datos antes de ejecutar la consulta
            print(nuevo_camion)
            print(nuevo_camion.dict())

            # Actualizar la información del camión
            query_modificar_camion = """
                UPDATE camiones
                SET marca = %s, modelo = %s, aÑo = %s, tipo_remolque = %s
                WHERE patente = %s;
            """
            cursor.execute(query_modificar_camion, (nuevo_camion.marca, nuevo_camion.modelo, nuevo_camion.año, nuevo_camion.tipo_remolque, patente))
            conn.commit()
            return JSONResponse(content={"mensaje": "Camion modificado correctamente"})
    except Exception as e:
        print(f"Error al modificar el camión en la base de datos: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")

@app.get("/choferes")
def obtener_choferes(request: Request):
    query = """
    SELECT * FROM choferes
    WHERE choferes.ACTIVO IS NULL or choferes.ACTIVO = True
    """
    try:
        with conn.cursor() as cursor:
            cursor.execute(query)
            choferes = cursor.fetchall()
            return templates.TemplateResponse("choferes.html", {"request": request, "choferes": choferes})
    except Exception as e:
        print(f"Error al obtener datos de la base de datos: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")


@app.get("/agregar_chofer")
def agregar_chof(request: Request):
    return templates.TemplateResponse("agregarchofer.html", {"request": request})

@app.post("/agregar_chofer")
async def agregar_chofer(chofer: Chofer):
    query = """INSERT INTO public.choferes(
	            dni, nombre, apellido, direccion, telefono_fijo, telefono_celular, edad, email, registro_automotor)
	            VALUES (%(dni)s, %(nombre)s, %(apellido)s, %(direccion)s, %(telefono_fijo)s, %(telefono_celular)s,
                  %(edad)s, %(email)s, %(registro_automotor)s);"""
    try:
        with conn.cursor() as cursor:
            cursor.execute(query, chofer.dict())
            conn.commit()
        return JSONResponse(content={"mensaje": "Usuario agregado correctamente"})
    
    except Exception as e:
        print(f"Error al insertar en la base de datos: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno del servidor")
    
@app.post("/choferes/{id}")
def eliminar_chofer(id):
    try:
        with conn.cursor() as cursor:
            query = f"SELECT dni FROM choferes WHERE dni = '{id}'"
            cursor.execute(query)
            result = cursor.fetchone()
            print(result[0])
            if result[0] is not None:
                query = f"""UPDATE choferes
                        SET activo= False
	                    WHERE dni = '{id}'"""
                cursor.execute(query)
                conn.commit()
                return JSONResponse(content={"mensaje": "Eliminación exitosaxxx"})
            else:
                return JSONResponse(content={"mensaje": "No se pudo encontrar el chofer"}, status_code=404)

    except Exception as e:
        print(f"Error al eliminar elemento en la base de datos: {str(e)}")
        return JSONResponse(content={"mensaje": "Error interno del servidor"}, status_code=500)

@app.get("/agregar_camion")
def form_camion(request: Request):
    return templates.TemplateResponse("agregarcamion.html", {"request": request})

@app.post("/agregar_camion")
def agregarCamion(camion: Camion):
    try:
        with conn.cursor() as cursor:
            query = """
            INSERT INTO public.camiones(
	        patente, marca, modelo, aÑo, tipo_remolque)
	        VALUES (%(patente)s, %(marca)s, %(modelo)s, %(año)s, %(tipo_remolque)s); """
            cursor.execute(query, camion.dict())
            conn.commit()
        return JSONResponse(content={"mensaje": "Camion agregado exitosamente"})

    except Exception as e:
        print(f"Error: {str(e)}")
        return JSONResponse(content={"mensaje": "Error interno del servidor"}, status_code=500)

@app.get("/clientes")
def obtener_clientes(request: Request):
    with conn.cursor() as cursor:
        query = """SELECT * FROM clientes
                WHERE clientes.ACTIVO IS NULL or clientes.ACTIVO = True"""
        cursor.execute(query)
        clientes = cursor.fetchall()
    return templates.TemplateResponse("clientes.html", {"request": request, "clientes": clientes})

@app.get("/agregar_cliente")
def agregar_cliente(request: Request):
    return templates.TemplateResponse("agregarcliente.html",{"request" : request})

@app.post("agregar_cliente")
def agrego_cliente(cliente: Cliente):
    try:
        with conn.cursor() as cursor:
            query = """INSERT INTO clientes(
	        nombre, apellido, razon_social, dni, cuit, direccion, telefono, email, es_empresa, activo)
	        VALUES (%(nombre)s %(apellido)s %(razon_social)s %(dni)s %(cuit)s %(direccion)s %(telefono)s %(email)s);"""
            cursor.execute(query, cliente.dict)
            conn.commit()
        return JSONResponse(content={"mensaje": "Cliente agregado correctamente"})
    except Exception as e:
        print(f"Error: {str(e)}")
        return JSONResponse(content={"mensaje": "Error interno del servidor"}, status_code=500)
    
@app.post("/clientes/{codigo}")
def eliminar_cliente(codigo):
    try:
        with conn.cursor() as cursor:
            query = f"""SELECT codigo FROM clientes WHERE codigo = {(int(codigo))}"""
            cursor.execute(query)
            result = cursor.fetchone()
            print(result[0])
            if result[0] is not None:
                query = f"""UPDATE clientes
                        SET activo= False
	                    WHERE clientes.codigo = {(int(codigo))};"""
                cursor.execute(query)
                conn.commit()
                return JSONResponse(content={"mensaje": "Cliente eliminado exitosamente"})

    except Exception as e:
        print(f"Error: {str(e)}")

@app.get("/viajes")
def obtener_viajes(request: Request):
    try:
        with conn.cursor() as cursor:
            query = """SELECT viajes.codigo, CiudadDestino.Nombre as CiudadDestino , CiudadOrigen.nombre as CiudadOrigen, kilometros, clientes.nombre as NombreCliente, camion, chofer, fecha_salida_estimada, fecha_llegada_estimada, fecha_salida_real, fecha_llegada_real
	FROM public.viajes
	JOIN ciudades as CiudadOrigen ON viajes.ciudad_origen = CiudadOrigen.id
	JOIN ciudades as CiudadDestino ON viajes.ciudad_destino = CiudadDestino.id
	JOIN clientes ON viajes.cod_cliente = clientes.codigo"""
            cursor.execute(query)
            viajes = cursor.fetchall()
        return templates.TemplateResponse("viajes.html",{"request": request, "viajes": viajes})
    except Exception as e:
        print(f"Error: {str(e)}")
        return JSONResponse(content={"mensaje": "Error interno del servidor"}, status_code=500)
    
@app.get("/agregar_viaje")
def formulario_viaje(request: Request):
    return templates.TemplateResponse("agregarviaje.html", {"request": request})
    
@app.post("/agregar_viaje")
def agregar_viaje(viaje : Viajes):
    try:
        with conn.cursor() as cursor:
            query = """INSERT INTO public.viajes(
            ciudad_destino, ciudad_origen, kilometros, cod_cliente, camion, chofer, fecha_salida_estimada, fecha_llegada_estimada, fecha_salida_real, fecha_llegada_real, activo)
            VALUES (%(ciudad_destino)s, %(ciudad_origen)s, %(kilometros)s, %(cod_cliente)s,
            %(camion)s, %(chofer)s, %(fecha_salida_estimada)s, %(fecha_llegada_estimada)s, %(fecha_salida_real)s, %(fecha_salida_estimada)s); """
            cursor.execute(query, viaje.dict)
            conn.commit()
        return JSONResponse(content={"mensaje": "Viaje agregado correctamente"})
    except Exception as e:
        print(f"Error: {str(e)}")
        JSONResponse(content={"error": "Ha ocurrido un error en el servidor."}, status_code=500)

@app.get("/ciudades")
def ventana_ciudades(request: Request):
    try:
        with conn.cursor() as cursor:
            query = """SELECT * FROM ciudades"""
            cursor.execute(query)
            ciudades = cursor.fetchall()
        return templates.TemplateResponse("ciudades.html", {"request": request, "ciudades": ciudades})

    except Exception as e:
        print(f"Error: {str(e)}")

@app.get("/remolques")
def get_remolques(request: Request):
    try:
        with conn.cursor() as cursor:
            query = """SELECT * from remolques
            WHERE remolques.activo IS NULL or remolques.activo = True"""
            cursor.execute(query)
            remolques = cursor.fetchall()
        return templates.TemplateResponse("remolques.html", {"request": request, "remolques": remolques})

    except Exception as e:
        print(f"Error: {str(e)}")
        return JSONResponse(content={"error":"Error en la base de datos"}, status_code=500)

@app.get("/agregar_remolque")
def form_remolque(request: Request):
    return templates.TemplateResponse("agregarremolque.html", {"request": request})

@app.post("/agregar_remolque")
def agregar_remolque(remolque: Remolques):
    print(remolque)
    try:
        with conn.cursor() as cursor:
            query = """INSERT INTO remolques(
	                    descripcion)
	                    VALUES (%(nombre)s);"""
            cursor.execute(query, remolque.dict())
            conn.commit()
            print(remolque.dict())
        return JSONResponse(content={"mensaje": "Remolque agregado correctamente."})

    except ValidationError as e:
        print(f"Error de validación: {e.errors()}")
        return JSONResponse(content={"error": "Error de validación de datos", "detalle": e.errors()}, status_code=422)
    except Exception as e:
        print(f"Error: {str(e)}")
        return JSONResponse(content={"error": "Error en la base de datos"}, status_code=500)
    
@app.post("/remolques/{id}")
def eliminar_remolque(id):
    try:
        with conn.cursor() as cursor:
            query = f"SELECT id FROM remolques WHERE id = '{id}'"
            cursor.execute(query)
            result = cursor.fetchone()
            print(result[0])
            if result[0] is not None:
                query = f"""UPDATE remolques
                        SET activo= False
	                    WHERE id = '{id}'"""
                cursor.execute(query)
                conn.commit()
                return JSONResponse(content={"mensaje": "Eliminación exitosa"})
            else:
                return JSONResponse(content={"mensaje": "No se pudo encontrar el remolque"}, status_code=404)

    except Exception as e:
        print(f"Error al eliminar elemento en la base de datos: {str(e)}")
        return JSONResponse(content={"mensaje": "Error interno del servidor"}, status_code=500)

@app.get("/header", response_class=HTMLResponse)
def header(request: Request):
    return templates.TemplateResponse("header.html", {"request": request})

@app.get("/crear_factura")
def factura(request: Request):
    return templates.TemplateResponse("crearfactura.html", {"request": request})