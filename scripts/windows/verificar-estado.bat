@echo off
setlocal enabledelayedexpansion

:: verificar-estado.bat - Diagnóstico completo del servicio EduTech Support
:: Equivalente al script verificar-estado.sh para Windows

echo.
echo ================================================
echo           DIAGNÓSTICO DEL SISTEMA
echo        EduTech Support Service
echo ================================================
echo.

:: Configuración por defecto
set "SERVICE_NAME=edutech-support-service"
set "DEFAULT_PORT=8083"
set "JAR_PATH=target\edutech-support-service-0.0.1-SNAPSHOT.jar"
set "HEALTH_ENDPOINT=http://localhost:%DEFAULT_PORT%/health"

:: Cargar configuración del .env si existe
if exist .env (
    echo [INFO] Cargando configuración desde .env...
    for /f "usebackq tokens=1,2 delims==" %%i in (".env") do (
        if /i "%%i"=="PORT" set "DEFAULT_PORT=%%j"
        if /i "%%i"=="SERVICE_NAME" set "SERVICE_NAME=%%j"
    )
    set "HEALTH_ENDPOINT=http://localhost:!DEFAULT_PORT!/health"
)

echo [INFO] Iniciando diagnóstico del servicio...
echo [INFO] Puerto configurado: %DEFAULT_PORT%
echo [INFO] Endpoint de salud: %HEALTH_ENDPOINT%
echo.

:: 1. Verificar si el puerto está en uso
echo ========================================
echo 1. VERIFICACIÓN DE PUERTO
echo ========================================
echo Verificando puerto %DEFAULT_PORT%...

netstat -an | findstr ":%DEFAULT_PORT%" >nul 2>&1
if %errorlevel% == 0 (
    echo [✓] Puerto %DEFAULT_PORT% está en uso
    echo [INFO] Procesos utilizando el puerto:
    netstat -ano | findstr ":%DEFAULT_PORT%" | findstr "LISTEN"
    echo.
    
    :: Obtener PID del proceso
    for /f "tokens=5" %%i in ('netstat -ano ^| findstr ":%DEFAULT_PORT%" ^| findstr "LISTEN"') do (
        set "PROCESS_PID=%%i"
        echo [INFO] PID del proceso: !PROCESS_PID!
        
        :: Obtener información del proceso
        tasklist /fi "PID eq !PROCESS_PID!" /fo table 2>nul | findstr /v "INFO:"
    )
) else (
    echo [✗] Puerto %DEFAULT_PORT% NO está en uso
    echo [WARNING] El servicio podría no estar ejecutándose
)
echo.

:: 2. Verificar archivo JAR
echo ========================================
echo 2. VERIFICACIÓN DE ARCHIVOS
echo ========================================
if exist "%JAR_PATH%" (
    echo [✓] Archivo JAR encontrado: %JAR_PATH%
    for %%i in ("%JAR_PATH%") do (
        echo [INFO] Tamaño: %%~zi bytes
        echo [INFO] Fecha: %%~ti
    )
) else (
    echo [✗] Archivo JAR NO encontrado: %JAR_PATH%
    echo [WARNING] Ejecutar 'mvn clean package' para compilar
)
echo.

:: Verificar pom.xml
if exist "pom.xml" (
    echo [✓] Archivo pom.xml encontrado
) else (
    echo [✗] Archivo pom.xml NO encontrado
    echo [ERROR] Este no parece ser un proyecto Maven válido
)
echo.

:: Verificar application.properties
if exist "src\main\resources\application.properties" (
    echo [✓] Archivo application.properties encontrado
    echo [INFO] Configuración de puerto en application.properties:
    findstr "server.port" "src\main\resources\application.properties" 2>nul
    if %errorlevel% neq 0 (
        echo [INFO] Puerto no especificado (usando por defecto 8080)
    )
) else (
    echo [✗] Archivo application.properties NO encontrado
)
echo.

:: 3. Verificar conectividad del servicio
echo ========================================
echo 3. VERIFICACIÓN DE CONECTIVIDAD
echo ========================================
echo Probando conectividad al endpoint de salud...

:: Usar PowerShell para hacer la petición HTTP (más confiable que curl en Windows)
powershell -Command "try { $response = Invoke-WebRequest -Uri '%HEALTH_ENDPOINT%' -TimeoutSec 5 -UseBasicParsing; Write-Host '[✓] Servicio responde correctamente'; Write-Host '[INFO] Status:' $response.StatusCode; Write-Host '[INFO] Contenido:' $response.Content } catch { Write-Host '[✗] Servicio NO responde'; Write-Host '[ERROR]' $_.Exception.Message }" 2>nul
if %errorlevel% neq 0 (
    echo [WARNING] No se pudo verificar el endpoint de salud
    echo [INFO] Intentando ping básico al puerto...
    
    :: Verificación alternativa con telnet (si está disponible)
    echo exit | telnet localhost %DEFAULT_PORT% 2>nul | findstr "Connected" >nul
    if %errorlevel% == 0 (
        echo [✓] Puerto responde a conexiones básicas
    ) else (
        echo [✗] Puerto no responde a conexiones
    )
)
echo.

:: 4. Verificar procesos Java
echo ========================================
echo 4. PROCESOS JAVA
echo ========================================
echo Procesos Java en ejecución:
tasklist /fi "imagename eq java.exe" /fo table 2>nul | findstr /v "INFO:"
if %errorlevel% neq 0 (
    echo [INFO] No se encontraron procesos Java en ejecución
)
echo.

:: Verificar procesos relacionados con nuestro servicio
echo Procesos relacionados con '%SERVICE_NAME%':
tasklist /v 2>nul | findstr /i "%SERVICE_NAME%"
if %errorlevel% neq 0 (
    echo [INFO] No se encontraron procesos específicos del servicio
)
echo.

:: 5. Verificar variables de entorno Java
echo ========================================
echo 5. ENTORNO JAVA
echo ========================================
if defined JAVA_HOME (
    echo [✓] JAVA_HOME: %JAVA_HOME%
    if exist "%JAVA_HOME%\bin\java.exe" (
        echo [✓] Ejecutable Java encontrado
        echo [INFO] Versión de Java:
        "%JAVA_HOME%\bin\java" -version 2>&1 | head -3
    ) else (
        echo [✗] Ejecutable Java NO encontrado en JAVA_HOME
    )
) else (
    echo [WARNING] JAVA_HOME no está definido
    echo [INFO] Verificando Java en PATH...
    java -version >nul 2>&1
    if %errorlevel% == 0 (
        echo [✓] Java disponible en PATH
        java -version 2>&1 | head -3
    ) else (
        echo [✗] Java NO está disponible
        echo [ERROR] Instalar Java JDK 11 o superior
    )
)
echo.

:: 6. Verificar Maven
echo ========================================
echo 6. HERRAMIENTAS DE DESARROLLO
echo ========================================
mvn --version >nul 2>&1
if %errorlevel% == 0 (
    echo [✓] Maven está disponible
    mvn --version | head -1
) else (
    echo [✗] Maven NO está disponible
    echo [WARNING] Instalar Apache Maven para compilar el proyecto
)
echo.

:: 7. Verificar logs
echo ========================================
echo 7. ARCHIVOS DE LOG
echo ========================================
if exist "logs" (
    echo [✓] Directorio de logs encontrado
    echo [INFO] Archivos de log recientes:
    dir /b /o-d "logs\*.log" 2>nul | head -5
    
    :: Mostrar últimas líneas del log principal si existe
    if exist "logs\support-audit.log" (
        echo.
        echo [INFO] Últimas 5 líneas del log principal:
        powershell -Command "Get-Content 'logs\support-audit.log' -Tail 5" 2>nul
    )
) else (
    echo [INFO] Directorio de logs no encontrado
)
echo.

:: 8. Verificar memoria y recursos del sistema
echo ========================================
echo 8. RECURSOS DEL SISTEMA
echo ========================================
echo [INFO] Uso de memoria:
wmic computersystem get TotalPhysicalMemory /value | findstr "="
wmic OS get FreePhysicalMemory /value | findstr "="
echo.

echo [INFO] Uso de CPU por procesos Java:
tasklist /fi "imagename eq java.exe" /fo csv | findstr /v "INFO:" | head -3
echo.

:: 9. Resumen final
echo ========================================
echo 9. RESUMEN DEL DIAGNÓSTICO
echo ========================================
echo [INFO] Diagnóstico completado a las %date% %time%
echo.

:: Determinar estado general
netstat -an | findstr ":%DEFAULT_PORT%" >nul 2>&1
if %errorlevel% == 0 (
    echo [✓] ESTADO GENERAL: SERVICIO PARECE ESTAR EJECUTÁNDOSE
    echo [RECOMENDACIÓN] Verificar logs para errores
) else (
    echo [✗] ESTADO GENERAL: SERVICIO NO ESTÁ EJECUTÁNDOSE
    echo [RECOMENDACIÓN] Ejecutar scripts\windows\iniciar.bat
)
echo.

:: Verificar si hay algún archivo PID
if exist "app.pid" (
    set /p STORED_PID=<app.pid
    echo [INFO] PID almacenado: !STORED_PID!
    tasklist /fi "PID eq !STORED_PID!" /fo table 2>nul | findstr "!STORED_PID!" >nul
    if %errorlevel% == 0 (
        echo [✓] Proceso con PID almacenado está activo
    ) else (
        echo [WARNING] Proceso con PID almacenado no está activo
        echo [RECOMENDACIÓN] Limpiar archivo app.pid
    )
)

echo.
echo ================================================
echo       DIAGNÓSTICO COMPLETADO
echo ================================================
echo.

pause
endlocal
