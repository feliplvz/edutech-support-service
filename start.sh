#!/bin/bash
# 🚀 Script de inicio para EduTech Support Service
# Este script carga automáticamente las variables de entorno y ejecuta el servicio

echo "🚀 Iniciando EduTech Support Service..."
echo "📁 Directorio actual: $(pwd)"

# 🔍 Verificar que estamos en el directorio correcto
if [ ! -f "pom.xml" ]; then
    echo "❌ Error: No se encontró pom.xml. Ejecuta este script desde el directorio raíz del proyecto."
    exit 1
fi

# 🔍 Verificar que existe el archivo .env
if [ ! -f ".env" ]; then
    echo "❌ Error: No se encontró el archivo .env con las credenciales."
    echo "💡 Crea el archivo .env con las variables DATABASE_URL, DATABASE_USERNAME, DATABASE_PASSWORD"
    exit 1
fi

echo "🔐 Cargando variables de entorno desde .env..."

# 🔑 Cargar variables de entorno desde .env
export $(grep -v '^#' .env | xargs)

echo "✅ Variables cargadas:"
echo "   📊 DATABASE_URL: ${DATABASE_URL}"
echo "   👤 DATABASE_USERNAME: ${DATABASE_USERNAME}"
echo "   🔒 DATABASE_PASSWORD: ********** (oculta por seguridad)"

echo ""
echo "🏗️ Compilando proyecto..."
mvn clean compile

if [ $? -eq 0 ]; then
    echo "✅ Compilación exitosa"
    echo ""
    echo "🚀 Iniciando servicio Spring Boot..."
    echo "🌐 El servicio estará disponible en: http://localhost:8084"
    echo "🏥 Health check en: http://localhost:8084/actuator/health"
    echo ""
    mvn spring-boot:run
else
    echo "❌ Error en la compilación. Revisa los logs anteriores."
    exit 1
fi
