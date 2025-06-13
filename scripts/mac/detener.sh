#!/bin/bash
# =============================================================================
# EduTech - Script de Stop (macOS/Linux) - Support Service
# =============================================================================
# Descripción: Terminación inteligente del Microservicio de Soporte EduTech
#              con métodos graceful y forzado según sea necesario
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
readonly LOG_FILE="${ROOT_DIR}/logs/detener.log"
readonly PID_FILE="${ROOT_DIR}/logs/service.pid"
readonly GRACEFUL_TIMEOUT=15

# Crear directorio de logs
mkdir -p "${ROOT_DIR}/logs"

# Función de logging
log() {
    local level="$1"
    shift
    local message="$*"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" | tee -a "${LOG_FILE}"
}

# Función para verificar si un proceso existe
process_exists() {
    local pid="$1"
    kill -0 "$pid" 2>/dev/null
}

# Función para obtener PIDs relacionados al servicio
get_service_pids() {
    local pids=()
    
    # Buscar por puerto
    local port_pid=$(lsof -Pi :$SERVICE_PORT -sTCP:LISTEN -t 2>/dev/null || true)
    if [ -n "$port_pid" ]; then
        pids+=($port_pid)
    fi
    
    # Buscar procesos Java con Spring Boot
    local java_pids=$(pgrep -f "spring-boot:run" 2>/dev/null || true)
    if [ -n "$java_pids" ]; then
        pids+=($java_pids)
    fi
    
    # Buscar procesos Maven
    local maven_pids=$(pgrep -f "mvn.*spring-boot:run" 2>/dev/null || true)
    if [ -n "$maven_pids" ]; then
        pids+=($maven_pids)
    fi
    
    # Eliminar duplicados y devolver array único
    printf '%s\n' "${pids[@]}" | sort -u
}

# Función para terminar proceso de forma elegante
graceful_shutdown() {
    local pid="$1"
    local process_name="$2"
    
    log "INFO" "Iniciando terminación elegante del proceso $pid ($process_name)"
    
    if ! process_exists "$pid"; then
        log "INFO" "Proceso $pid ya no existe"
        return 0
    fi
    
    # Enviar SIGTERM
    log "INFO" "Enviando SIGTERM a proceso $pid"
    kill -TERM "$pid" 2>/dev/null || true
    
    # Esperar terminación elegante
    local wait_time=0
    while [ $wait_time -lt $GRACEFUL_TIMEOUT ]; do
        if ! process_exists "$pid"; then
            log "INFO" "Proceso $pid terminado elegantemente en ${wait_time}s"
            return 0
        fi
        
        sleep 1
        wait_time=$((wait_time + 1))
    done
    
    # Si llegamos aquí, el proceso no terminó elegantemente
    log "WARNING" "Proceso $pid no terminó en $GRACEFUL_TIMEOUT segundos"
    return 1
}

# Función para forzar terminación
force_shutdown() {
    local pid="$1"
    local process_name="$2"
    
    log "WARNING" "Forzando terminación del proceso $pid ($process_name)"
    
    if ! process_exists "$pid"; then
        log "INFO" "Proceso $pid ya no existe"
        return 0
    fi
    
    # Enviar SIGKILL
    kill -KILL "$pid" 2>/dev/null || true
    sleep 2
    
    if ! process_exists "$pid"; then
        log "INFO" "Proceso $pid terminado forzadamente"
        return 0
    else
        log "ERROR" "No se pudo terminar el proceso $pid"
        return 1
    fi
}

# Función para limpiar archivos PID
cleanup_pid_files() {
    if [ -f "$PID_FILE" ]; then
        log "INFO" "Eliminando archivo PID"
        rm -f "$PID_FILE"
    fi
}

# Función para verificar estado después de la parada
verify_shutdown() {
    show_operation_banner "🔍 VERIFICANDO PARADA" "Confirmando que el servicio se detuvo correctamente..."
    
    # Verificar puerto
    if lsof -Pi :$SERVICE_PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
        local remaining_pid=$(lsof -Pi :$SERVICE_PORT -sTCP:LISTEN -t 2>/dev/null)
        show_warning_banner "Puerto $SERVICE_PORT aún ocupado por proceso $remaining_pid"
        return 1
    fi
    
    # Verificar procesos Java relacionados
    local java_pids=$(pgrep -f "spring-boot:run" 2>/dev/null || true)
    if [ -n "$java_pids" ]; then
        show_warning_banner "Procesos Java relacionados aún en ejecución: $java_pids"
        return 1
    fi
    
    show_success_banner "Servicio completamente detenido"
    return 0
}

# Función para mostrar información antes de detener
show_pre_shutdown_info() {
    show_operation_banner "📊 INFORMACIÓN ACTUAL DEL SERVICIO" "Obteniendo estado antes de detener..."
    
    # Verificar si el servicio está corriendo
    if lsof -Pi :$SERVICE_PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
        local port_pid=$(lsof -Pi :$SERVICE_PORT -sTCP:LISTEN -t 2>/dev/null)
        echo -e "${CYAN}🟢 Servicio detectado en puerto $SERVICE_PORT (PID: $port_pid)${NC}"
        
        # Intentar obtener información de salud
        if command -v curl >/dev/null 2>&1; then
            local health_url="http://localhost:$SERVICE_PORT/actuator/health"
            if curl -s "$health_url" >/dev/null 2>&1; then
                echo -e "${GREEN}✅ Endpoint de salud respondiendo${NC}"
            else
                echo -e "${YELLOW}⚠️ Endpoint de salud no responde${NC}"
            fi
        fi
    else
        echo -e "${YELLOW}⚠️ No se detectó servicio en puerto $SERVICE_PORT${NC}"
    fi
    
    # Mostrar procesos relacionados
    local service_pids=($(get_service_pids))
    if [ ${#service_pids[@]} -gt 0 ]; then
        echo -e "${CYAN}📋 Procesos relacionados encontrados:${NC}"
        for pid in "${service_pids[@]}"; do
            local cmd=$(ps -p "$pid" -o command= 2>/dev/null || echo "Comando no disponible")
            echo -e "${WHITE}  PID $pid: ${cmd}${NC}"
        done
    else
        echo -e "${YELLOW}⚠️ No se encontraron procesos relacionados${NC}"
    fi
}

# Función principal de detención
stop_service() {
    show_operation_banner "🛑 DETENIENDO SUPPORT SERVICE" "Iniciando proceso de parada elegante..."
    
    local service_pids=($(get_service_pids))
    local stopped_count=0
    local failed_count=0
    
    if [ ${#service_pids[@]} -eq 0 ]; then
        show_warning_banner "No se encontraron procesos del servicio ejecutándose"
        cleanup_pid_files
        return 0
    fi
    
    log "INFO" "Encontrados ${#service_pids[@]} procesos para detener"
    
    # Intentar parada elegante para todos los procesos
    for pid in "${service_pids[@]}"; do
        local cmd=$(ps -p "$pid" -o comm= 2>/dev/null || echo "proceso")
        
        echo -e "${CYAN}🔄 Deteniendo proceso $pid ($cmd)...${NC}"
        
        if graceful_shutdown "$pid" "$cmd"; then
            echo -e "${GREEN}✅ Proceso $pid detenido elegantemente${NC}"
            stopped_count=$((stopped_count + 1))
        else
            echo -e "${YELLOW}⚠️ Terminación elegante falló para proceso $pid${NC}"
            
            # Intentar terminación forzada
            if force_shutdown "$pid" "$cmd"; then
                echo -e "${GREEN}✅ Proceso $pid terminado forzadamente${NC}"
                stopped_count=$((stopped_count + 1))
            else
                echo -e "${RED}❌ No se pudo terminar proceso $pid${NC}"
                failed_count=$((failed_count + 1))
            fi
        fi
    done
    
    # Limpiar archivos PID
    cleanup_pid_files
    
    # Resumen de resultados
    echo ""
    echo -e "${CYAN}${BOLD}📊 RESUMEN DE PARADA:${NC}"
    echo -e "${GREEN}✅ Procesos detenidos: $stopped_count${NC}"
    if [ $failed_count -gt 0 ]; then
        echo -e "${RED}❌ Procesos fallidos: $failed_count${NC}"
    fi
    
    log "INFO" "Parada completada: $stopped_count exitosos, $failed_count fallidos"
    
    return $failed_count
}

# Función principal
main() {
    show_edutech_banner
    
    log "INFO" "Iniciando proceso de parada del Support Service"
    
    # Mostrar información actual
    show_pre_shutdown_info
    echo ""
    
    # Confirmar parada si es interactivo
    if [ -t 0 ]; then  # Si está en terminal interactivo
        echo -e "${YELLOW}¿Confirmas que deseas detener el Support Service? (s/N): ${NC}"
        read -r response
        
        if [[ ! "$response" =~ ^[Ss]$ ]]; then
            show_info_banner "Operación cancelada por el usuario"
            log "INFO" "Parada cancelada por el usuario"
            exit 0
        fi
    fi
    
    # Detener servicio
    if stop_service; then
        echo ""
        
        # Verificar que se detuvo correctamente
        if verify_shutdown; then
            show_success_banner "🎉 SUPPORT SERVICE DETENIDO EXITOSAMENTE 🎉"
            log "INFO" "Support Service detenido exitosamente"
            
            echo -e "\n${CYAN}${BOLD}📋 COMANDOS ÚTILES:${NC}"
            echo -e "${WHITE}• Reiniciar servicio: ${YELLOW}./scripts/mac/iniciar.sh${NC}"
            echo -e "${WHITE}• Ver logs: ${YELLOW}cat ${ROOT_DIR}/logs/service.out${NC}"
            echo -e "${WHITE}• Verificar estado: ${YELLOW}./scripts/mac/verificar-estado.sh${NC}"
            
        else
            show_warning_banner "Servicio detenido con advertencias"
            log "WARNING" "Servicio detenido pero con procesos residuales"
            exit 1
        fi
    else
        show_error_banner "Error al detener el servicio"
        log "ERROR" "Error durante la parada del servicio"
        exit 1
    fi
}

# Manejar señales para limpieza
trap cleanup_pid_files EXIT

# Ejecutar función principal
main "$@"
