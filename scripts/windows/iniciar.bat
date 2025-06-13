@echo off
REM =============================================================================
REM EduTech - Script de Inicio Inteligente (Windows) - Support Service
REM =============================================================================
REM Descripción: Inicio avanzado del Microservicio de Soporte EduTech
REM              con verificaciones completas y monitoreo en tiempo real
REM Autor: Equipo de Desarrollo EduTech
REM Versión: 1.0.0
REM Plataforma: Windows
REM =============================================================================

setlocal enabledelayedexpansion
set ROOT_DIR=%~dp0..\..
set SCRIPT_DIR=%~dp0
set SERVICE_NAME=Support Service
set SERVICE_PORT=8084
set HEALTH_ENDPOINT=http://localhost:%SERVICE_PORT%/actuator/health
set MAX_WAIT_TIME=120
set LOG_FILE=%ROOT_DIR%\logs\inicio.log
set PID_FILE=%ROOT_DIR%\logs\service.pid

REM Crear directorio de logs
if not exist "%ROOT_DIR%\logs" mkdir "%ROOT_DIR%\logs"

REM Función de logging
:log
echo [%date% %time%] [%~1] %~2 >> "%LOG_FILE%"
goto :eof

REM Importar funciones de banner
call "%ROOT_DIR%\scripts\banner.bat"

REM Verificar si el puerto está en uso
:check_port
netstat -an | findstr ":%~1 " | findstr "LISTENING" >nul
goto :eof

REM Obtener PID del proceso en el puerto
:get_port_pid
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%~1 " ^| findstr "LISTENING"') do (
    set port_pid=%%a
    goto :eof
)
set port_pid=
goto :eof

REM Detener procesos existentes
:stop_existing_service
call :show_operation_banner "🛑 VERIFICANDO PROCESOS EXISTENTES" "Buscando instancias del servicio en ejecución..."

call :check_port %SERVICE_PORT%
if %errorlevel% equ 0 (
    call :get_port_pid %SERVICE_PORT%
    call :show_warning_banner "Servicio detectado en puerto %SERVICE_PORT% (PID: !port_pid!)"
    
    set /p response="¿Deseas detener el servicio existente? (s/N): "
    if /i "!response!"=="s" (
        call :log "INFO" "Deteniendo servicio existente (PID: !port_pid!)"
        taskkill /PID !port_pid! /F >nul 2>&1
        timeout /t 3 /nobreak >nul
        call :show_success_banner "Servicio anterior detenido correctamente"
    ) else (
        call :show_error_banner "No se puede iniciar - puerto %SERVICE_PORT% ocupado"
        exit /b 1
    )
) else (
    call :show_success_banner "Puerto %SERVICE_PORT% disponible"
)
goto :eof

REM Verificar prerequisitos
:check_prerequisites
call :show_operation_banner "🔍 VERIFICANDO PREREQUISITOS" "Validando entorno de ejecución..."

set errors=0

REM Verificar Java
java -version >nul 2>&1
if %errorlevel% neq 0 (
    call :show_error_banner "Java no encontrado"
    set /a errors+=1
) else (
    for /f "tokens=3" %%g in ('java -version 2^>^&1 ^| findstr /i "version"') do (
        call :log "INFO" "Java detectado: %%g"
    )
)

REM Verificar Maven
mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    call :show_error_banner "Maven no encontrado"
    set /a errors+=1
) else (
    call :log "INFO" "Maven detectado"
)

REM Verificar .env
if not exist "%ROOT_DIR%\.env" (
    call :show_error_banner "Archivo .env no encontrado"
    set /a errors+=1
) else (
    call :log "INFO" "Archivo .env encontrado"
)

REM Verificar pom.xml
if not exist "%ROOT_DIR%\pom.xml" (
    call :show_error_banner "Archivo pom.xml no encontrado"
    set /a errors+=1
) else (
    call :log "INFO" "Archivo pom.xml encontrado"
)

if %errors% gtr 0 (
    call :show_error_banner "Faltan %errors% prerequisitos. Ejecuta scripts\windows\configurar.bat"
    exit /b 1
)

call :show_success_banner "Todos los prerequisitos están disponibles"
goto :eof

REM Cargar variables de entorno
:load_environment
call :show_operation_banner "⚙️ CARGANDO VARIABLES DE ENTORNO" "Configurando variables desde .env..."

if exist "%ROOT_DIR%\.env" (
    REM Cargar variables del archivo .env
    for /f "usebackq tokens=1,2 delims==" %%a in ("%ROOT_DIR%\.env") do (
        if not "%%a"=="" if not "%%a:~0,1%"=="#" (
            set %%a=%%b
        )
    )
    
    call :log "INFO" "Variables de entorno cargadas desde .env"
    echo ✅ DATABASE_URL: %DATABASE_URL%
    echo ✅ DATABASE_USERNAME: %DATABASE_USERNAME%
    echo ✅ DATABASE_PASSWORD: ****
    
    call :show_success_banner "Variables de entorno cargadas correctamente"
) else (
    call :show_error_banner "No se pudo cargar .env"
    exit /b 1
)
goto :eof

REM Compilar proyecto
:compile_project
call :show_operation_banner "🔨 COMPILANDO PROYECTO" "Compilando y empaquetando aplicación..."

cd /d "%ROOT_DIR%"

call :log "INFO" "Iniciando compilación Maven"

mvn clean compile -q >nul 2>&1
if %errorlevel% equ 0 (
    call :log "INFO" "Compilación exitosa"
    call :show_success_banner "Compilación completada"
) else (
    call :show_error_banner "Error en la compilación"
    call :log "ERROR" "Falló la compilación Maven"
    exit /b 1
)
goto :eof

REM Iniciar servicio
:start_service
call :show_operation_banner "🚀 INICIANDO SERVICIO" "Ejecutando Support Service..."

cd /d "%ROOT_DIR%"

call :log "INFO" "Iniciando Support Service en puerto %SERVICE_PORT%"

REM Iniciar el servicio en background
start /B mvn spring-boot:run > "%ROOT_DIR%\logs\service.out" 2>&1

REM Obtener PID del proceso Maven
for /f "tokens=2" %%a in ('tasklist /FI "IMAGENAME eq java.exe" /FO CSV ^| findstr "mvn"') do (
    set service_pid=%%a
    goto pid_found
)
:pid_found

REM Guardar PID
echo %service_pid% > "%PID_FILE%"
call :log "INFO" "Servicio iniciado con PID: %service_pid%"

echo 🚀 Servicio iniciandose...
echo 📋 PID: %service_pid%
echo 📁 Logs: %ROOT_DIR%\logs\service.out
echo 🌐 URL: http://localhost:%SERVICE_PORT%
goto :eof

REM Verificar salud del servicio
:wait_for_health
call :show_operation_banner "🏥 VERIFICANDO SALUD DEL SERVICIO" "Esperando que el servicio esté listo..."

set wait_time=0
set health_ok=false

echo Verificando salud en: %HEALTH_ENDPOINT%

:health_loop
if %wait_time% geq %MAX_WAIT_TIME% goto health_timeout

curl -s "%HEALTH_ENDPOINT%" >nul 2>&1
if %errorlevel% equ 0 (
    set health_ok=true
    goto health_success
)

echo ⏳ Esperando... (%wait_time%s/%MAX_WAIT_TIME%s)
timeout /t 5 /nobreak >nul
set /a wait_time+=5
goto health_loop

:health_timeout
call :show_error_banner "Servicio no responde después de %MAX_WAIT_TIME%s"
call :log "ERROR" "Timeout esperando respuesta del servicio"
exit /b 1

:health_success
call :show_success_banner "Servicio iniciado correctamente"

echo 💚 Estado de salud:
curl -s "%HEALTH_ENDPOINT%"

call :log "INFO" "Servicio iniciado y saludable en %wait_time%s"
goto :eof

REM Mostrar información del servicio
:show_service_info
if exist "%PID_FILE%" (
    set /p pid=<"%PID_FILE%"
) else (
    set pid=N/A
)
set status=🟢 ACTIVO

call :show_service_status "%status%" "%SERVICE_PORT%" "%pid%"

echo.
echo 🔗 ENDPOINTS DISPONIBLES:
echo 🏥 Health Check: http://localhost:%SERVICE_PORT%/actuator/health
echo 📊 Métricas: http://localhost:%SERVICE_PORT%/actuator/metrics
echo 🎫 API Tickets: http://localhost:%SERVICE_PORT%/api/tickets
echo 📂 API Categorías: http://localhost:%SERVICE_PORT%/api/categories
echo ❓ API FAQs: http://localhost:%SERVICE_PORT%/api/faqs
echo 💬 API Mensajes: http://localhost:%SERVICE_PORT%/api/messages

echo.
echo 📋 COMANDOS ÚTILES:
echo • Ver logs: type %ROOT_DIR%\logs\service.out
echo • Detener servicio: scripts\windows\detener.bat
echo • Verificar estado: scripts\windows\verificar-estado.bat
echo • Ver métricas: curl http://localhost:%SERVICE_PORT%/actuator/metrics
goto :eof

REM Función principal
:main
call :show_edutech_banner

call :log "INFO" "Iniciando proceso de arranque del Support Service"

call :check_prerequisites
echo.

call :stop_existing_service
echo.

call :load_environment
echo.

call :compile_project
echo.

call :start_service
echo.

call :wait_for_health
if %errorlevel% equ 0 (
    echo.
    call :show_service_info
    echo.
    
    call :show_success_banner "🎉 SUPPORT SERVICE INICIADO EXITOSAMENTE 🎉"
    call :log "INFO" "Support Service iniciado exitosamente"
) else (
    call :show_error_banner "Error al iniciar el servicio"
    call :log "ERROR" "Error al iniciar el Support Service"
    
    echo.
    echo 📋 Últimas líneas del log:
    if exist "%ROOT_DIR%\logs\service.out" (
        more +0 "%ROOT_DIR%\logs\service.out"
    ) else (
        echo No hay logs disponibles
    )
    
    exit /b 1
)
goto :eof

REM Ejecutar función principal
call :main
