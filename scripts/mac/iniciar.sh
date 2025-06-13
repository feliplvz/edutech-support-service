#!/bin/bash
# =============================================================================
# EduTech - Script de Inicio (macOS/Linux) - Support Service
# =============================================================================
# Descripción: Inicio avanzado del Microservicio de Soporte EduTech
#              con verificaciones completas y monitoreo en tiempo real
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
readonly MAX_WAIT_TIME=120
readonly LOG_FILE="${ROOT_DIR}/logs/inicio.log"
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

# Función para verificar si el puerto está en uso
check_port() {
    local port="$1"
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        return 0  # Puerto en uso
    else
        return 1  # Puerto libre
    fi
}

# Función para obtener el PID del proceso en el puerto
get_port_pid() {
    local port="$1"
    lsof -Pi :$port -sTCP:LISTEN -t 2>/dev/null
}

# Función para detener procesos existentes
stop_existing_service() {
    show_operation_banner "🛑 VERIFICANDO PROCESOS EXISTENTES" "Buscando instancias del servicio en ejecución..."
    
    if check_port "$SERVICE_PORT"; then
        local existing_pid=$(get_port_pid "$SERVICE_PORT")
        show_warning_banner "Servicio detectado en puerto $SERVICE_PORT (PID: $existing_pid)"
        
        echo -e "${YELLOW}¿Deseas detener el servicio existente? (s/N): ${NC}"
        read -r response
        
        if [[ "$response" =~ ^[Ss]$ ]]; then
            log "INFO" "Deteniendo servicio existente (PID: $existing_pid)"
            kill "$existing_pid" 2>/dev/null || true
            sleep 3
            
            # Verificar si el proceso aún existe
            if kill -0 "$existing_pid" 2>/dev/null; then
                log "WARNING" "Forzando terminación del proceso $existing_pid"
                kill -9 "$existing_pid" 2>/dev/null || true
            fi
            
            show_success_banner "Servicio anterior detenido correctamente"
        else
            show_error_banner "No se puede iniciar - puerto $SERVICE_PORT ocupado"
            exit 1
        fi
    else
        show_success_banner "Puerto $SERVICE_PORT disponible"
    fi
}

# Función para verificar prerequisitos
check_prerequisites() {
    show_operation_banner "🔍 VERIFICANDO PREREQUISITOS" "Validando entorno de ejecución..."
    
    local errors=0
    
    # Verificar Java
    if ! command -v java >/dev/null 2>&1; then
        show_error_banner "Java no encontrado"
        errors=$((errors + 1))
    else
        local java_version=$(java -version 2>&1 | head -n 1)
        log "INFO" "Java detectado: $java_version"
    fi
    
    # Verificar Maven
    if ! command -v mvn >/dev/null 2>&1; then
        show_error_banner "Maven no encontrado"
        errors=$((errors + 1))
    else
        local maven_version=$(mvn -version 2>/dev/null | head -n 1)
        log "INFO" "Maven detectado: $maven_version"
    fi
    
    # Verificar archivo .env
    if [ ! -f "$ROOT_DIR/.env" ]; then
        show_error_banner "Archivo .env no encontrado"
        errors=$((errors + 1))
    else
        log "INFO" "Archivo .env encontrado"
    fi
    
    # Verificar pom.xml
    if [ ! -f "$ROOT_DIR/pom.xml" ]; then
        show_error_banner "Archivo pom.xml no encontrado"
        errors=$((errors + 1))
    else
        log "INFO" "Archivo pom.xml encontrado"
    fi
    
    if [ $errors -gt 0 ]; then
        show_error_banner "Faltan $errors prerequisitos. Ejecuta ./scripts/mac/configurar.sh"
        exit 1
    fi
    
    show_success_banner "Todos los prerequisitos están disponibles"
}

# Función para cargar variables de entorno
load_environment() {
    show_operation_banner "⚙️ CARGANDO VARIABLES DE ENTORNO" "Configurando variables desde .env..."
    
    if [ -f "$ROOT_DIR/.env" ]; then
        set -a  # Exportar automáticamente todas las variables
        source "$ROOT_DIR/.env"
        set +a
        
        log "INFO" "Variables de entorno cargadas desde .env"
        echo -e "${GREEN}✅ DATABASE_URL: ${DATABASE_URL}${NC}"
        echo -e "${GREEN}✅ DATABASE_USERNAME: ${DATABASE_USERNAME}${NC}"
        echo -e "${GREEN}✅ DATABASE_PASSWORD: ****${NC}"
        
        show_success_banner "Variables de entorno cargadas correctamente"
    else
        show_error_banner "No se pudo cargar .env"
        exit 1
    fi
}

# Función para compilar el proyecto
compile_project() {
    show_operation_banner "🔨 COMPILANDO PROYECTO" "Compilando y empaquetando aplicación..."
    
    cd "$ROOT_DIR"
    
    log "INFO" "Iniciando compilación Maven"
    
    if mvn clean compile -q; then
        log "INFO" "Compilación exitosa"
        show_success_banner "Compilación completada"
    else
        show_error_banner "Error en la compilación"
        log "ERROR" "Falló la compilación Maven"
        exit 1
    fi
}

# Función para iniciar el servicio
start_service() {
    show_operation_banner "🚀 INICIANDO SERVICIO" "Ejecutando Support Service..."
    
    cd "$ROOT_DIR"
    
    log "INFO" "Iniciando Support Service en puerto $SERVICE_PORT"
    
    # Iniciar el servicio en background y capturar el PID
    nohup mvn spring-boot:run > "${ROOT_DIR}/logs/service.out" 2>&1 &
    local service_pid=$!
    
    # Guardar PID
    echo "$service_pid" > "$PID_FILE"
    log "INFO" "Servicio iniciado con PID: $service_pid"
    
    echo -e "${CYAN}🚀 Servicio iniciandose...${NC}"
    echo -e "${CYAN}📋 PID: $service_pid${NC}"
    echo -e "${CYAN}📁 Logs: ${ROOT_DIR}/logs/service.out${NC}"
    echo -e "${CYAN}🌐 URL: http://localhost:$SERVICE_PORT${NC}"
}

# Función para verificar salud del servicio
wait_for_health() {
    show_operation_banner "🏥 VERIFICANDO SALUD DEL SERVICIO" "Esperando que el servicio esté listo..."
    
    local wait_time=0
    local health_ok=false
    
    echo -e "${CYAN}Verificando salud en: $HEALTH_ENDPOINT${NC}"
    
    while [ $wait_time -lt $MAX_WAIT_TIME ]; do
        if curl -s "$HEALTH_ENDPOINT" >/dev/null 2>&1; then
            health_ok=true
            break
        fi
        
        echo -e "${YELLOW}⏳ Esperando... (${wait_time}s/${MAX_WAIT_TIME}s)${NC}"
        sleep 5
        wait_time=$((wait_time + 5))
    done
    
    if [ "$health_ok" = true ]; then
        local health_response=$(curl -s "$HEALTH_ENDPOINT" 2>/dev/null)
        show_success_banner "Servicio iniciado correctamente"
        
        echo -e "${GREEN}💚 Estado de salud:${NC}"
        echo "$health_response" | jq '.' 2>/dev/null || echo "$health_response"
        
        log "INFO" "Servicio iniciado y saludable en ${wait_time}s"
        return 0
    else
        show_error_banner "Servicio no responde después de ${MAX_WAIT_TIME}s"
        log "ERROR" "Timeout esperando respuesta del servicio"
        return 1
    fi
}

# Función para mostrar información del servicio
show_service_info() {
    local pid=$(cat "$PID_FILE" 2>/dev/null || echo "N/A")
    local status="🟢 ACTIVO"
    
    show_service_status "$status" "$SERVICE_PORT" "$pid"
    
    echo -e "\n${CYAN}${BOLD}🔗 ENDPOINTS DISPONIBLES:${NC}"
    echo -e "${WHITE}🏥 Health Check: ${GREEN}http://localhost:$SERVICE_PORT/actuator/health${NC}"
    echo -e "${WHITE}📊 Métricas: ${GREEN}http://localhost:$SERVICE_PORT/actuator/metrics${NC}"
    echo -e "${WHITE}🎫 API Tickets: ${GREEN}http://localhost:$SERVICE_PORT/api/tickets${NC}"
    echo -e "${WHITE}📂 API Categorías: ${GREEN}http://localhost:$SERVICE_PORT/api/categories${NC}"
    echo -e "${WHITE}❓ API FAQs: ${GREEN}http://localhost:$SERVICE_PORT/api/faqs${NC}"
    echo -e "${WHITE}💬 API Mensajes: ${GREEN}http://localhost:$SERVICE_PORT/api/messages${NC}"
    
    echo -e "\n${CYAN}${BOLD}📋 COMANDOS ÚTILES:${NC}"
    echo -e "${WHITE}• Ver logs: ${YELLOW}tail -f ${ROOT_DIR}/logs/service.out${NC}"
    echo -e "${WHITE}• Detener servicio: ${YELLOW}./scripts/mac/detener.sh${NC}"
    echo -e "${WHITE}• Verificar estado: ${YELLOW}./scripts/mac/verificar-estado.sh${NC}"
    echo -e "${WHITE}• Ver métricas: ${YELLOW}curl http://localhost:$SERVICE_PORT/actuator/metrics${NC}"
}

# Función principal
main() {
    show_edutech_banner
    
    log "INFO" "Iniciando proceso de arranque del Support Service"
    
    # Ejecutar todas las verificaciones y pasos
    check_prerequisites
    echo ""
    
    stop_existing_service
    echo ""
    
    load_environment
    echo ""
    
    compile_project
    echo ""
    
    start_service
    echo ""
    
    if wait_for_health; then
        echo ""
        show_service_info
        echo ""
        
        show_success_banner "🎉 SUPPORT SERVICE INICIADO EXITOSAMENTE 🎉"
        log "INFO" "Support Service iniciado exitosamente"
    else
        show_error_banner "Error al iniciar el servicio"
        log "ERROR" "Error al iniciar el Support Service"
        
        # Mostrar últimas líneas del log para debugging
        echo -e "\n${RED}${BOLD}📋 Últimas líneas del log:${NC}"
        tail -20 "${ROOT_DIR}/logs/service.out" 2>/dev/null || echo "No hay logs disponibles"
        
        exit 1
    fi
}

# Ejecutar función principal
main "$@"
