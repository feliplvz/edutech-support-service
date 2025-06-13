@echo off
REM =============================================================================
REM EduTech - Script Maestro de Control (Windows) - Support Service
REM =============================================================================
REM Descripción: Script empresarial para gestionar el ciclo completo de desarrollo
REM              del Microservicio de Soporte EduTech
REM Autor: Equipo de Desarrollo EduTech
REM Versión: 1.0.0
REM Plataforma: Windows
REM =============================================================================

setlocal enabledelayedexpansion
set VERSION=1.0.0
set ROOT_DIR=%~dp0..\..
set SCRIPT_DIR=%~dp0

REM Crear directorio de logs si no existe
if not exist "%ROOT_DIR%\logs" mkdir "%ROOT_DIR%\logs"

REM Función de logging
:log
echo [%date% %time%] [%~1] %~2 >> "%ROOT_DIR%\logs\controlador.log"
goto :eof

REM Mostrar menú principal
:show_main_menu
call :show_edutech_banner
call :show_operation_banner "🎮 CONTROLADOR MAESTRO SUPPORT SERVICE" "Centro de comando unificado v%VERSION%"

echo ╔═══════════════════════════════════════════════════════════════════════════════════╗
echo ║ 🔧 CONFIGURACIÓN ║
echo ╠═══════════════════════════════════════════════════════════════════════════════════╣
echo ║  1) configurar      - 🛠️  Configurar entorno de desarrollo        ║
echo ║  2) variables       - ⚙️  Gestionar variables de entorno            ║
echo ║                                                                          ║
echo ║ 🚀 CICLO DE VIDA ║
echo ╠═══════════════════════════════════════════════════════════════════════════════════╣
echo ║  3) iniciar         - 🚀 Iniciar el microservicio                  ║
echo ║  4) detener         - 🛑 Detener el microservicio                  ║
echo ║  5) reiniciar       - 🔄 Reiniciar el microservicio                ║
echo ║  6) estado          - 🔍 Verificar estado del servicio             ║
echo ║                                                                          ║
echo ║ 🔨 COMPILACIÓN ^& PRUEBAS ║
echo ╠═══════════════════════════════════════════════════════════════════════════════════╣
echo ║  7) compilar        - 🔨 Compilar la aplicación                    ║
echo ║  8) pruebas         - 🧪 Ejecutar pruebas unitarias               ║
echo ║  9) empaquetar      - 📦 Crear paquete desplegable                ║
echo ║ 10) limpiar         - 🧹 Limpiar artefactos de compilación        ║
echo ║                                                                          ║
echo ║ 📊 MONITOREO ^& LOGS ║
echo ╠═══════════════════════════════════════════════════════════════════════════════════╣
echo ║ 11) logs            - 📋 Ver logs de la aplicación                ║
echo ║ 12) salud           - 🏥 Verificar endpoints de salud             ║
echo ║ 13) metricas        - 📈 Ver métricas del sistema                 ║
echo ║ 14) bd              - 🗄️ Verificar conectividad de BD             ║
echo ║                                                                          ║
echo ║ 🔧 HERRAMIENTAS DEV ║
echo ╠═══════════════════════════════════════════════════════════════════════════════════╣
echo ║ 15) dependencias    - 📦 Gestionar dependencias Maven             ║
echo ║ 16) postman         - 📮 Operaciones con Postman                  ║
echo ║ 17) info            - ℹ️  Información del proyecto                 ║
echo ║ 18) ayuda           - ❓ Ayuda y documentación                    ║
echo ║                                                                          ║
echo ║  0) salir           - 🚪 Salir del controlador                  ║
echo ╚═══════════════════════════════════════════════════════════════════════════════════╝
echo.
goto :eof

REM Funciones para cada operación
:function_configurar
call :show_operation_banner "⚙️ CONFIGURANDO ENTORNO" "Ejecutando configuración del entorno de desarrollo..."
if exist "%SCRIPT_DIR%configurar.bat" (
    call "%SCRIPT_DIR%configurar.bat"
) else (
    call :show_error_banner "Script configurar.bat no encontrado"
)
goto :eof

:function_variables
call :show_operation_banner "⚙️ GESTIÓN DE VARIABLES" "Mostrando variables de entorno actuales..."
if exist "%ROOT_DIR%\.env" (
    echo Variables definidas en .env:
    findstr /v "^#" "%ROOT_DIR%\.env" | findstr /v "^$"
) else (
    call :show_error_banner "Archivo .env no encontrado"
)
goto :eof

:function_iniciar
call :show_operation_banner "🚀 INICIANDO SERVICIO" "Iniciando Support Service..."
if exist "%SCRIPT_DIR%iniciar.bat" (
    call "%SCRIPT_DIR%iniciar.bat"
) else (
    call :show_error_banner "Script iniciar.bat no encontrado"
)
goto :eof

:function_detener
call :show_operation_banner "🛑 DETENIENDO SERVICIO" "Deteniendo Support Service..."
if exist "%SCRIPT_DIR%detener.bat" (
    call "%SCRIPT_DIR%detener.bat"
) else (
    call :show_error_banner "Script detener.bat no encontrado"
)
goto :eof

:function_reiniciar
call :show_operation_banner "🔄 REINICIANDO SERVICIO" "Reiniciando Support Service..."
call :function_detener
timeout /t 3 /nobreak >nul
call :function_iniciar
goto :eof

:function_estado
call :show_operation_banner "🔍 VERIFICANDO ESTADO" "Verificando estado del Support Service..."
if exist "%SCRIPT_DIR%verificar-estado.bat" (
    call "%SCRIPT_DIR%verificar-estado.bat"
) else (
    call :show_error_banner "Script verificar-estado.bat no encontrado"
)
goto :eof

:function_compilar
call :show_operation_banner "🔨 COMPILANDO" "Compilando la aplicación..."
cd /d "%ROOT_DIR%"
mvn clean compile
goto :eof

:function_pruebas
call :show_operation_banner "🧪 EJECUTANDO PRUEBAS" "Ejecutando pruebas unitarias..."
cd /d "%ROOT_DIR%"
mvn test
goto :eof

:function_empaquetar
call :show_operation_banner "📦 EMPAQUETANDO" "Creando paquete desplegable..."
cd /d "%ROOT_DIR%"
mvn clean package -DskipTests
goto :eof

:function_limpiar
call :show_operation_banner "🧹 LIMPIANDO" "Limpiando artefactos de compilación..."
cd /d "%ROOT_DIR%"
mvn clean
goto :eof

:function_logs
call :show_operation_banner "📋 LOGS DE APLICACIÓN" "Mostrando logs recientes..."
if exist "%ROOT_DIR%\logs\support-audit.log" (
    more +0 "%ROOT_DIR%\logs\support-audit.log"
) else (
    echo No se encontraron logs de la aplicación
)
goto :eof

:function_salud
call :show_operation_banner "🏥 VERIFICANDO SALUD" "Verificando endpoints de salud..."
echo Verificando http://localhost:8084/actuator/health...
curl -s http://localhost:8084/actuator/health >nul 2>&1
if %errorlevel% equ 0 (
    call :show_success_banner "Servicio respondiendo correctamente"
    curl -s http://localhost:8084/actuator/health
) else (
    call :show_error_banner "Servicio no responde en puerto 8084"
)
goto :eof

:function_metricas
call :show_operation_banner "📈 MÉTRICAS DEL SISTEMA" "Obteniendo métricas del sistema..."
echo Verificando http://localhost:8084/actuator/metrics...
curl -s http://localhost:8084/actuator/metrics >nul 2>&1
if %errorlevel% equ 0 (
    curl -s http://localhost:8084/actuator/metrics
) else (
    call :show_error_banner "No se pueden obtener métricas - servicio no disponible"
)
goto :eof

:function_bd
call :show_operation_banner "🗄️ VERIFICANDO BASE DE DATOS" "Verificando conectividad con PostgreSQL..."
if exist "%ROOT_DIR%\.env" (
    echo Verificando conexión a base de datos...
    call :show_info_banner "Variables de BD disponibles en .env"
) else (
    call :show_error_banner "Archivo .env no encontrado"
)
goto :eof

:function_dependencias
call :show_operation_banner "📦 DEPENDENCIAS MAVEN" "Mostrando información de dependencias..."
cd /d "%ROOT_DIR%"
mvn dependency:tree
goto :eof

:function_postman
call :show_operation_banner "📮 POSTMAN" "Información sobre colecciones Postman..."
if exist "%ROOT_DIR%\EduTech-Support-Service.postman_collection.json" (
    call :show_success_banner "Colección Postman encontrada: EduTech-Support-Service.postman_collection.json"
) else (
    call :show_warning_banner "No se encontró colección Postman"
)
goto :eof

:function_info
call :show_project_info
goto :eof

:function_ayuda
call :show_operation_banner "❓ AYUDA Y DOCUMENTACIÓN" "Información de ayuda del controlador..."
echo Uso del controlador:
echo • Ejecuta: scripts\windows\controlador.bat
echo • Selecciona una opción del menú
echo • También puedes pasar parámetros directamente:
echo   controlador.bat iniciar
echo   controlador.bat estado
echo   controlador.bat detener
goto :eof

REM Importar funciones de banner
call "%ROOT_DIR%\scripts\banner.bat"

REM Función principal
:main
call :log "INFO" "Iniciando controlador maestro Support Service"

REM Si se pasa un parámetro, ejecutar directamente
if not "%~1"=="" (
    if /i "%~1"=="configurar" goto function_configurar
    if /i "%~1"=="1" goto function_configurar
    if /i "%~1"=="variables" goto function_variables
    if /i "%~1"=="2" goto function_variables
    if /i "%~1"=="iniciar" goto function_iniciar
    if /i "%~1"=="3" goto function_iniciar
    if /i "%~1"=="detener" goto function_detener
    if /i "%~1"=="4" goto function_detener
    if /i "%~1"=="reiniciar" goto function_reiniciar
    if /i "%~1"=="5" goto function_reiniciar
    if /i "%~1"=="estado" goto function_estado
    if /i "%~1"=="6" goto function_estado
    if /i "%~1"=="compilar" goto function_compilar
    if /i "%~1"=="7" goto function_compilar
    if /i "%~1"=="pruebas" goto function_pruebas
    if /i "%~1"=="8" goto function_pruebas
    if /i "%~1"=="empaquetar" goto function_empaquetar
    if /i "%~1"=="9" goto function_empaquetar
    if /i "%~1"=="limpiar" goto function_limpiar
    if /i "%~1"=="10" goto function_limpiar
    if /i "%~1"=="logs" goto function_logs
    if /i "%~1"=="11" goto function_logs
    if /i "%~1"=="salud" goto function_salud
    if /i "%~1"=="12" goto function_salud
    if /i "%~1"=="metricas" goto function_metricas
    if /i "%~1"=="13" goto function_metricas
    if /i "%~1"=="bd" goto function_bd
    if /i "%~1"=="14" goto function_bd
    if /i "%~1"=="dependencias" goto function_dependencias
    if /i "%~1"=="15" goto function_dependencias
    if /i "%~1"=="postman" goto function_postman
    if /i "%~1"=="16" goto function_postman
    if /i "%~1"=="info" goto function_info
    if /i "%~1"=="17" goto function_info
    if /i "%~1"=="ayuda" goto function_ayuda
    if /i "%~1"=="18" goto function_ayuda
    
    call :show_error_banner "Opción no válida: %~1"
    call :function_ayuda
    goto :eof
)

REM Menú interactivo
:menu_loop
call :show_main_menu
set /p option="Selecciona una opción (0-18): "

if "%option%"=="1" goto function_configurar
if "%option%"=="configurar" goto function_configurar
if "%option%"=="2" goto function_variables
if "%option%"=="variables" goto function_variables
if "%option%"=="3" goto function_iniciar
if "%option%"=="iniciar" goto function_iniciar
if "%option%"=="4" goto function_detener
if "%option%"=="detener" goto function_detener
if "%option%"=="5" goto function_reiniciar
if "%option%"=="reiniciar" goto function_reiniciar
if "%option%"=="6" goto function_estado
if "%option%"=="estado" goto function_estado
if "%option%"=="7" goto function_compilar
if "%option%"=="compilar" goto function_compilar
if "%option%"=="8" goto function_pruebas
if "%option%"=="pruebas" goto function_pruebas
if "%option%"=="9" goto function_empaquetar
if "%option%"=="empaquetar" goto function_empaquetar
if "%option%"=="10" goto function_limpiar
if "%option%"=="limpiar" goto function_limpiar
if "%option%"=="11" goto function_logs
if "%option%"=="logs" goto function_logs
if "%option%"=="12" goto function_salud
if "%option%"=="salud" goto function_salud
if "%option%"=="13" goto function_metricas
if "%option%"=="metricas" goto function_metricas
if "%option%"=="14" goto function_bd
if "%option%"=="bd" goto function_bd
if "%option%"=="15" goto function_dependencias
if "%option%"=="dependencias" goto function_dependencias
if "%option%"=="16" goto function_postman
if "%option%"=="postman" goto function_postman
if "%option%"=="17" goto function_info
if "%option%"=="info" goto function_info
if "%option%"=="18" goto function_ayuda
if "%option%"=="ayuda" goto function_ayuda
if "%option%"=="0" goto exit_script
if "%option%"=="salir" goto exit_script

call :show_error_banner "Opción no válida. Por favor selecciona una opción entre 0-18."
pause
goto menu_loop

:menu_continue
echo.
pause
goto menu_loop

:exit_script
call :show_success_banner "¡Hasta luego! 👋"
goto :eof

REM Ejecutar función principal
call :main %*

REM Continuar con menú si no hay parámetros
if "%~1"=="" goto menu_loop
goto :eof
