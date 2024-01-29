@echo off

rem Instalar Python 3.12.1 y pip
choco install python --version=3.12.1 -y

rem Crear y activar el entorno virtual
python -m venv env
.\env\Scripts\activate

rem Instalar las dependencias del proyecto desde requirements.txt
pip install -r requirements.txt

rem Ejecutar la aplicación
uvicorn main:app --port 8000 --reload
