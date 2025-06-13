# 🚀 EduTech Scripts - Guía de Scripts Automatizados - Support Service

<div align="center">

[![Scripts](https://img.shields.io/badge/Scripts-Automatizados-blue.svg)](scripts/)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Windows-green.svg)](#🌐-compatibilidad-multiplataforma)
[![Version](https://img.shields.io/badge/Version-1.0.0-orange.svg)](scripts/)
[![Status](https://img.shields.io/badge/Status-✅%20Funcional-success.svg)](#✅-estado-de-los-scripts)

**🎯 Sistema de Automatización Empresarial para EduTech Support Service**

*Conjunto completo de scripts para el ciclo de vida del microservicio de soporte*

</div>

## 🎯 Descripción General

Este proyecto incluye un **sistema de scripts** completamente automatizado, diseñado para proporcionar una experiencia de desarrollo de calidad y simplificar todas las operaciones del ciclo de vida del microservicio de soporte EduTech.

### 📁 Estructura del Sistema de Scripts

```
scripts/
├── 🎨 banner.sh              # Sistema de banners para Mac/Linux
├── 🎨 banner.bat             # Sistema de banners para Windows
├── mac/                      # Scripts optimizados para macOS/Linux
│   ├── 🎮 controlador.sh     # Controlador maestro interactivo
│   ├── ⚙️ configurar.sh      # Configuración de entorno completa
│   ├── 🚀 iniciar.sh         # Inicio inteligente del microservicio
│   ├── 🛑 detener.sh         # Parada elegante del servicio
│   └── 🔍 verificar-estado.sh # Diagnóstico completo del sistema
└── windows/                  # Scripts equivalentes para Windows
    ├── 🎮 controlador.bat    # Controlador maestro interactivo
    ├── ⚙️ configurar.bat     # Configuración de entorno completa
    ├── 🚀 iniciar.bat        # Inicio inteligente del microservicio
    ├── 🛑 detener.bat        # Parada elegante del servicio
    └── 🔍 verificar-estado.bat # Diagnóstico completo del sistema
```

## 🚀 Scripts Disponibles

### 🎮 Controlador Maestro - El Cerebro del Sistema

**`scripts/mac/controlador.sh` / `scripts/windows/controlador.bat`** - Centro de comando unificado

```bash
# macOS/Linux
./scripts/mac/controlador.sh

# Windows
scripts\windows\controlador.bat
```

**🌟 Características Avanzadas:**
- 🎨 **Interfaz interactiva** con 18+ operaciones especializadas
- 🎯 **Menú intuitivo** con navegación por números o nombres
- 🔄 **Operaciones del ciclo completo** de desarrollo
- 📊 **Monitoreo en tiempo real** con reportes detallados
- 🛠️ **Herramientas DevOps** integradas
- 💡 **Sistema inteligente** de sugerencias y ayuda

#### 📋 **Menú Completo de Operaciones:**

```
🔧 CONFIGURACIÓN
 1) configurar      - 🛠️  Configurar entorno de desarrollo
 2) variables       - ⚙️  Gestionar variables de entorno

🚀 CICLO DE VIDA
 3) iniciar         - 🚀 Iniciar el microservicio
 4) detener         - 🛑 Detener el microservicio
 5) reiniciar       - 🔄 Reiniciar el microservicio
 6) estado          - 🔍 Verificar estado del servicio

🔨 COMPILACIÓN & PRUEBAS
 7) compilar        - 🔨 Compilar la aplicación
 8) pruebas         - 🧪 Ejecutar pruebas unitarias
 9) empaquetar      - 📦 Crear paquete desplegable
10) limpiar         - 🧹 Limpiar artefactos de compilación

📊 MONITOREO & LOGS
11) logs            - 📋 Ver logs de la aplicación
12) salud           - 🏥 Verificar endpoints de salud
13) metricas        - 📈 Ver métricas del sistema
14) bd              - 🗄️ Verificar conectividad de BD

🔧 HERRAMIENTAS DEV
15) dependencias    - 📦 Gestionar dependencias Maven
16) postman         - 📮 Operaciones con Postman
17) info            - ℹ️  Información del proyecto
18) ayuda           - ❓ Ayuda y documentación
```

### ⚙️ Configurador de Entorno - Setup Inteligente

**`scripts/mac/configurar.sh` / `scripts/windows/configurar.bat`** - Configuración automática del entorno

```bash
# macOS/Linux
./scripts/mac/configurar.sh

# Windows
scripts\windows\configurar.bat
```

**🔧 Funcionalidades Empresariales:**
- ✅ **Validación automática** de requisitos del sistema (Java 17+, Maven 3.6+, Git)
- ✅ **Configuración inteligente** de variables de entorno con plantillas
- ✅ **Gestión de permisos** automática para todos los scripts
- ✅ **Validación del proyecto** Maven con verificaciones de Spring Boot
- ✅ **Inicialización completa** de estructura de directorios
- ✅ **Generación de resumen** del proyecto en Markdown
- ✅ **Configuración de .gitignore** para proteger credenciales

### 🚀 Iniciador Inteligente - Smart Startup

**`scripts/mac/iniciar.sh` / `scripts/windows/iniciar.bat`** - Inicio avanzado del microservicio

```bash
# macOS/Linux
./scripts/mac/iniciar.sh

# Windows
scripts\windows\iniciar.bat
```

**🎯 Características Avanzadas:**
- ✅ **Pre-flight checks** completos del sistema
- ✅ **Gestión inteligente de puertos** con detección automática
- ✅ **Health monitoring** con timeouts configurables (120s)
- ✅ **Validación de build** y dependencias Maven
- ✅ **Gestión de procesos** con PID tracking
- ✅ **Logs en tiempo real** con colores y timestamps
- ✅ **Banner EduTech** con información del sistema

### 🛑 Terminador Elegante - Graceful Shutdown

**`scripts/mac/detener.sh` / `scripts/windows/detener.bat`** - Parada inteligente del servicio

```bash
# macOS/Linux
./scripts/mac/detener.sh

# Windows
scripts\windows\detener.bat
```

**🔒 Funcionalidades de Seguridad:**
- ✅ **Terminación graceful** con múltiples métodos (SIGTERM → SIGKILL)
- ✅ **Búsqueda automática** de procesos Java/Spring Boot/Maven
- ✅ **Verificación post-shutdown** completa
- ✅ **Limpieza de archivos** PID y temporales
- ✅ **Timeout configurable** con fallback forzado
- ✅ **Confirmación interactiva** para prevenir paradas accidentales

### 🔍 Verificador de Estado - Health Diagnostics

**`scripts/mac/verificar-estado.sh` / `scripts/windows/verificar-estado.bat`** - Diagnóstico completo

```bash
# macOS/Linux
./scripts/mac/verificar-estado.sh

# Windows
scripts\windows\verificar-estado.bat
```

**📊 Capacidades de Diagnóstico:**
- ✅ **Verificación de puertos** y procesos relacionados
- ✅ **Health endpoints** con análisis de respuesta JSON
- ✅ **Métricas de Actuator** con listado de métricas disponibles
- ✅ **Análisis de configuración** (.env, application.properties, pom.xml)
- ✅ **Monitoreo de logs** con análisis de archivos recientes
- ✅ **Información de recursos** (CPU, memoria, tiempo de inicio)
- ✅ **Resumen ejecutivo** con estado general del sistema

## 🌐 Compatibilidad Multiplataforma

| Característica | macOS/Linux | Windows |
|---------------|-------------|---------|
| Scripts Bash | ✅ | ❌ |
| Scripts Batch | ❌ | ✅ |
| Banners ASCII | ✅ | ✅ |
| Colores Terminal | ✅ | ✅ |
| Gestión PID | ✅ | ✅ |
| Health Checks | ✅ | ✅ |
| Maven Integration | ✅ | ✅ |

## 🚀 Inicio Rápido

### 1. Configuración Inicial

#### 🍎 macOS/Linux
```bash
# Hacer ejecutables los scripts
chmod +x scripts/mac/*.sh

# Ejecutar configuración
./scripts/mac/configurar.sh
```

#### 🪟 Windows
```cmd
# Ejecutar configuración (desde CMD o PowerShell)
scripts\windows\configurar.bat
```

### 2. Iniciar el Servicio

#### 🍎 macOS/Linux
```bash
# Método recomendado: Usar el controlador
./scripts/mac/controlador.sh

# O directamente
./scripts/mac/iniciar.sh
```

#### 🪟 Windows
```cmd
# Método recomendado: Usar el controlador
scripts\windows\controlador.bat

# O directamente
scripts\windows\iniciar.bat
```

### 3. Verificar Estado

#### 🍎 macOS/Linux
```bash
./scripts/mac/verificar-estado.sh
```

#### 🪟 Windows
```cmd
scripts\windows\verificar-estado.bat
```

### 4. Detener el Servicio

#### 🍎 macOS/Linux
```bash
./scripts/mac/detener.sh
```

#### 🪟 Windows
```cmd
scripts\windows\detener.bat
```

## 📋 Variables de Entorno Requeridas

El archivo `.env` debe contener:

```bash
# 🔐 VARIABLES DE ENTORNO - SUPPORT SERVICE
DATABASE_URL=jdbc:postgresql://your-host:5432/supportdb
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=your_secure_password
SERVER_PORT=8084
APP_NAME=support-service
JPA_DDL_AUTO=update
JPA_SHOW_SQL=true
JPA_FORMAT_SQL=true
```

## 🔗 Endpoints del Servicio

Una vez iniciado, el servicio estará disponible en:

| Endpoint | URL | Descripción |
|----------|-----|-------------|
| **Health Check** | `http://localhost:8084/actuator/health` | Estado de salud del servicio |
| **Métricas** | `http://localhost:8084/actuator/metrics` | Métricas de rendimiento |
| **API Tickets** | `http://localhost:8084/api/tickets` | Gestión de tickets de soporte |
| **API Categorías** | `http://localhost:8084/api/categories` | Categorías de tickets |
| **API FAQs** | `http://localhost:8084/api/faqs` | Preguntas frecuentes |
| **API Mensajes** | `http://localhost:8084/api/messages` | Mensajes del sistema |

## 📊 Monitoreo y Logs

### Archivos de Log

```
logs/
├── service.out           # Log principal de la aplicación
├── support-audit.log     # Log de auditoría del negocio
├── configuracion.log     # Log de configuración
├── inicio.log           # Log de inicio del servicio
├── detener.log          # Log de parada del servicio
└── verificacion.log     # Log de verificaciones
```

### Comandos de Monitoreo

```bash
# Ver logs en tiempo real
tail -f logs/service.out

# Verificar salud
curl http://localhost:8084/actuator/health

# Ver métricas
curl http://localhost:8084/actuator/metrics

# Estado completo
./scripts/mac/verificar-estado.sh
```

## 🛠️ Resolución de Problemas

### Problemas Comunes

1. **Puerto ocupado**
   
   #### 🍎 macOS/Linux
   ```bash
   # Verificar qué proceso usa el puerto
   lsof -i :8084
   
   # El script de inicio puede manejar esto automáticamente
   ./scripts/mac/iniciar.sh
   ```
   
   #### 🪟 Windows
   ```cmd
   # Verificar qué proceso usa el puerto
   netstat -ano | findstr :8084
   
   # El script de inicio puede manejar esto automáticamente
   scripts\windows\iniciar.bat
   ```

2. **Variables de entorno faltantes**
   
   #### 🍎 macOS/Linux
   ```bash
   # Reconfigurar entorno
   ./scripts/mac/configurar.sh
   ```
   
   #### 🪟 Windows
   ```cmd
   # Reconfigurar entorno
   scripts\windows\configurar.bat
   ```

3. **Fallos de compilación**
   
   #### 🍎 macOS/Linux
   ```bash
   # Limpiar y recompilar
   ./scripts/mac/controlador.sh
   # Seleccionar: 10) limpiar, luego 7) compilar
   ```
   
   #### 🪟 Windows
   ```cmd
   # Limpiar y recompilar
   scripts\windows\controlador.bat
   # Seleccionar: 10) limpiar, luego 7) compilar
   ```

4. **Servicio no responde**
   
   #### 🍎 macOS/Linux
   ```bash
   # Diagnóstico completo
   ./scripts/mac/verificar-estado.sh
   
   # Reinicio completo
   ./scripts/mac/controlador.sh
   # Seleccionar: 5) reiniciar
   ```
   
   #### 🪟 Windows
   ```cmd
   # Diagnóstico completo
   scripts\windows\verificar-estado.bat
   
   # Reinicio completo
   scripts\windows\controlador.bat
   # Seleccionar: 5) reiniciar
   ```

## ✅ Estado de los Scripts

### macOS/Linux Scripts

| Script | Estado | Última Actualización |
|--------|--------|---------------------|
| 🎮 controlador.sh | ✅ Funcional | 2025-01-03 |
| ⚙️ configurar.sh | ✅ Funcional | 2025-01-03 |
| 🚀 iniciar.sh | ✅ Funcional | 2025-01-03 |
| 🛑 detener.sh | ✅ Funcional | 2025-01-03 |
| 🔍 verificar-estado.sh | ✅ Funcional | 2025-01-03 |
| 🎨 banner.sh | ✅ Funcional | 2025-01-03 |

### Windows Scripts

| Script | Estado | Última Actualización |
|--------|--------|---------------------|
| 🎮 controlador.bat | ✅ Funcional | 2025-01-03 |
| ⚙️ configurar.bat | ✅ Funcional | 2025-01-03 |
| 🚀 iniciar.bat | ✅ Funcional | 2025-01-03 |
| 🛑 detener.bat | ✅ Funcional | 2025-01-03 |
| 🔍 verificar-estado.bat | ✅ Funcional | 2025-01-03 |
| 🎨 banner.bat | ✅ Funcional | 2025-01-03 |

---

<div align="center">

[![Scripts](https://img.shields.io/badge/Total%20Scripts-12-blue.svg)](scripts/)
[![Platforms](https://img.shields.io/badge/Platforms-2-green.svg)](#🌐-compatibilidad-multiplataforma)
[![Status](https://img.shields.io/badge/All%20Systems-✅%20Operational-success.svg)](#✅-estado-de-los-scripts)

</div>
