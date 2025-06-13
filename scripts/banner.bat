@echo off
REM =============================================================================
REM EduTech Banner - Banner profesional para Support Service (Windows)
REM =============================================================================

REM Configurar codificación para caracteres especiales
chcp 65001 >nul

REM Función para mostrar el banner principal de EduTech
:show_edutech_banner
cls
echo.
echo ╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                                                                               ║
echo ║   ███████╗██████╗ ██╗   ██╗████████╗███████╗ ██████╗██╗  ██╗                 ║
echo ║   ██╔════╝██╔══██╗██║   ██║╚══██╔══╝██╔════╝██╔════╝██║  ██║                 ║
echo ║   █████╗  ██║  ██║██║   ██║   ██║   █████╗  ██║     ███████║                 ║
echo ║   ██╔══╝  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║     ██╔══██║                 ║
echo ║   ███████╗██████╔╝╚██████╔╝   ██║   ███████╗╚██████╗██║  ██║                 ║
echo ║   ╚══════╝╚═════╝  ╚═════╝    ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝                  ║
echo ║                                                                               ║
echo ║              🎫 MICROSERVICIO DE SOPORTE Y TICKETS 🎫                          ║
echo ║                     💡 Support Service - v1.0.0 💡                             ║
echo ║                                                                               ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝
echo.
goto :eof

REM Función para mostrar banner de operación
:show_operation_banner
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════════╗
echo ║ %~1 ║
echo ╠══════════════════════════════════════════════════════════════════════════════════╣
echo ║ %~2 ║
echo ╚══════════════════════════════════════════════════════════════════════════════════╝
echo.
goto :eof

REM Función para mostrar banner de éxito
:show_success_banner
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════════╗
echo ║ ✅ %~1 ║
echo ╚══════════════════════════════════════════════════════════════════════════════════╝
echo.
goto :eof

REM Función para mostrar banner de error
:show_error_banner
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════════╗
echo ║ ❌ %~1 ║
echo ╚══════════════════════════════════════════════════════════════════════════════════╝
echo.
goto :eof

REM Función para mostrar banner de advertencia
:show_warning_banner
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════════╗
echo ║ ⚠️ %~1 ║
echo ╚══════════════════════════════════════════════════════════════════════════════════╝
echo.
goto :eof

REM Función para mostrar banner de información
:show_info_banner
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════════╗
echo ║ ℹ️ %~1 ║
echo ╚══════════════════════════════════════════════════════════════════════════════════╝
echo.
goto :eof

REM Función para mostrar el estado del servicio
:show_service_status
echo ╔═══════════════════════════════════════════════════════════════════════════════════╗
echo ║ 📊 ESTADO DEL SUPPORT SERVICE ║
echo ╠═══════════════════════════════════════════════════════════════════════════════════╣
echo ║ Estado: %~1 ║
echo ║ Puerto: %~2 ║
echo ║ PID: %~3 ║
echo ║ Fecha: %date% %time% ║
echo ╚═══════════════════════════════════════════════════════════════════════════════════╝
goto :eof

REM Función para mostrar información del proyecto
:show_project_info
echo ╔═══════════════════════════════════════════════════════════════════════════════════╗
echo ║ 📋 INFORMACIÓN DEL PROYECTO ║
echo ╠═══════════════════════════════════════════════════════════════════════════════════╣
echo ║ Proyecto: EduTech Support Service ║
echo ║ Versión: 1.0.0-SNAPSHOT ║
echo ║ Puerto: 8084 ║
echo ║ Framework: Spring Boot 3.5.0 ║
echo ║ Java: 17+ ║
echo ║ Base de datos: PostgreSQL ║
echo ╚═══════════════════════════════════════════════════════════════════════════════════╝
goto :eof
