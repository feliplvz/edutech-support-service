@echo off
REM =============================================================================
REM EduTech - Script de Configuración Profesional (Windows) - Support Service
REM =============================================================================
REM Descripción: Configuración empresarial del entorno de desarrollo para el
REM              Microservicio de Soporte EduTech con validación completa
REM Autor: Equipo de Desarrollo EduTech
REM Versión: 1.0.0
REM Plataforma: Windows
REM =============================================================================

setlocal enabledelayedexpansion
set ROOT_DIR=%~dp0..\..
set SCRIPT_DIR=%~dp0
set TIMESTAMP=%date% %time%

REM Crear directorio de logs si no existe
if not exist "%ROOT_DIR%\logs" mkdir "%ROOT_DIR%\logs"
set LOG_FILE=%ROOT_DIR%\logs\configuracion.log

REM Función de logging
:log
echo [%TIMESTAMP%] [%~1] %~2 >> "%LOG_FILE%"
goto :eof

REM Funciones de impresión
:print_success
echo ✅ %~1
call :log "SUCCESS" "%~1"
goto :eof

:print_error
echo ❌ %~1
call :log "ERROR" "%~1"
goto :eof

:print_warning
echo ⚠️ %~1
call :log "WARNING" "%~1"
goto :eof

:print_info
echo ℹ️ %~1
call :log "INFO" "%~1"
goto :eof

:print_step
echo 🔧 %~1
call :log "STEP" "%~1"
goto :eof

REM Importar funciones de banner
call "%ROOT_DIR%\scripts\banner.bat"

REM Verificar prerequisitos
:check_prerequisites
call :print_step "Verificando requisitos del sistema..."
set errors=0

REM Verificar Java
java -version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%g in ('java -version 2^>^&1 ^| findstr /i "version"') do (
        set JAVA_VERSION=%%g
        set JAVA_VERSION=!JAVA_VERSION:"=!
        call :print_success "Java !JAVA_VERSION! encontrado ✓"
    )
) else (
    call :print_error "Java no encontrado. Instala OpenJDK 17+"
    set /a errors+=1
)

REM Verificar Maven
mvn -version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%g in ('mvn -version 2^>^&1 ^| findstr /i "Apache Maven"') do (
        call :print_success "Maven %%g encontrado ✓"
        goto maven_found
    )
    :maven_found
) else (
    call :print_error "Maven no encontrado. Instala Apache Maven 3.6+"
    set /a errors+=1
)

REM Verificar Git
git --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%g in ('git --version') do (
        call :print_success "Git %%g encontrado ✓"
        goto git_found
    )
    :git_found
) else (
    call :print_warning "Git no encontrado. Recomendado para control de versiones"
)

REM Verificar curl
curl --version >nul 2>&1
if %errorlevel% equ 0 (
    call :print_success "curl encontrado ✓"
) else (
    call :print_warning "curl no encontrado. Recomendado para health checks"
)

if %errors% gtr 0 (
    call :print_error "Se encontraron %errors% errores en los requisitos del sistema"
    call :show_error_banner "Configuración fallida. Instala los requisitos faltantes."
    exit /b 1
)

call :print_success "Todos los requisitos del sistema están disponibles"
goto :eof

REM Validar estructura del proyecto
:validate_project_structure
call :print_step "Validando estructura del proyecto Maven..."

cd /d "%ROOT_DIR%"

REM Verificar pom.xml
if exist "pom.xml" (
    call :print_success "pom.xml encontrado ✓"
    
    REM Verificar Spring Boot
    findstr /C:"spring-boot-starter-parent" pom.xml >nul
    if %errorlevel% equ 0 (
        call :print_success "Proyecto Spring Boot detectado ✓"
    ) else (
        call :print_warning "No se detectó Spring Boot en pom.xml"
    )
    
    REM Verificar dependencias clave
    findstr /C:"spring-boot-starter-web" pom.xml >nul
    if %errorlevel% equ 0 (
        call :print_success "Dependencia Web encontrada ✓"
    )
    
    findstr /C:"spring-boot-starter-data-jpa" pom.xml >nul
    if %errorlevel% equ 0 (
        call :print_success "Dependencia JPA encontrada ✓"
    )
    
    findstr /C:"postgresql" pom.xml >nul
    if %errorlevel% equ 0 (
        call :print_success "Driver PostgreSQL encontrado ✓"
    )
) else (
    call :print_error "pom.xml no encontrado. ¿Estás en el directorio correcto?"
    exit /b 1
)

REM Verificar directorios
if exist "src\main\java" (
    call :print_success "Directorio src\main\java existe ✓"
) else (
    call :print_warning "Directorio src\main\java no encontrado"
)

if exist "src\main\resources" (
    call :print_success "Directorio src\main\resources existe ✓"
) else (
    call :print_warning "Directorio src\main\resources no encontrado"
)

if exist "target" (
    call :print_success "Directorio target existe ✓"
) else (
    call :print_warning "Directorio target no encontrado"
)

call :print_success "Estructura del proyecto validada correctamente"
goto :eof

REM Configurar variables de entorno
:setup_environment_variables
call :print_step "Configurando variables de entorno..."

if exist "%ROOT_DIR%\.env" (
    call :print_success "Archivo .env encontrado ✓"
    
    REM Validar variables requeridas
    set missing_vars=0
    
    findstr /B "DATABASE_URL=" "%ROOT_DIR%\.env" >nul
    if %errorlevel% equ 0 (
        call :print_success "Variable DATABASE_URL configurada ✓"
    ) else (
        call :print_error "Variable DATABASE_URL falta en .env"
        set /a missing_vars+=1
    )
    
    findstr /B "DATABASE_USERNAME=" "%ROOT_DIR%\.env" >nul
    if %errorlevel% equ 0 (
        call :print_success "Variable DATABASE_USERNAME configurada ✓"
    ) else (
        call :print_error "Variable DATABASE_USERNAME falta en .env"
        set /a missing_vars+=1
    )
    
    findstr /B "DATABASE_PASSWORD=" "%ROOT_DIR%\.env" >nul
    if %errorlevel% equ 0 (
        call :print_success "Variable DATABASE_PASSWORD configurada ✓"
    ) else (
        call :print_error "Variable DATABASE_PASSWORD falta en .env"
        set /a missing_vars+=1
    )
    
    if !missing_vars! gtr 0 (
        call :print_warning "Faltan !missing_vars! variables en .env"
    )
) else (
    call :print_warning "Archivo .env no encontrado"
    call :print_info "Creando plantilla .env..."
    
    (
        echo # 🔐 VARIABLES DE ENTORNO - SUPPORT SERVICE
        echo # Configuración de Base de Datos PostgreSQL
        echo DATABASE_URL=jdbc:postgresql://localhost:5432/supportdb
        echo DATABASE_USERNAME=postgres
        echo DATABASE_PASSWORD=your_secure_password
        echo.
        echo # Configuración de la aplicación
        echo SERVER_PORT=8084
        echo APP_NAME=support-service
        echo.
        echo # Configuración JPA
        echo JPA_DDL_AUTO=update
        echo JPA_SHOW_SQL=true
        echo JPA_FORMAT_SQL=true
    ) > "%ROOT_DIR%\.env"
    
    call :print_success "Plantilla .env creada. Configura tus credenciales."
)
goto :eof

REM Inicializar directorios
:initialize_directories
call :print_step "Inicializando estructura de directorios..."

set dirs=logs target

for %%d in (%dirs%) do (
    if not exist "%ROOT_DIR%\%%d" (
        mkdir "%ROOT_DIR%\%%d"
        call :print_success "Directorio %%d creado ✓"
    ) else (
        call :print_success "Directorio %%d ya existe ✓"
    )
)
goto :eof

REM Generar resumen del proyecto
:generate_project_summary
call :print_step "Generando resumen del proyecto..."

set summary_file=%ROOT_DIR%\PROJECT_SUMMARY.md

(
    echo # 🎫 EduTech Support Service - Resumen del Proyecto
    echo.
    echo ## 📋 Información General
    echo - **Proyecto**: EduTech Support Service
    echo - **Versión**: 1.0.0-SNAPSHOT
    echo - **Framework**: Spring Boot 3.5.0
    echo - **Java**: 17+
    echo - **Puerto**: 8084
    echo - **Base de datos**: PostgreSQL
    echo.
    echo ## 🏗️ Estructura del Proyecto
    echo ```
    echo edutech-support-service/
    echo ├── src/main/java/com/edutech/supportservice/
    echo │   ├── SupportServiceApplication.java
    echo │   ├── config/          # Configuraciones
    echo │   ├── controller/      # Controladores REST
    echo │   ├── dto/            # Data Transfer Objects
    echo │   ├── exception/      # Manejo de excepciones
    echo │   ├── model/          # Entidades JPA
    echo │   ├── repository/     # Repositorios
    echo │   ├── service/        # Lógica de negocio
    echo │   └── util/           # Utilidades
    echo ├── src/main/resources/
    echo │   └── application.properties
    echo ├── scripts/            # Scripts de automatización
    echo ├── logs/              # Archivos de log
    echo └── target/            # Artefactos compilados
    echo ```
    echo.
    echo ## 🚀 Scripts Disponibles
    echo - `scripts\windows\controlador.bat` - Controlador maestro
    echo - `scripts\windows\configurar.bat` - Configuración del entorno
    echo - `scripts\windows\iniciar.bat` - Iniciar servicio
    echo - `scripts\windows\detener.bat` - Detener servicio
    echo - `scripts\windows\verificar-estado.bat` - Verificar estado
    echo.
    echo ## 🔗 Endpoints Principales
    echo - **Actuator Health**: http://localhost:8084/actuator/health
    echo - **Actuator Metrics**: http://localhost:8084/actuator/metrics
    echo - **API Tickets**: http://localhost:8084/api/tickets
    echo - **API Categorías**: http://localhost:8084/api/categories
    echo - **API FAQs**: http://localhost:8084/api/faqs
    echo - **API Mensajes**: http://localhost:8084/api/messages
    echo.
    echo ## 📅 Configurado el: %date% %time%
) > "%summary_file%"

call :print_success "Resumen del proyecto generado en PROJECT_SUMMARY.md ✓"
goto :eof

REM Test de compilación
:test_compilation
call :print_step "Ejecutando test de compilación..."

cd /d "%ROOT_DIR%"

mvn clean compile -q >nul 2>&1
if %errorlevel% equ 0 (
    call :print_success "Test de compilación exitoso ✓"
) else (
    call :print_error "Error en la compilación"
    exit /b 1
)
goto :eof

REM Función principal
:main
call :show_edutech_banner
call :show_operation_banner "🛠️ CONFIGURACIÓN DE ENTORNO" "Inicializando entorno de desarrollo profesional..."

echo Iniciando configuración del entorno de desarrollo...
echo.

call :check_prerequisites
echo.

call :validate_project_structure
echo.

call :setup_environment_variables
echo.

call :initialize_directories
echo.

call :generate_project_summary
echo.

call :test_compilation
echo.

call :show_success_banner "CONFIGURACIÓN COMPLETADA EXITOSAMENTE"

echo 🎉 ¡Entorno configurado correctamente!
echo 📋 Próximos pasos:
echo    1. Revisa y configura las credenciales en .env
echo    2. Ejecuta scripts\windows\controlador.bat para gestionar el servicio
echo    3. Usa scripts\windows\iniciar.bat para iniciar el servicio
echo    4. Verifica el estado con scripts\windows\verificar-estado.bat
echo.

call :log "SUCCESS" "Configuración del entorno completada exitosamente"
goto :eof

REM Ejecutar configuración
call :main
