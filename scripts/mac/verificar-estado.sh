#!/bin/bash
# =============================================================================
# EduTech - Script de Verificación de Estado (macOS/Linux) - Support Service
# =============================================================================
# Descripción: Diagnóstico completo del estado del Microservicio de Soporte EduTech
#              con verificaciones de salud, conectividad y recursos
# Autor: Equipo de Desarrollo EduTech
# Versión: 1.0.0
# Plataforma: macOS/Linux/Unix
# =============================================================================

set -euo pipefail

# Importar banner
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

if [ -f "$ROOT_DIR/scripts/banner.sh" ]; then
    source "$ROOT_DIR/scripts/banner.sh"
fi

# Configuración
readonly SERVICE_NAME="Support Service"
readonly SERVICE_PORT="8084"
readonly HEALTH_ENDPOINT="http://localhost:${SERVICE_PORT}/actuator/health"
readonly METRICS_ENDPOINT="http://localhost:${SERVICE_PORT}/actuator/metrics"
readonly LOG_FILE="${ROOT_DIR}/logs/verificacion.log"
readonly PID_FILE="${ROOT_DIR}/logs/service.pid"

# Crear directorio de logs
mkdir -p "${ROOT_DIR}/logs"

# Función de logging
log() {
    local level="$1"
    shift
    local message="$*"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" | tee -a "${LOG_FILE}"
}

# Función para verificar conectividad HTTP
check_http_endpoint() {
    local url="$1"
    local timeout="${2:-5}"
    
    if command -v curl >/dev/null 2>&1; then
        curl -s --max-time "$timeout" "$url" >/dev/null 2>&1
    else
        # Fallback usando nc si curl no está disponible
        local host=$(echo "$url" | sed 's|.*://||' | cut -d: -f1)
        local port=$(echo "$url" | sed 's|.*://||' | cut -d: -f2 | cut -d/ -f1)
        nc -z "$host" "$port" 2>/dev/null
    fi
}

# Función para obtener información del proceso
get_process_info() {
    local pid="$1"
    if kill -0 "$pid" 2>/dev/null; then
        local cpu_mem=$(ps -p "$pid" -o %cpu,%mem --no-headers 2>/dev/null || echo "N/A N/A")
        local start_time=$(ps -p "$pid" -o lstart --no-headers 2>/dev/null || echo "N/A")
        local command=$(ps -p "$pid" -o command --no-headers 2>/dev/null || echo "N/A")
        
        echo "CPU: $(echo $cpu_mem | cut -d' ' -f1)% | MEM: $(echo $cpu_mem | cut -d' ' -f2)%"
        echo "Iniciado: $start_time"
        echo "Comando: $command"
        return 0
    else
        return 1
    fi
}

# Función para verificar estado del puerto
check_port_status() {
    show_operation_banner "🌐 VERIFICANDO PUERTO $SERVICE_PORT" "Comprobando disponibilidad del puerto..."
    
    if lsof -Pi :$SERVICE_PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
        local port_pid=$(lsof -Pi :$SERVICE_PORT -sTCP:LISTEN -t 2>/dev/null)
        local process_name=$(ps -p "$port_pid" -o comm= 2>/dev/null || echo "Desconocido")
        
        show_success_banner "Puerto $SERVICE_PORT en uso por PID $port_pid ($process_name)"
        
        echo -e "${CYAN}📊 Información del proceso:${NC}"
        if get_process_info "$port_pid"; then
            echo ""
        else
            echo -e "${RED}❌ No se pudo obtener información del proceso${NC}"
        fi
        
        log "INFO" "Puerto $SERVICE_PORT ocupado por PID $port_pid"
        return 0
    else
        show_warning_banner "Puerto $SERVICE_PORT no está en uso"
        log "WARNING" "Puerto $SERVICE_PORT libre"
        return 1
    fi
}

# Función para verificar endpoint de salud
check_health_endpoint() {
    show_operation_banner "🏥 VERIFICANDO ENDPOINT DE SALUD" "Comprobando $HEALTH_ENDPOINT..."
    
    if check_http_endpoint "$HEALTH_ENDPOINT"; then
        local health_response=$(curl -s "$HEALTH_ENDPOINT" 2>/dev/null || echo '{"status":"unknown"}')
        
        show_success_banner "Endpoint de salud respondiendo"
        
        echo -e "${CYAN}💚 Respuesta de salud:${NC}"
        if command -v jq >/dev/null 2>&1; then
            echo "$health_response" | jq '.'
        else
            echo "$health_response"
        fi
        
        # Verificar estado específico
        local status=$(echo "$health_response" | grep -o '"status":"[^"]*"' | cut -d'"' -f4 2>/dev/null || echo "unknown")
        if [ "$status" = "UP" ]; then
            echo -e "${GREEN}✅ Estado: SALUDABLE${NC}"
        else
            echo -e "${YELLOW}⚠️ Estado: $status${NC}"
        fi
        
        log "INFO" "Endpoint de salud OK - Estado: $status"
        return 0
    else
        show_error_banner "Endpoint de salud no responde"
        log "ERROR" "Endpoint de salud no disponible"
        return 1
    fi
}

# Función para verificar métricas
check_metrics_endpoint() {
    show_operation_banner "📈 VERIFICANDO MÉTRICAS" "Comprobando $METRICS_ENDPOINT..."
    
    if check_http_endpoint "$METRICS_ENDPOINT"; then
        show_success_banner "Endpoint de métricas disponible"
        
        # Obtener algunas métricas específicas
        local metrics_list=$(curl -s "$METRICS_ENDPOINT" 2>/dev/null | jq -r '.names[]' 2>/dev/null | head -10 || echo "No se pudieron obtener métricas")
        
        echo -e "${CYAN}📊 Métricas disponibles (primeras 10):${NC}"
        echo "$metrics_list"
        
        log "INFO" "Endpoint de métricas OK"
        return 0
    else
        show_warning_banner "Endpoint de métricas no disponible"
        log "WARNING" "Endpoint de métricas no responde"
        return 1
    fi
}

# Función para verificar procesos relacionados
check_related_processes() {
    show_operation_banner "🔍 VERIFICANDO PROCESOS RELACIONADOS" "Buscando procesos del Support Service..."
    
    local found_processes=0
    
    # Buscar por puerto
    local port_pids=$(lsof -Pi :$SERVICE_PORT -sTCP:LISTEN -t 2>/dev/null || true)
    if [ -n "$port_pids" ]; then
        echo -e "${GREEN}🌐 Procesos usando puerto $SERVICE_PORT:${NC}"
        for pid in $port_pids; do
            local cmd=$(ps -p "$pid" -o command= 2>/dev/null || echo "Comando no disponible")
            echo -e "${WHITE}  PID $pid: $cmd${NC}"
            found_processes=$((found_processes + 1))
        done
        echo ""
    fi
    
    # Buscar procesos Java/Spring Boot
    local java_pids=$(pgrep -f "spring-boot:run" 2>/dev/null || true)
    if [ -n "$java_pids" ]; then
        echo -e "${GREEN}☕ Procesos Java/Spring Boot:${NC}"
        for pid in $java_pids; do
            local cmd=$(ps -p "$pid" -o command= 2>/dev/null || echo "Comando no disponible")
            echo -e "${WHITE}  PID $pid: $cmd${NC}"
            found_processes=$((found_processes + 1))
        done
        echo ""
    fi
    
    # Buscar procesos Maven
    local maven_pids=$(pgrep -f "mvn" 2>/dev/null || true)
    if [ -n "$maven_pids" ]; then
        echo -e "${GREEN}📦 Procesos Maven:${NC}"
        for pid in $maven_pids; do
            local cmd=$(ps -p "$pid" -o command= 2>/dev/null || echo "Comando no disponible")
            echo -e "${WHITE}  PID $pid: $cmd${NC}"
            found_processes=$((found_processes + 1))
        done
        echo ""
    fi
    
    if [ $found_processes -eq 0 ]; then
        show_warning_banner "No se encontraron procesos relacionados"
        log "WARNING" "No hay procesos relacionados ejecutándose"
        return 1
    else
        show_success_banner "Encontrados $found_processes procesos relacionados"
        log "INFO" "Encontrados $found_processes procesos relacionados"
        return 0
    fi
}

# Función para verificar archivos de configuración
check_configuration_files() {
    show_operation_banner "📁 VERIFICANDO CONFIGURACIÓN" "Comprobando archivos de configuración..."
    
    local config_ok=true
    
    # Verificar .env
    if [ -f "$ROOT_DIR/.env" ]; then
        echo -e "${GREEN}✅ Archivo .env encontrado${NC}"
        
        # Verificar variables críticas
        local required_vars=("DATABASE_URL" "DATABASE_USERNAME" "DATABASE_PASSWORD")
        for var in "${required_vars[@]}"; do
            if grep -q "^$var=" "$ROOT_DIR/.env" 2>/dev/null; then
                echo -e "${GREEN}  ✅ $var configurada${NC}"
            else
                echo -e "${RED}  ❌ $var falta${NC}"
                config_ok=false
            fi
        done
    else
        echo -e "${RED}❌ Archivo .env no encontrado${NC}"
        config_ok=false
    fi
    
    # Verificar application.properties
    if [ -f "$ROOT_DIR/src/main/resources/application.properties" ]; then
        echo -e "${GREEN}✅ application.properties encontrado${NC}"
    else
        echo -e "${RED}❌ application.properties no encontrado${NC}"
        config_ok=false
    fi
    
    # Verificar pom.xml
    if [ -f "$ROOT_DIR/pom.xml" ]; then
        echo -e "${GREEN}✅ pom.xml encontrado${NC}"
    else
        echo -e "${RED}❌ pom.xml no encontrado${NC}"
        config_ok=false
    fi
    
    if $config_ok; then
        show_success_banner "Configuración válida"
        log "INFO" "Archivos de configuración OK"
        return 0
    else
        show_error_banner "Problemas en la configuración"
        log "ERROR" "Problemas en archivos de configuración"
        return 1
    fi
}

# Función para verificar logs
check_logs() {
    show_operation_banner "📋 VERIFICANDO LOGS" "Revisando archivos de log..."
    
    local logs_dir="$ROOT_DIR/logs"
    
    if [ -d "$logs_dir" ]; then
        echo -e "${GREEN}✅ Directorio de logs existe: $logs_dir${NC}"
        
        # Listar archivos de log
        local log_files=$(find "$logs_dir" -name "*.log" -o -name "*.out" 2>/dev/null || true)
        if [ -n "$log_files" ]; then
            echo -e "${CYAN}📄 Archivos de log encontrados:${NC}"
            while IFS= read -r log_file; do
                local size=$(du -h "$log_file" 2>/dev/null | cut -f1)
                local mod_time=$(stat -f "%Sm" "$log_file" 2>/dev/null || date)
                echo -e "${WHITE}  $(basename "$log_file"): $size (modificado: $mod_time)${NC}"
            done <<< "$log_files"
            
            # Mostrar últimas líneas del log principal si existe
            if [ -f "$ROOT_DIR/logs/service.out" ]; then
                echo -e "\n${CYAN}📋 Últimas 5 líneas del log principal:${NC}"
                tail -5 "$ROOT_DIR/logs/service.out" 2>/dev/null | while IFS= read -r line; do
                    echo -e "${WHITE}  $line${NC}"
                done
            fi
        else
            echo -e "${YELLOW}⚠️ No se encontraron archivos de log${NC}"
        fi
        
        log "INFO" "Verificación de logs completada"
        return 0
    else
        show_warning_banner "Directorio de logs no existe"
        log "WARNING" "Directorio de logs no encontrado"
        return 1
    fi
}

# Función para generar resumen de estado
generate_status_summary() {
    show_operation_banner "📊 RESUMEN DE ESTADO" "Generando resumen completo del servicio..."
    
    local service_running=false
    local health_ok=false
    local config_ok=false
    
    # Verificar si el servicio está corriendo
    if lsof -Pi :$SERVICE_PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
        service_running=true
    fi
    
    # Verificar salud
    if check_http_endpoint "$HEALTH_ENDPOINT" 2>/dev/null; then
        health_ok=true
    fi
    
    # Verificar configuración básica
    if [ -f "$ROOT_DIR/.env" ] && [ -f "$ROOT_DIR/pom.xml" ]; then
        config_ok=true
    fi
    
    # Mostrar resumen
    echo -e "${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║${NC} ${YELLOW}${BOLD}📊 RESUMEN DE ESTADO - SUPPORT SERVICE${NC} ${CYAN}${BOLD}║${NC}"
    echo -e "${CYAN}${BOLD}╠═══════════════════════════════════════════════════════════════════════════════════╣${NC}"
    
    # Estado del servicio
    if $service_running; then
        local pid=$(lsof -Pi :$SERVICE_PORT -sTCP:LISTEN -t 2>/dev/null)
        echo -e "${CYAN}${BOLD}║${NC} ${GREEN}🟢 Servicio: ACTIVO (Puerto $SERVICE_PORT, PID $pid)${NC} ${CYAN}${BOLD}║${NC}"
    else
        echo -e "${CYAN}${BOLD}║${NC} ${RED}🔴 Servicio: INACTIVO${NC} ${CYAN}${BOLD}║${NC}"
    fi
    
    # Estado de salud
    if $health_ok; then
        echo -e "${CYAN}${BOLD}║${NC} ${GREEN}💚 Salud: OK${NC} ${CYAN}${BOLD}║${NC}"
    else
        echo -e "${CYAN}${BOLD}║${NC} ${RED}💔 Salud: NO DISPONIBLE${NC} ${CYAN}${BOLD}║${NC}"
    fi
    
    # Estado de configuración
    if $config_ok; then
        echo -e "${CYAN}${BOLD}║${NC} ${GREEN}⚙️ Configuración: OK${NC} ${CYAN}${BOLD}║${NC}"
    else
        echo -e "${CYAN}${BOLD}║${NC} ${RED}⚙️ Configuración: PROBLEMAS${NC} ${CYAN}${BOLD}║${NC}"
    fi
    
    # Información adicional
    echo -e "${CYAN}${BOLD}║${NC} ${WHITE}🕒 Verificado: $(date '+%Y-%m-%d %H:%M:%S')${NC} ${CYAN}${BOLD}║${NC}"
    echo -e "${CYAN}${BOLD}║${NC} ${WHITE}🏠 Directorio: $(basename "$ROOT_DIR")${NC} ${CYAN}${BOLD}║${NC}"
    
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    # Estado general
    if $service_running && $health_ok && $config_ok; then
        echo -e "\n${GREEN}${BOLD}🎉 ESTADO GENERAL: EXCELENTE${NC}"
        log "INFO" "Estado general: EXCELENTE"
    elif $service_running && $health_ok; then
        echo -e "\n${YELLOW}${BOLD}⚠️ ESTADO GENERAL: BUENO (revisar configuración)${NC}"
        log "INFO" "Estado general: BUENO"
    elif $service_running; then
        echo -e "\n${YELLOW}${BOLD}⚠️ ESTADO GENERAL: REGULAR (servicio activo pero con problemas)${NC}"
        log "WARNING" "Estado general: REGULAR"
    else
        echo -e "\n${RED}${BOLD}❌ ESTADO GENERAL: CRÍTICO (servicio inactivo)${NC}"
        log "ERROR" "Estado general: CRÍTICO"
    fi
}

# Función principal
main() {
    show_edutech_banner
    
    log "INFO" "Iniciando verificación de estado del Support Service"
    
    echo -e "${CYAN}${BOLD}🔍 Ejecutando diagnóstico completo del Support Service...${NC}\n"
    
    # Ejecutar todas las verificaciones
    check_port_status
    echo ""
    
    check_health_endpoint
    echo ""
    
    check_metrics_endpoint
    echo ""
    
    check_related_processes
    echo ""
    
    check_configuration_files
    echo ""
    
    check_logs
    echo ""
    
    # Generar resumen final
    generate_status_summary
    
    echo -e "\n${CYAN}${BOLD}📋 COMANDOS ÚTILES:${NC}"
    echo -e "${WHITE}• Iniciar servicio: ${YELLOW}./scripts/mac/iniciar.sh${NC}"
    echo -e "${WHITE}• Detener servicio: ${YELLOW}./scripts/mac/detener.sh${NC}"
    echo -e "${WHITE}• Ver logs en tiempo real: ${YELLOW}tail -f ${ROOT_DIR}/logs/service.out${NC}"
    echo -e "${WHITE}• Verificar salud: ${YELLOW}curl http://localhost:$SERVICE_PORT/actuator/health${NC}"
    echo -e "${WHITE}• Configurar entorno: ${YELLOW}./scripts/mac/configurar.sh${NC}"
    
    log "INFO" "Verificación de estado completada"
}

# Ejecutar función principal
main "$@"
