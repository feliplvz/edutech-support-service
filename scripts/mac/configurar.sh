#!/bin/bash
# =============================================================================
# EduTech - Script de Configuración (macOS/Linux) - Support Service
# =============================================================================
# Descripción: Configuración empresarial del entorno de desarrollo para el
#              Microservicio de Soporte EduTech con validación completa
# Autor: Equipo de Desarrollo EduTech
# Versión: 1.0.0
# Plataforma: macOS/Linux/Unix
# =============================================================================

set -euo pipefail  # Salir en error, variables indefinidas, fallos de pipe

# Importar banner
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

if [ -f "$ROOT_DIR/scripts/banner.sh" ]; then
    source "$ROOT_DIR/scripts/banner.sh"
fi

# Códigos de color ya definidos en banner.sh

# Configuración
readonly SCRIPT_NAME="$(basename "$0")"
readonly LOG_FILE="${ROOT_DIR}/logs/configuracion.log"
readonly TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Crear directorio de logs si no existe
mkdir -p "${ROOT_DIR}/logs"

# Función de logging
log() {
    local level="$1"
    shift
    local message="$*"
    echo -e "[${TIMESTAMP}] [${level}] ${message}" | tee -a "${LOG_FILE}"
}

# Funciones de impresión con colores
print_header() {
    show_edutech_banner
    show_operation_banner "🛠️  CONFIGURACIÓN DE ENTORNO" "Inicializando entorno de desarrollo profesional..."
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
    log "SUCCESS" "$1"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
    log "ERROR" "$1"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    log "WARNING" "$1"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
    log "INFO" "$1"
}

print_step() {
    echo -e "${CYAN}${BOLD}🔧 $1${NC}"
    log "STEP" "$1"
}

# Función para verificar comandos necesarios
check_prerequisites() {
    print_step "Verificando requisitos del sistema..."
    
    local errors=0
    
    # Verificar Java 17+
    if command -v java >/dev/null 2>&1; then
        local java_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
        if [ "$java_version" -ge 17 ] 2>/dev/null; then
            print_success "Java $java_version encontrado ✓"
        else
            print_error "Java 17+ requerido. Versión actual: $java_version"
            errors=$((errors + 1))
        fi
    else
        print_error "Java no encontrado. Instala OpenJDK 17+"
        errors=$((errors + 1))
    fi
    
    # Verificar Maven
    if command -v mvn >/dev/null 2>&1; then
        local maven_version=$(mvn -version 2>/dev/null | head -n 1 | cut -d' ' -f3)
        print_success "Maven $maven_version encontrado ✓"
    else
        print_error "Maven no encontrado. Instala Apache Maven 3.6+"
        errors=$((errors + 1))
    fi
    
    # Verificar Git
    if command -v git >/dev/null 2>&1; then
        local git_version=$(git --version | cut -d' ' -f3)
        print_success "Git $git_version encontrado ✓"
    else
        print_warning "Git no encontrado. Recomendado para control de versiones"
    fi
    
    # Verificar curl
    if command -v curl >/dev/null 2>&1; then
        print_success "curl encontrado ✓"
    else
        print_warning "curl no encontrado. Recomendado para health checks"
    fi
    
    if [ $errors -gt 0 ]; then
        print_error "Se encontraron $errors errores en los requisitos del sistema"
        show_error_banner "Configuración fallida. Instala los requisitos faltantes."
        exit 1
    fi
    
    print_success "Todos los requisitos del sistema están disponibles"
}

# Función para validar estructura del proyecto Maven
validate_project_structure() {
    print_step "Validando estructura del proyecto Maven..."
    
    cd "$ROOT_DIR"
    
    # Verificar pom.xml
    if [ -f "pom.xml" ]; then
        print_success "pom.xml encontrado ✓"
        
        # Verificar que es un proyecto Spring Boot
        if grep -q "spring-boot-starter-parent" pom.xml; then
            print_success "Proyecto Spring Boot detectado ✓"
        else
            print_warning "No se detectó Spring Boot en pom.xml"
        fi
        
        # Verificar dependencias clave
        if grep -q "spring-boot-starter-web" pom.xml; then
            print_success "Dependencia Web encontrada ✓"
        fi
        
        if grep -q "spring-boot-starter-data-jpa" pom.xml; then
            print_success "Dependencia JPA encontrada ✓"
        fi
        
        if grep -q "postgresql" pom.xml; then
            print_success "Driver PostgreSQL encontrado ✓"
        fi
        
    else
        print_error "pom.xml no encontrado. ¿Estás en el directorio correcto?"
        exit 1
    fi
    
    # Verificar estructura de directorios
    local dirs=("src/main/java" "src/main/resources" "target")
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            print_success "Directorio $dir existe ✓"
        else
            print_warning "Directorio $dir no encontrado"
        fi
    done
    
    print_success "Estructura del proyecto validada correctamente"
}

# Función para configurar variables de entorno
setup_environment_variables() {
    print_step "Configurando variables de entorno..."
    
    # Verificar si existe .env
    if [ -f "$ROOT_DIR/.env" ]; then
        print_success "Archivo .env encontrado ✓"
        
        # Validar variables requeridas
        local required_vars=("DATABASE_URL" "DATABASE_USERNAME" "DATABASE_PASSWORD")
        local missing_vars=0
        
        for var in "${required_vars[@]}"; do
            if grep -q "^$var=" "$ROOT_DIR/.env"; then
                print_success "Variable $var configurada ✓"
            else
                print_error "Variable $var falta en .env"
                missing_vars=$((missing_vars + 1))
            fi
        done
        
        if [ $missing_vars -gt 0 ]; then
            print_warning "Faltan $missing_vars variables en .env"
        fi
        
    else
        print_warning "Archivo .env no encontrado"
        print_info "Creando plantilla .env..."
        
        cat > "$ROOT_DIR/.env" << 'EOF'
# 🔐 VARIABLES DE ENTORNO - SUPPORT SERVICE
# Configuración de Base de Datos PostgreSQL
DATABASE_URL=jdbc:postgresql://localhost:5432/supportdb
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=your_secure_password

# Configuración de la aplicación
SERVER_PORT=8084
APP_NAME=support-service

# Configuración JPA
JPA_DDL_AUTO=update
JPA_SHOW_SQL=true
JPA_FORMAT_SQL=true
EOF
        
        print_success "Plantilla .env creada. Configura tus credenciales."
    fi
}

# Función para configurar permisos de scripts
setup_script_permissions() {
    print_step "Configurando permisos de scripts..."
    
    local script_dirs=("$ROOT_DIR/scripts" "$ROOT_DIR/scripts/mac")
    
    for dir in "${script_dirs[@]}"; do
        if [ -d "$dir" ]; then
            find "$dir" -name "*.sh" -type f -exec chmod +x {} \;
            print_success "Permisos configurados para scripts en $dir ✓"
        fi
    done
    
    # Configurar permisos para scripts en el directorio raíz
    for script in "$ROOT_DIR"/*.sh; do
        if [ -f "$script" ]; then
            chmod +x "$script"
            print_success "Permisos configurados para $(basename "$script") ✓"
        fi
    done
}

# Función para inicializar directorios del proyecto
initialize_directories() {
    print_step "Inicializando estructura de directorios..."
    
    local dirs=("logs" "target")
    
    for dir in "${dirs[@]}"; do
        if [ ! -d "$ROOT_DIR/$dir" ]; then
            mkdir -p "$ROOT_DIR/$dir"
            print_success "Directorio $dir creado ✓"
        else
            print_success "Directorio $dir ya existe ✓"
        fi
    done
}

# Función para generar resumen del proyecto
generate_project_summary() {
    print_step "Generando resumen del proyecto..."
    
    local summary_file="$ROOT_DIR/PROJECT_SUMMARY.md"
    
    cat > "$summary_file" << EOF
# 🎫 EduTech Support Service - Resumen del Proyecto

## 📋 Información General
- **Proyecto**: EduTech Support Service
- **Versión**: 1.0.0-SNAPSHOT
- **Framework**: Spring Boot 3.5.0
- **Java**: 17+
- **Puerto**: 8084
- **Base de datos**: PostgreSQL

## 🏗️ Estructura del Proyecto
\`\`\`
edutech-support-service/
├── src/main/java/com/edutech/supportservice/
│   ├── SupportServiceApplication.java
│   ├── config/          # Configuraciones
│   ├── controller/      # Controladores REST
│   ├── dto/            # Data Transfer Objects
│   ├── exception/      # Manejo de excepciones
│   ├── model/          # Entidades JPA
│   ├── repository/     # Repositorios
│   ├── service/        # Lógica de negocio
│   └── util/           # Utilidades
├── src/main/resources/
│   └── application.properties
├── scripts/            # Scripts de automatización
├── logs/              # Archivos de log
└── target/            # Artefactos compilados
\`\`\`

## 🚀 Scripts Disponibles
- \`scripts/mac/controlador.sh\` - Controlador maestro
- \`scripts/mac/configurar.sh\` - Configuración del entorno
- \`scripts/mac/iniciar.sh\` - Iniciar servicio
- \`scripts/mac/detener.sh\` - Detener servicio
- \`scripts/mac/verificar-estado.sh\` - Verificar estado

## 🔗 Endpoints Principales
- **Actuator Health**: http://localhost:8084/actuator/health
- **Actuator Metrics**: http://localhost:8084/actuator/metrics
- **API Tickets**: http://localhost:8084/api/tickets
- **API Categorías**: http://localhost:8084/api/categories
- **API FAQs**: http://localhost:8084/api/faqs
- **API Mensajes**: http://localhost:8084/api/messages

## 📅 Configurado el: $(date '+%Y-%m-%d %H:%M:%S')
EOF
    
    print_success "Resumen del proyecto generado en PROJECT_SUMMARY.md ✓"
}

# Función para test de compilación
test_compilation() {
    print_step "Ejecutando test de compilación..."
    
    cd "$ROOT_DIR"
    
    if mvn clean compile -q; then
        print_success "Test de compilación exitoso ✓"
    else
        print_error "Error en la compilación"
        return 1
    fi
}

# Función principal
main() {
    print_header
    
    echo -e "${CYAN}${BOLD}Iniciando configuración del entorno de desarrollo...${NC}\n"
    
    # Ejecutar todas las verificaciones y configuraciones
    check_prerequisites
    echo ""
    
    validate_project_structure
    echo ""
    
    setup_environment_variables
    echo ""
    
    setup_script_permissions
    echo ""
    
    initialize_directories
    echo ""
    
    generate_project_summary
    echo ""
    
    test_compilation
    echo ""
    
    # Resumen final
    show_success_banner "CONFIGURACIÓN COMPLETADA EXITOSAMENTE"
    
    echo -e "${GREEN}${BOLD}🎉 ¡Entorno configurado correctamente!${NC}"
    echo -e "${CYAN}📋 Próximos pasos:${NC}"
    echo -e "${WHITE}   1. Revisa y configura las credenciales en ${YELLOW}.env${NC}"
    echo -e "${WHITE}   2. Ejecuta ${GREEN}./scripts/mac/controlador.sh${NC} para gestionar el servicio"
    echo -e "${WHITE}   3. Usa ${GREEN}./scripts/mac/iniciar.sh${NC} para iniciar el servicio"
    echo -e "${WHITE}   4. Verifica el estado con ${GREEN}./scripts/mac/verificar-estado.sh${NC}"
    echo ""
    
    log "SUCCESS" "Configuración del entorno completada exitosamente"
}

# Ejecutar configuración
main "$@"
