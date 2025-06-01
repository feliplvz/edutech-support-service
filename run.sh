#!/bin/bash
# 🚀 Inicio rápido del Support Service
# Carga .env y ejecuta directamente mvn spring-boot:run

# Cargar variables del archivo .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
    echo "🔐 Variables cargadas desde .env"
else
    echo "❌ Archivo .env no encontrado"
    exit 1
fi

# Ejecutar el servicio
echo "🚀 Ejecutando mvn spring-boot:run..."
mvn spring-boot:run
