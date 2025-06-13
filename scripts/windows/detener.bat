@echo off
REM =============================================================================
REM EduTech - Script de Parada Elegante (Windows) - Support Service
REM =============================================================================
REM Descripción: Terminación inteligente del Microservicio de Soporte EduTech
REM              con métodos graceful y forzado según sea necesario
REM Autor: Equipo de Desarrollo EduTech
REM Versión: 1.0.0
REM Plataforma: Windows
REM =============================================================================

setlocal enabledelayedexpansion
set ROOT_DIR=%~dp0..\..
set SCRIPT_DIR=%~dp0
set SERVICE_NAME=Support Service
set SERVICE_PORT=8084
set LOG_FILE=%ROOT_DIR%\logs\detener.log
set PID_FILE=%ROOT_DIR%\logs\service.pid
set GRACEFUL_TIMEOUT=15

REM Crear directorio de logs
if not exist "%ROOT_DIR%\logs" mkdir "%ROOT_DIR%\logs"

REM Función de logging
:log
echo [%date% %time%] [%~1] %~2 >> "%LOG_FILE%"
goto :eof

REM Importar funciones de banner
call "%ROOT_DIR%\scripts\banner.bat"

REM Verificar si un proceso existe
:process_exists
tasklist /PID %~1 >nul 2>&1
goto :eof

REM Obtener PIDs relacionados al servicio
:get_service_pids
set pids=

REM Buscar por puerto
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%SERVICE_PORT% " ^| findstr "LISTENING"') do (
    set pids=!pids! %%a
)

REM Buscar procesos Java con Spring Boot
for /f "tokens=2" %%a in ('tasklist /FI "IMAGENAME eq java.exe" /FO CSV 2^>nul ^| findstr "spring-boot"') do (
    set pids=!pids! %%a
)

REM Buscar procesos Maven
for /f "tokens=2" %%a in ('tasklist /FI "IMAGENAME eq java.exe" /FO CSV 2^>nul ^| findstr "mvn"') do (
    set pids=!pids! %%a
)

echo %pids%
goto :eof

REM Terminación elegante
:graceful_shutdown
set pid=%~1
set process_name=%~2

call :log "INFO" "Iniciando terminación elegante del proceso %pid% (%process_name%)"

call :process_exists %pid%
if %errorlevel% neq 0 (
    call :log "INFO" "Proceso %pid% ya no existe"
    exit /b 0
)

REM Enviar señal de terminación (Windows equivalente a SIGTERM)
call :log "INFO" "Enviando señal de terminación a proceso %pid%"
taskkill /PID %pid% >nul 2>&1

REM Esperar terminación elegante
set wait_time=0
:graceful_wait
if %wait_time% geq %GRACEFUL_TIMEOUT% goto graceful_failed

call :process_exists %pid%
if %errorlevel% neq 0 (
    call :log "INFO" "Proceso %pid% terminado elegantemente en %wait_time%s"
    exit /b 0
)

timeout /t 1 /nobreak >nul
set /a wait_time+=1
goto graceful_wait

:graceful_failed
call :log "WARNING" "Proceso %pid% no terminó en %GRACEFUL_TIMEOUT% segundos"
exit /b 1

REM Terminación forzada
:force_shutdown
set pid=%~1
set process_name=%~2

call :log "WARNING" "Forzando terminación del proceso %pid% (%process_name%)"

call :process_exists %pid%
if %errorlevel% neq 0 (
    call :log "INFO" "Proceso %pid% ya no existe"
    exit /b 0
)

REM Enviar SIGKILL (Windows: /F force)
taskkill /PID %pid% /F >nul 2>&1
timeout /t 2 /nobreak >nul

call :process_exists %pid%
if %errorlevel% neq 0 (
    call :log "INFO" "Proceso %pid% terminado forzadamente"
    exit /b 0
) else (
    call :log "ERROR" "No se pudo terminar el proceso %pid%"
    exit /b 1
)

REM Limpiar archivos PID
:cleanup_pid_files
if exist "%PID_FILE%" (
    call :log "INFO" "Eliminando archivo PID"
    del "%PID_FILE%" >nul 2>&1
)
goto :eof

REM Verificar estado después de la parada
:verify_shutdown
call :show_operation_banner "🔍 VERIFICANDO PARADA" "Confirmando que el servicio se detuvo correctamente..."

REM Verificar puerto
netstat -an | findstr ":%SERVICE_PORT% " | findstr "LISTENING" >nul
if %errorlevel% equ 0 (
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%SERVICE_PORT% " ^| findstr "LISTENING"') do (
        call :show_warning_banner "Puerto %SERVICE_PORT% aún ocupado por proceso %%a"
        exit /b 1
    )
)

REM Verificar procesos Java relacionados
tasklist /FI "IMAGENAME eq java.exe" | findstr "spring-boot" >nul
if %errorlevel% equ 0 (
    call :show_warning_banner "Procesos Java relacionados aún en ejecución"
    exit /b 1
)

call :show_success_banner "Servicio completamente detenido"
exit /b 0

REM Mostrar información antes de detener
:show_pre_shutdown_info
call :show_operation_banner "📊 INFORMACIÓN ACTUAL DEL SERVICIO" "Obteniendo estado antes de detener..."

REM Verificar si el servicio está corriendo
netstat -an | findstr ":%SERVICE_PORT% " | findstr "LISTENING" >nul
if %errorlevel% equ 0 (
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%SERVICE_PORT% " ^| findstr "LISTENING"') do (
        echo 🟢 Servicio detectado en puerto %SERVICE_PORT% (PID: %%a)
        
        REM Intentar obtener información de salud
        curl -s "http://localhost:%SERVICE_PORT%/actuator/health" >nul 2>&1
        if %errorlevel% equ 0 (
            echo ✅ Endpoint de salud respondiendo
        ) else (
            echo ⚠️ Endpoint de salud no responde
        )
    )
) else (
    echo ⚠️ No se detectó servicio en puerto %SERVICE_PORT%
)

REM Mostrar procesos relacionados
call :get_service_pids
set service_pids=%errorlevel%
if not "%service_pids%"=="" (
    echo 📋 Procesos relacionados encontrados:
    for %%p in (%service_pids%) do (
        for /f "tokens=1" %%n in ('tasklist /PID %%p /FO CSV 2^>nul ^| findstr "%%p"') do (
            echo   PID %%p: %%n
        )
    )
) else (
    echo ⚠️ No se encontraron procesos relacionados
)
goto :eof

REM Función principal de detención
:stop_service
call :show_operation_banner "🛑 DETENIENDO SUPPORT SERVICE" "Iniciando proceso de parada elegante..."

call :get_service_pids
set service_pids=%errorlevel%
set stopped_count=0
set failed_count=0

if "%service_pids%"=="" (
    call :show_warning_banner "No se encontraron procesos del servicio ejecutándose"
    call :cleanup_pid_files
    exit /b 0
)

call :log "INFO" "Encontrados procesos para detener: %service_pids%"

REM Intentar parada elegante para todos los procesos
for %%p in (%service_pids%) do (
    echo 🔄 Deteniendo proceso %%p...
    
    call :graceful_shutdown %%p "proceso"
    if %errorlevel% equ 0 (
        echo ✅ Proceso %%p detenido elegantemente
        set /a stopped_count+=1
    ) else (
        echo ⚠️ Terminación elegante falló para proceso %%p
        
        REM Intentar terminación forzada
        call :force_shutdown %%p "proceso"
        if %errorlevel% equ 0 (
            echo ✅ Proceso %%p terminado forzadamente
            set /a stopped_count+=1
        ) else (
            echo ❌ No se pudo terminar proceso %%p
            set /a failed_count+=1
        )
    )
)

REM Limpiar archivos PID
call :cleanup_pid_files

REM Resumen de resultados
echo.
echo 📊 RESUMEN DE PARADA:
echo ✅ Procesos detenidos: %stopped_count%
if %failed_count% gtr 0 (
    echo ❌ Procesos fallidos: %failed_count%
)

call :log "INFO" "Parada completada: %stopped_count% exitosos, %failed_count% fallidos"

exit /b %failed_count%

REM Función principal
:main
call :show_edutech_banner

call :log "INFO" "Iniciando proceso de parada del Support Service"

REM Mostrar información actual
call :show_pre_shutdown_info
echo.

REM Confirmar parada si es interactivo
echo ¿Confirmas que deseas detener el Support Service? (s/N):
set /p response=
if /i not "%response%"=="s" (
    call :show_info_banner "Operación cancelada por el usuario"
    call :log "INFO" "Parada cancelada por el usuario"
    exit /b 0
)

REM Detener servicio
call :stop_service
set stop_result=%errorlevel%

if %stop_result% equ 0 (
    echo.
    
    REM Verificar que se detuvo correctamente
    call :verify_shutdown
    if %errorlevel% equ 0 (
        call :show_success_banner "🎉 SUPPORT SERVICE DETENIDO EXITOSAMENTE 🎉"
        call :log "INFO" "Support Service detenido exitosamente"
        
        echo.
        echo 📋 COMANDOS ÚTILES:
        echo • Reiniciar servicio: scripts\windows\iniciar.bat
        echo • Ver logs: type %ROOT_DIR%\logs\service.out
        echo • Verificar estado: scripts\windows\verificar-estado.bat
    ) else (
        call :show_warning_banner "Servicio detenido con advertencias"
        call :log "WARNING" "Servicio detenido pero con procesos residuales"
        exit /b 1
    )
) else (
    call :show_error_banner "Error al detener el servicio"
    call :log "ERROR" "Error durante la parada del servicio"
    exit /b 1
)
goto :eof

REM Ejecutar función principal
call :main
