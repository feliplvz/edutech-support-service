#!/bin/bash
# =============================================================================
# EduTech Banner - Banner profesional para Support Service
# =============================================================================

# Colores
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

show_edutech_banner() {
    clear
    echo -e "${PURPLE}${BOLD}"
    echo "╔═══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                               ║"
    echo "║   ███████╗██████╗ ██╗   ██╗████████╗███████╗ ██████╗██╗  ██╗                 ║"
    echo "║   ██╔════╝██╔══██╗██║   ██║╚══██╔══╝██╔════╝██╔════╝██║  ██║                 ║"
    echo "║   █████╗  ██║  ██║██║   ██║   ██║   █████╗  ██║     ███████║                 ║"
    echo "║   ██╔══╝  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║     ██╔══██║                 ║"
    echo "║   ███████╗██████╔╝╚██████╔╝   ██║   ███████╗╚██████╗██║  ██║                 ║"
    echo "║   ╚══════╝╚═════╝  ╚═════╝    ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝                 ║"
    echo "║                                                                               ║"
    echo "║              🎫 MICROSERVICIO DE SOPORTE Y TICKETS 🎫                        ║"
    echo "║                     💡 Support Service - v1.0.0 💡                          ║"
    echo "║                                                                               ║"
    echo "╚═══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

show_operation_banner() {
    local operation="$1"
    local description="$2"
    echo -e "\n${CYAN}${BOLD}╔══════════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║${NC} ${YELLOW}${BOLD}${operation}${NC} ${CYAN}${BOLD}║${NC}"
    echo -e "${CYAN}${BOLD}╠══════════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}${BOLD}║${NC} ${WHITE}${description}${NC} ${CYAN}${BOLD}║${NC}"
    echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════════════════════════════╝${NC}\n"
}

show_success_banner() {
    local message="$1"
    echo -e "\n${GREEN}${BOLD}╔══════════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║${NC} ${WHITE}✅ ${message}${NC} ${GREEN}${BOLD}║${NC}"
    echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════════════════════════════════╝${NC}\n"
}

show_error_banner() {
    local message="$1"
    echo -e "\n${RED}${BOLD}╔══════════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}${BOLD}║${NC} ${WHITE}❌ ${message}${NC} ${RED}${BOLD}║${NC}"
    echo -e "${RED}${BOLD}╚══════════════════════════════════════════════════════════════════════════════════╝${NC}\n"
}

show_warning_banner() {
    local message="$1"
    echo -e "\n${YELLOW}${BOLD}╔══════════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}${BOLD}║${NC} ${WHITE}⚠️ ${message}${NC} ${YELLOW}${BOLD}║${NC}"
    echo -e "${YELLOW}${BOLD}╚══════════════════════════════════════════════════════════════════════════════════╝${NC}\n"
}

show_info_banner() {
    local message="$1"
    echo -e "\n${BLUE}${BOLD}╔══════════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}${BOLD}║${NC} ${WHITE}ℹ️ ${message}${NC} ${BLUE}${BOLD}║${NC}"
    echo -e "${BLUE}${BOLD}╚══════════════════════════════════════════════════════════════════════════════════╝${NC}\n"
}

# Función para mostrar el estado del servicio
show_service_status() {
    local status="$1"
    local port="$2"
    local pid="$3"
    
    echo -e "${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║${NC} ${YELLOW}${BOLD}📊 ESTADO DEL SUPPORT SERVICE${NC} ${CYAN}${BOLD}║${NC}"
    echo -e "${CYAN}${BOLD}╠═══════════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}${BOLD}║${NC} ${WHITE}Estado: ${status}${NC} ${CYAN}${BOLD}║${NC}"
    echo -e "${CYAN}${BOLD}║${NC} ${WHITE}Puerto: ${port}${NC} ${CYAN}${BOLD}║${NC}"
    echo -e "${CYAN}${BOLD}║${NC} ${WHITE}PID: ${pid}${NC} ${CYAN}${BOLD}║${NC}"
    echo -e "${CYAN}${BOLD}║${NC} ${WHITE}Fecha: $(date '+%Y-%m-%d %H:%M:%S')${NC} ${CYAN}${BOLD}║${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════════╝${NC}"
}

# Función para mostrar información del proyecto
show_project_info() {
    echo -e "${PURPLE}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}${BOLD}║${NC} ${YELLOW}${BOLD}📋 INFORMACIÓN DEL PROYECTO${NC} ${PURPLE}${BOLD}║${NC}"
    echo -e "${PURPLE}${BOLD}╠═══════════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${PURPLE}${BOLD}║${NC} ${WHITE}Proyecto: EduTech Support Service${NC} ${PURPLE}${BOLD}║${NC}"
    echo -e "${PURPLE}${BOLD}║${NC} ${WHITE}Versión: 1.0.0-SNAPSHOT${NC} ${PURPLE}${BOLD}║${NC}"
    echo -e "${PURPLE}${BOLD}║${NC} ${WHITE}Puerto: 8084${NC} ${PURPLE}${BOLD}║${NC}"
    echo -e "${PURPLE}${BOLD}║${NC} ${WHITE}Framework: Spring Boot 3.5.0${NC} ${PURPLE}${BOLD}║${NC}"
    echo -e "${PURPLE}${BOLD}║${NC} ${WHITE}Java: 17+${NC} ${PURPLE}${BOLD}║${NC}"
    echo -e "${PURPLE}${BOLD}║${NC} ${WHITE}Base de datos: PostgreSQL${NC} ${PURPLE}${BOLD}║${NC}"
    echo -e "${PURPLE}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════════╝${NC}"
}
