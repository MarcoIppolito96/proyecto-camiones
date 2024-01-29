from fastapi import FastAPI, Body
from fastapi.responses import HTMLResponse

app = FastAPI()

app.title = "Mi primera aplicacion con FASTAPI"

movies = [
    {"id": 1, "Titulo": "Inception", "Descripcion": "Dream heist thriller", "Año": 2010, "Puntaje": 8.8, "Categoria": "Sci-Fi"},
    {"id": 2, "Titulo": "The Shawshank Redemption", "Descripcion": "Prison drama", "Año": 1994, "Puntaje": 9.3, "Categoria": "Drama"},
    {"id": 3, "Titulo": "The Godfather", "Descripcion": "Mafia epic", "Año": 1972, "Puntaje": 9.2, "Categoria": "Crime"},
    {"id": 4, "Titulo": "The Dark Knight", "Descripcion": "Superhero action", "Año": 2008, "Puntaje": 9.0, "Categoria": "Action"},
    {"id": 5, "Titulo": "Pulp Fiction", "Descripcion": "Cult crime film", "Año": 1994, "Puntaje": 8.9, "Categoria": "Crime"},
    {"id": 6, "Titulo": "Forrest Gump", "Descripcion": "Life's journey", "Año": 1994, "Puntaje": 8.8, "Categoria": "Drama"},
    {"id": 7, "Titulo": "The Matrix", "Descripcion": "Virtual reality thriller", "Año": 1999, "Puntaje": 8.7, "Categoria": "Sci-Fi"},
    {"id": 8, "Titulo": "Schindler's List", "Descripcion": "Holocaust drama", "Año": 1993, "Puntaje": 8.9, "Categoria": "Drama"},
    {"id": 9, "Titulo": "Fight Club", "Descripcion": "Psychological thriller", "Año": 1999, "Puntaje": 8.8, "Categoria": "Drama"},
    {"id": 10, "Titulo": "The Lord of the Rings: The Return of the King", "Descripcion": "Epic fantasy", "Año": 2003, "Puntaje": 8.9, "Categoria": "Fantasy"}
]


@app.get("/", tags=['Home'])
def home():
    return "holita Mundo"


@app.get("/movies", tags=['Movies'])
def home():
    return movies


@app.get("/movies/{id}", tags=['Movies'])
def get_movie(id: int):
    for pelicula in movies:
        if pelicula["id"] == id:
            return pelicula
    return "La pelicula no fue encontrada"


@app.get("/movies/", tags=['Movies'])
def get_movie_by_category(category: str, year: int):
    for pelicula in movies:
        if pelicula["Categoria"] == category:
            yield pelicula


@app.post("/movies", tags=['Movies'])
def create_movie(id: int = Body(),
                    titulo: str = Body(),
                    descripcion: str = Body(),
                    año: int= Body(),
                    puntaje: float= Body(), 
                    categoria: str= Body()):
    movies.append(
        {
        'id': id,
        'Titulo': titulo,
        'Año': año,
        'Puntaje': puntaje,
        'Categoria': categoria,
     })
    return movies

@app.put("/movies/{id}", tags=['Movies'])
def update_movie():
    for movie in movies:
        if movie['id'] == id:
            