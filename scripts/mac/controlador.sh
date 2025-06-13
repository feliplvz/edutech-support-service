#!/bin/bash
# =============================================================================
# EduTech - Script Master de Control (macOS/Linux) - Support Service
# =============================================================================
# Descripción: Script empresarial para gestionar el ciclo completo de desarrollo
#              del Microservicio de Soporte EduTech
# Autor: Equipo de Desarrollo EduTech
# Versión: 1.0.0
# Plataforma: macOS/Linux/Unix
# =============================================================================

set -euo pipefail

# Configuración
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
readonly VERSION="1.0.0"

# Importar banner
if [ -f "$ROOT_DIR/scripts/banner.sh" ]; then
    source "$ROOT_DIR/scripts/banner.sh"
fi

# Funciones de utilidad
log() {
    local level="$1"
    shift
    local message="$*"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" | tee -a "$ROOT_DIR/logs/controlador.log"
}

print_separator() {
    echo -e "${CYAN}${BOLD}══════════════════════════════════════════════════════════════════════════════════${NC}"
}

# Función para mostrar el menú principal
show_main_menu() {
    show_edutech_banner
    show_operation_banner "🎮 CONTROLADOR MAESTRO SUPPORT SERVICE" "Centro de comando unificado v${VERSION}"
    
    echo -e "${WHITE}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${YELLOW}${BOLD}🔧 CONFIGURACIÓN${NC} ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}╠═══════════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN} 1)${NC} configurar      - 🛠️  Configurar entorno de desarrollo        ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN} 2)${NC} variables       - ⚙️  Gestionar variables de entorno            ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC}                                                                          ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${YELLOW}${BOLD}🚀 CICLO DE VIDA${NC} ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}╠═══════════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN} 3)${NC} iniciar         - 🚀 Iniciar el microservicio                  ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN} 4)${NC} detener         - 🛑 Detener el microservicio                  ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN} 5)${NC} reiniciar       - 🔄 Reiniciar el microservicio                ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN} 6)${NC} estado          - 🔍 Verificar estado del servicio             ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC}                                                                          ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${YELLOW}${BOLD}🔨 COMPILACIÓN & PRUEBAS${NC} ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}╠═══════════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN} 7)${NC} compilar        - 🔨 Compilar la aplicación                    ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN} 8)${NC} pruebas         - 🧪 Ejecutar pruebas unitarias               ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN} 9)${NC} empaquetar      - 📦 Crear paquete desplegable                ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN}10)${NC} limpiar         - 🧹 Limpiar artefactos de compilación        ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC}                                                                          ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${YELLOW}${BOLD}📊 MONITOREO & LOGS${NC} ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}╠═══════════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN}11)${NC} logs            - 📋 Ver logs de la aplicación                ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN}12)${NC} salud           - 🏥 Verificar endpoints de salud             ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN}13)${NC} metricas        - 📈 Ver métricas del sistema                 ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN}14)${NC} bd              - 🗄️ Verificar conectividad de BD             ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC}                                                                          ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${YELLOW}${BOLD}🔧 HERRAMIENTAS DEV${NC} ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}╠═══════════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN}15)${NC} dependencias    - 📦 Gestionar dependencias Maven             ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN}16)${NC} postman         - 📮 Operaciones con Postman                  ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN}17)${NC} info            - ℹ️  Información del proyecto                 ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${GREEN}18)${NC} ayuda           - ❓ Ayuda y documentación                    ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC}                                                                          ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}║${NC} ${RED}${BOLD} 0)${NC} salir           - 🚪 Salir del controlador                  ${WHITE}${BOLD}║${NC}"
    echo -e "${WHITE}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Funciones para cada operación
function_configurar() {
    show_operation_banner "⚙️ CONFIGURANDO ENTORNO" "Ejecutando configuración del entorno de desarrollo..."
    if [ -f "$SCRIPT_DIR/configurar.sh" ]; then
        "$SCRIPT_DIR/configurar.sh"
    else
        show_error_banner "Script configurar.sh no encontrado"
    fi
}

function_variables() {
    show_operation_banner "⚙️ GESTIÓN DE VARIABLES" "Mostrando variables de entorno actuales..."
    if [ -f "$ROOT_DIR/.env" ]; then
        echo -e "${CYAN}Variables definidas en .env:${NC}"
        grep -v '^#' "$ROOT_DIR/.env" | grep -v '^$' | while IFS='=' read -r key value; do
            if [[ $key == *"PASSWORD"* ]] || [[ $key == *"SECRET"* ]]; then
                echo -e "${GREEN}$key${NC}=${YELLOW}****${NC}"
            else
                echo -e "${GREEN}$key${NC}=${YELLOW}$value${NC}"
            fi
        done
    else
        show_error_banner "Archivo .env no encontrado"
    fi
}

function_iniciar() {
    show_operation_banner "🚀 INICIANDO SERVICIO" "Iniciando Support Service..."
    if [ -f "$SCRIPT_DIR/iniciar.sh" ]; then
        "$SCRIPT_DIR/iniciar.sh"
    else
        show_error_banner "Script iniciar.sh no encontrado"
    fi
}

function_detener() {
    show_operation_banner "🛑 DETENIENDO SERVICIO" "Deteniendo Support Service..."
    if [ -f "$SCRIPT_DIR/detener.sh" ]; then
        "$SCRIPT_DIR/detener.sh"
    else
        show_error_banner "Script detener.sh no encontrado"
    fi
}

function_reiniciar() {
    show_operation_banner "🔄 REINICIANDO SERVICIO" "Reiniciando Support Service..."
    function_detener
    sleep 3
    function_iniciar
}

function_estado() {
    show_operation_banner "🔍 VERIFICANDO ESTADO" "Verificando estado del Support Service..."
    if [ -f "$SCRIPT_DIR/verificar-estado.sh" ]; then
        "$SCRIPT_DIR/verificar-estado.sh"
    else
        show_error_banner "Script verificar-estado.sh no encontrado"
    fi
}

function_compilar() {
    show_operation_banner "🔨 COMPILANDO" "Compilando la aplicación..."
    cd "$ROOT_DIR"
    mvn clean compile
}

function_pruebas() {
    show_operation_banner "🧪 EJECUTANDO PRUEBAS" "Ejecutando pruebas unitarias..."
    cd "$ROOT_DIR"
    mvn test
}

function_empaquetar() {
    show_operation_banner "📦 EMPAQUETANDO" "Creando paquete desplegable..."
    cd "$ROOT_DIR"
    mvn clean package -DskipTests
}

function_limpiar() {
    show_operation_banner "🧹 LIMPIANDO" "Limpiando artefactos de compilación..."
    cd "$ROOT_DIR"
    mvn clean
}

function_logs() {
    show_operation_banner "📋 LOGS DE APLICACIÓN" "Mostrando logs recientes..."
    if [ -f "$ROOT_DIR/logs/support-audit.log" ]; then
        tail -50 "$ROOT_DIR/logs/support-audit.log"
    else
        echo "No se encontraron logs de la aplicación"
    fi
}

function_salud() {
    show_operation_banner "🏥 VERIFICANDO SALUD" "Verificando endpoints de salud..."
    echo "Verificando http://localhost:8084/actuator/health..."
    if curl -s http://localhost:8084/actuator/health > /dev/null; then
        show_success_banner "Servicio respondiendo correctamente"
        curl -s http://localhost:8084/actuator/health | jq '.' 2>/dev/null || curl -s http://localhost:8084/actuator/health
    else
        show_error_banner "Servicio no responde en puerto 8084"
    fi
}

function_metricas() {
    show_operation_banner "📈 MÉTRICAS DEL SISTEMA" "Obteniendo métricas del sistema..."
    echo "Verificando http://localhost:8084/actuator/metrics..."
    if curl -s http://localhost:8084/actuator/metrics > /dev/null; then
        curl -s http://localhost:8084/actuator/metrics | jq '.' 2>/dev/null || curl -s http://localhost:8084/actuator/metrics
    else
        show_error_banner "No se pueden obtener métricas - servicio no disponible"
    fi
}

function_bd() {
    show_operation_banner "🗄️ VERIFICANDO BASE DE DATOS" "Verificando conectividad con PostgreSQL..."
    if [ -f "$ROOT_DIR/.env" ]; then
        source "$ROOT_DIR/.env"
        echo "Verificando conexión a: $DATABASE_URL"
        # Aquí podrías agregar una verificación más específica de la BD
        show_info_banner "Variables de BD cargadas correctamente"
    else
        show_error_banner "Archivo .env no encontrado"
    fi
}

function_dependencias() {
    show_operation_banner "📦 DEPENDENCIAS MAVEN" "Mostrando información de dependencias..."
    cd "$ROOT_DIR"
    mvn dependency:tree
}

function_postman() {
    show_operation_banner "📮 POSTMAN" "Información sobre colecciones Postman..."
    if [ -f "$ROOT_DIR/EduTech-Support-Service.postman_collection.json" ]; then
        show_success_banner "Colección Postman encontrada: EduTech-Support-Service.postman_collection.json"
    else
        show_warning_banner "No se encontró colección Postman"
    fi
}

function_info() {
    show_project_info
}

function_ayuda() {
    show_operation_banner "❓ AYUDA Y DOCUMENTACIÓN" "Información de ayuda del controlador..."
    echo -e "${CYAN}Uso del controlador:${NC}"
    echo -e "${WHITE}• Ejecuta: ${GREEN}./scripts/mac/controlador.sh${NC}"
    echo -e "${WHITE}• Selecciona una opción del menú${NC}"
    echo -e "${WHITE}• También puedes pasar parámetros directamente:${NC}"
    echo -e "${GREEN}  ./controlador.sh iniciar${NC}"
    echo -e "${GREEN}  ./controlador.sh estado${NC}"
    echo -e "${GREEN}  ./controlador.sh detener${NC}"
}

# Función principal
main() {
    # Crear directorio de logs si no existe
    mkdir -p "$ROOT_DIR/logs"
    
    # Si se pasa un parámetro, ejecutar directamente
    if [ $# -gt 0 ]; then
        case "$1" in
            "configurar"|"1") function_configurar ;;
            "variables"|"2") function_variables ;;
            "iniciar"|"3") function_iniciar ;;
            "detener"|"4") function_detener ;;
            "reiniciar"|"5") function_reiniciar ;;
            "estado"|"6") function_estado ;;
            "compilar"|"7") function_compilar ;;
            "pruebas"|"8") function_pruebas ;;
            "empaquetar"|"9") function_empaquetar ;;
            "limpiar"|"10") function_limpiar ;;
            "logs"|"11") function_logs ;;
            "salud"|"12") function_salud ;;
            "metricas"|"13") function_metricas ;;
            "bd"|"14") function_bd ;;
            "dependencias"|"15") function_dependencias ;;
            "postman"|"16") function_postman ;;
            "info"|"17") function_info ;;
            "ayuda"|"18") function_ayuda ;;
            *) 
                show_error_banner "Opción no válida: $1"
                function_ayuda
                ;;
        esac
        return
    fi
    
    # Menú interactivo
    while true; do
        show_main_menu
        echo -e "${CYAN}${BOLD}Selecciona una opción (0-18):${NC} "
        read -r option
        
        case "$option" in
            "1"|"configurar") function_configurar ;;
            "2"|"variables") function_variables ;;
            "3"|"iniciar") function_iniciar ;;
            "4"|"detener") function_detener ;;
            "5"|"reiniciar") function_reiniciar ;;
            "6"|"estado") function_estado ;;
            "7"|"compilar") function_compilar ;;
            "8"|"pruebas") function_pruebas ;;
            "9"|"empaquetar") function_empaquetar ;;
            "10"|"limpiar") function_limpiar ;;
            "11"|"logs") function_logs ;;
            "12"|"salud") function_salud ;;
            "13"|"metricas") function_metricas ;;
            "14"|"bd") function_bd ;;
            "15"|"dependencias") function_dependencias ;;
            "16"|"postman") function_postman ;;
            "17"|"info") function_info ;;
            "18"|"ayuda") function_ayuda ;;
            "0"|"salir")
                show_success_banner "¡Hasta luego! 👋"
                exit 0
                ;;
            *)
                show_error_banner "Opción no válida. Por favor selecciona una opción entre 0-18."
                read -p "Presiona Enter para continuar..."
                ;;
        esac
        
        echo ""
        read -p "Presiona Enter para volver al menú principal..."
    done
}

# Ejecutar función principal
main "$@"
