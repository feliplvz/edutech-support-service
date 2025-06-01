# 🚀 EduTech - Microservicio de Soporte Técnico

<div align="center">

[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://openjdk.java.net/projects/jdk/17/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.0-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16.8-blue.svg)](https://www.postgresql.org/)
[![API](https://img.shields.io/badge/API-REST-green.svg)](https://restfulapi.net/)
[![Tests](https://img.shields.io/badge/Tests-✅%20Passed-success.svg)](./src/test)

**🎯 Microservicio Empresarial de Gestión de Tickets y Soporte al Cliente**

</div>
  
## 🎯 Descripción

**Support Service** es un microservicio empresarial robusto y escalable, desarrollado con **Spring Boot 3.5.0**, diseñado para gestionar de manera eficiente tickets de soporte, FAQs y comunicaciones con clientes en plataformas educativas corporativas. Este servicio proporciona una **API REST completa** con estándares de calidad, incluyendo manejo avanzado de errores, validaciones estrictas y arquitectura orientada a microservicios.

### 🎯 Propósito de Negocio

- **Sistema Centralizado** de gestión de incidencias y soporte técnico
- **Escalabilidad Horizontal** para múltiples departamentos y equipos
- **Integración Empresarial** con sistemas CRM y plataformas educativas
- **Arquitectura Cloud-Ready** para despliegues modernos

### 📊 Estadísticas Clave

- ✅ **25+ Endpoints API** completamente funcionales
- ✅ **100% Funcionalidades** implementadas
- ✅ **PostgreSQL Cloud** en Railway
- ✅ **4 Categorías de Tickets** preconfiguradas
- ✅ **Sistema de Calificación** de soporte recibido
- ✅ **Base de FAQs** autogestionada

---

## ✨ Características Principales

### 🏢 Gestión Empresarial
- **🎫 Gestión de Tickets**: CRUD completo con seguimiento de estados y prioridades
- **🗣️ Sistema de Mensajería**: Comunicación integrada entre usuarios y soporte
- **📝 Notas Internas**: Comunicación privada entre personal de soporte
- **❓ Base de FAQs**: Repositorio de conocimiento con sistema de valoración
- **📊 Métricas y Estadísticas**: KPIs de resolución y satisfacción

### 🛠️ Características Técnicas
- **🏥 Health Monitoring**: Monitoreo completo de salud del servicio y BD
- **🛡️ Manejo de Errores**: GlobalExceptionHandler empresarial
- **🌐 CORS Empresarial**: Configuración avanzada para integración
- **✔️ Validaciones**: Validación robusta de datos de entrada
- **🔒 Cabeceras de Seguridad**: Implementación de headers de protección

### 🚀 Infraestructura
- **🗄️ Base de Datos**: PostgreSQL 16.8 en Railway (Cloud)
- **🎯 Auto-Inicialización**: Datos de demostración y configuración automática
- **🔄 Transacciones**: Gestión robusta de operaciones atómicas
- **🌐 Cloud-Ready**: Desplegable en cualquier plataforma cloud
- **📨 Auditabilidad**: Registro de todas las operaciones críticas

---

## 🛠️ Tecnologías Utilizadas

### 🔧 Stack Principal

| Tecnología | Versión | Descripción |
|------------|---------|-------------|
| ☕ **Java** | 17+ LTS | Lenguaje principal con soporte empresarial |
| 🍃 **Spring Boot** | 3.5.0 | Framework empresarial de microservicios |
| 🗄️ **Spring Data JPA** | 3.5.0 | ORM avanzado para gestión de datos |
| 🌐 **Spring Web** | 3.5.0 | API REST con estándares empresariales |
| 🐘 **PostgreSQL** | 16.8 | Base de datos empresarial en la nube |

### 🔗 Dependencias
- 🔄 **Hibernate** 6.6.15 - ORM de nivel empresarial
- 🎭 **Lombok** Latest - Reducción de boilerplate code
- 📦 **Maven** 3.6+ - Gestión de dependencias empresarial
- ⚡ **Caffeine** - Cache local de alto rendimiento
- 🏥 **Actuator** - Monitoreo y métricas en tiempo real

---

## 🚀 Configuración y Despliegue

### 📋 Prerrequisitos
- ☕ **Java 17+** (OpenJDK o Oracle)
- 📦 **Maven 3.6+** para gestión de dependencias
- 🌐 **Conexión a Internet** (PostgreSQL en Railway)
- 🐳 **Docker** (opcional para containerización)

### ⚙️ Variables de Entorno

```properties
# 🎯 Configuración del Servicio
spring.application.name=support-service
server.port=8084

# 🗄️ Base de Datos PostgreSQL (Usar variables de entorno)
spring.datasource.url=${DATABASE_URL:jdbc:postgresql://localhost:5432/supportdb}
spring.datasource.username=${DATABASE_USERNAME:postgres}
spring.datasource.password=${DATABASE_PASSWORD:tu_password_aqui}

# 🚀 Configuración JPA Optimizada
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
```

### 🔐 Configuración de Seguridad

#### 🌐 Entornos de Despliegue

**🚀 Producción (Railway/Heroku/AWS):**
```bash
# Variables de entorno del sistema
DATABASE_URL=jdbc:postgresql://your-host:port/database
DATABASE_USERNAME=your_username
DATABASE_PASSWORD=your_secure_password
```

**💻 Desarrollo Local:**
```bash
# Crear archivo .env (incluido en .gitignore)
DATABASE_URL=jdbc:postgresql://localhost:5432/supportdb_dev
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=admin123
```

**🐳 Docker Compose:**
```yaml
# docker-compose.yml
services:
  support-service:
    environment:
      - DATABASE_URL=jdbc:postgresql://postgres:5432/supportdb
      - DATABASE_USERNAME=postgres
      - DATABASE_PASSWORD=postgres123
  postgres:
    image: postgres:16
    environment:
      - POSTGRES_DB=supportdb
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres123
```

### 🏃‍♂️ Instrucciones de Instalación

#### 🔧 Instalación Local
```bash
# 1️⃣ Clonar el repositorio
git clone [https://github.com/feliplvz/edutech-support-service]
cd support-service

# 2️⃣ Configurar credenciales (el archivo .env ya está incluido)
# ✅ Las credenciales ya están configuradas en .env

# 3️⃣ OPCIÓN FÁCIL: Usar script de inicio automático
./start.sh

# 4️⃣ OPCIÓN RÁPIDA: Solo ejecutar el servicio
./run.sh

# 5️⃣ OPCIÓN MANUAL: Comandos tradicionales
mvn clean compile
mvn test
mvn spring-boot:run
```

#### 🚀 Scripts de Inicio Incluidos

**🎯 Script Completo** (`./start.sh`)
- ✅ Verifica archivos y dependencias
- ✅ Carga variables de entorno automáticamente
- ✅ Compila el proyecto
- ✅ Ejecuta el servicio
- ✅ Muestra información útil

**⚡ Script Rápido** (`./run.sh`)
- ✅ Carga variables de entorno
- ✅ Ejecuta directamente `mvn spring-boot:run`
- ✅ Perfecto para desarrollo rápido

#### 🐳 Despliegue con Docker
```bash
# Crear imagen Docker
docker build -t support-service .

# Ejecutar contenedor
docker run -p 8084:8084 support-service
```

### 🔐 Configuración de Seguridad (IMPORTANTE)

#### ⚠️ Configuración de Variables de Entorno
Para **proteger credenciales sensibles**, este proyecto usa variables de entorno:

**🎯 Paso 1**: Copia el archivo de ejemplo
```bash
cp .env.example .env
```

**🎯 Paso 2**: Edita `.env` con tus credenciales reales
```bash
# ⚠️ NUNCA subas este archivo a Git
DATABASE_URL=jdbc:postgresql://tu-host:puerto/tu-database
DATABASE_USERNAME=tu_usuario
DATABASE_PASSWORD=tu_password_super_seguro
```

**🎯 Paso 3**: Las variables se cargan automáticamente
```properties
# application.properties usa variables de entorno
spring.datasource.url=${DATABASE_URL:jdbc:postgresql://localhost:5432/supportdb}
spring.datasource.username=${DATABASE_USERNAME:postgres}
spring.datasource.password=${DATABASE_PASSWORD:your_secure_password}
```

#### 🛡️ Archivos Protegidos por .gitignore
- ✅ `.env` - Variables de entorno
- ✅ `*.key` - Archivos de claves
- ✅ `application-prod.properties` - Configuraciones de producción
- ✅ `logs/` - Logs que pueden contener información sensible
- ✅ `target/` - Archivos compilados con credenciales

#### 🔒 Mejores Prácticas Implementadas
- ✅ **Variables de Entorno**: Nunca credenciales en el código
- ✅ **GitIgnore Robusto**: Archivos sensibles excluidos
- ✅ **Separación de Entornos**: Dev/Staging/Prod
- ✅ **Validación de Entrada**: Protección contra inyección
- ✅ **Headers de Seguridad**: CORS y cabeceras HTTP
- ✅ **Error Handling**: Sin exposición de información interna

### 🌐 Verificación del Despliegue
- **🏠 URL Base**: `http://localhost:8084`
- **📊 Health Check**: `http://localhost:8084/actuator/health`
- **🎫 Tickets**: `http://localhost:8084/api/tickets`
- **❓ FAQs**: `http://localhost:8084/api/faqs`

---

## 📊 API Endpoints

### 🏥 Health Check & Monitoring

| Método | Endpoint | Descripción | Respuesta |
|--------|----------|-------------|-----------|
| `GET` | `/actuator/health` | Estado general del microservicio | `200 OK` |
| `GET` | `/actuator/info` | Información del microservicio | `200 OK` |

### 🎫 Gestión de Tickets

| Método | Endpoint | Descripción | Respuesta |
|--------|----------|-------------|-----------|
| `GET` | `/api/tickets` | Listar todos los tickets | `200 OK` |
| `GET` | `/api/tickets/{id}` | Obtener ticket específico | `200 OK` |
| `GET` | `/api/tickets/user/{userId}` | Tickets de un usuario | `200 OK` |
| `GET` | `/api/tickets/assigned/{staffId}` | Tickets asignados a staff | `200 OK` |
| `GET` | `/api/tickets/status/{status}` | Tickets por estado | `200 OK` |
| `GET` | `/api/tickets/category/{categoryId}` | Tickets por categoría | `200 OK` |
| `GET` | `/api/tickets/paginated` | Tickets con paginación | `200 OK` |
| `GET` | `/api/tickets/search` | Búsqueda de tickets | `200 OK` |
| `POST` | `/api/tickets` | Crear nuevo ticket | `201 Created` |
| `PUT` | `/api/tickets/{id}` | Actualizar ticket | `200 OK` |
| `PATCH` | `/api/tickets/{id}/assign/{staffId}` | Asignar ticket | `200 OK` |
| `PATCH` | `/api/tickets/{id}/status/{status}` | Cambiar estado | `200 OK` |
| `PATCH` | `/api/tickets/{id}/priority/{priority}` | Cambiar prioridad | `200 OK` |
| `POST` | `/api/tickets/{id}/rate` | Calificar ticket resuelto | `200 OK` |
| `GET` | `/api/tickets/stats/status-counts` | Conteo por estados | `200 OK` |

### 📝 Gestión de Mensajes

| Método | Endpoint | Descripción | Respuesta |
|--------|----------|-------------|-----------|
| `GET` | `/api/messages/ticket/{ticketId}` | Mensajes de un ticket | `200 OK` |
| `GET` | `/api/messages/{id}` | Obtener mensaje específico | `200 OK` |
| `POST` | `/api/messages` | Crear nuevo mensaje | `201 Created` |
| `POST` | `/api/messages/internal-note` | Crear nota interna | `201 Created` |
| `PATCH` | `/api/messages/{id}/mark-read` | Marcar como leído | `204 No Content` |
| `PATCH` | `/api/messages/ticket/{ticketId}/mark-all-read` | Marcar todos como leídos | `204 No Content` |

### ❓ Gestión de FAQs

| Método | Endpoint | Descripción | Respuesta |
|--------|----------|-------------|-----------|
| `GET` | `/api/faqs` | Listar todas las FAQs | `200 OK` |
| `GET` | `/api/faqs/published` | Listar FAQs publicadas | `200 OK` |
| `GET` | `/api/faqs/{id}` | Obtener FAQ específica | `200 OK` |
| `GET` | `/api/faqs/category/{categoryId}` | FAQs por categoría | `200 OK` |
| `GET` | `/api/faqs/search` | Buscar FAQs | `200 OK` |
| `POST` | `/api/faqs` | Crear nueva FAQ | `201 Created` |
| `PUT` | `/api/faqs/{id}` | Actualizar FAQ | `200 OK` |
| `PATCH` | `/api/faqs/{id}/publish` | Publicar FAQ | `200 OK` |
| `PATCH` | `/api/faqs/{id}/unpublish` | Despublicar FAQ | `200 OK` |
| `PATCH` | `/api/faqs/{id}/helpful` | Votar útil | `200 OK` |
| `GET` | `/api/faqs/most-viewed` | FAQs más vistas | `200 OK` |

### 🏷️ Gestión de Categorías

| Método | Endpoint | Descripción | Respuesta |
|--------|----------|-------------|-----------|
| `GET` | `/api/ticket-categories` | Listar categorías | `200 OK` |
| `GET` | `/api/ticket-categories/active` | Categorías activas | `200 OK` |
| `GET` | `/api/ticket-categories/{id}` | Obtener categoría | `200 OK` |
| `POST` | `/api/ticket-categories` | Crear categoría | `201 Created` |
| `PUT` | `/api/ticket-categories/{id}` | Actualizar categoría | `200 OK` |
| `PATCH` | `/api/ticket-categories/{id}/activate` | Activar categoría | `200 OK` |
| `PATCH` | `/api/ticket-categories/{id}/deactivate` | Desactivar categoría | `200 OK` |

### 📝 Ejemplos de Uso

#### 🎫 Crear Ticket
```bash
curl -X POST http://localhost:8084/api/tickets \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Problema de acceso al curso",
    "description": "No puedo acceder al módulo 3 del curso de Java",
    "priority": "MEDIA",
    "userId": 101,
    "categoryId": 1,
    "courseId": 45
  }'
```

#### 📝 Responder a un Ticket
```bash
curl -X POST http://localhost:8084/api/messages \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Hemos revisado su problema y está resuelto. Por favor intente nuevamente.",
    "ticketId": 1,
    "senderId": 202,
    "senderName": "Carlos Soporte",
    "senderEmail": "soporte@edutech.com",
    "senderType": "SOPORTE"
  }'
```

#### ❓ Crear FAQ
```bash
curl -X POST http://localhost:8084/api/faqs \
  -H "Content-Type: application/json" \
  -d '{
    "question": "¿Cómo puedo restablecer mi contraseña?",
    "answer": "Para restablecer su contraseña, haga clic en el enlace \"Olvidé mi contraseña\" en la página de inicio de sesión y siga las instrucciones.",
    "categoryId": 1,
    "searchKeywords": "contraseña, restablecer, olvidé, recuperar",
    "published": true
  }'
```

---

## 🏗️ Arquitectura del Proyecto

### 📁 Estructura del Proyecto
```
📦 support-service/
├── 📄 pom.xml                          # Configuración Maven
├── 📄 README.md                        # Documentación profesional
├── 📄 .env.example                     # Plantilla de variables de entorno
├── 📄 .gitignore                       # Protección de archivos sensibles
├── 🚀 start.sh                         # Script completo de inicio
├── ⚡ run.sh                           # Script rápido de ejecución
├── 📂 logs/                            # Logs de auditoría
│   └── 📄 support-audit.log            # Registro de operaciones críticas
└── 📂 src/main/
    ├── 📂 java/com/edutech/supportservice/
    │   ├── 🚀 SupportServiceApplication.java # Punto de entrada principal
    │   ├── 📂 config/                      # Configuraciones empresariales
    │   │   ├── 🎯 CacheConfig.java         # Configuración de caché Caffeine
    │   │   ├── 🌐 CorsConfig.java          # Configuración CORS
    │   │   ├── 🔄 DataInitializer.java     # Inicialización automática de datos
    │   │   ├── 🌐 EncodingConfig.java      # Configuración UTF-8
    │   │   ├── 🛡️ SecurityConfig.java      # Configuración de seguridad
    │   │   └── 🔒 SecurityHeadersConfig.java # Headers de protección HTTP
    │   ├── 📂 controller/                   # Controladores REST API
    │   │   ├── 🏷️ CategoryController.java   # API de categorías base
    │   │   ├── 🎫 TicketController.java     # API principal de tickets
    │   │   ├── 📝 MessageController.java    # API de mensajes/comunicación
    │   │   ├── ❓ FAQController.java         # API de base de conocimiento
    │   │   └── 🏷️ TicketCategoryController.java # API de categorías específicas
    │   ├── 📂 dto/                         # Objetos de transferencia
    │   │   ├── 🎫 TicketDTO.java           # DTO para tickets
    │   │   ├── 📝 MessageDTO.java          # DTO para mensajes
    │   │   ├── ❓ FAQDTO.java               # DTO para FAQs
    │   │   └── 🏷️ TicketCategoryDTO.java   # DTO para categorías
    │   ├── 📂 service/                     # Interfaces de servicios
    │   │   ├── 🎫 TicketService.java       # Interface del servicio de tickets
    │   │   ├── 📝 MessageService.java      # Interface del servicio de mensajes
    │   │   ├── ❓ FAQService.java           # Interface del servicio de FAQs
    │   │   ├── 🏷️ TicketCategoryService.java # Interface de categorías
    │   │   └── 📂 impl/                    # Implementaciones de servicios
    │   │       ├── 🎫 TicketServiceImpl.java
    │   │       ├── 📝 MessageServiceImpl.java
    │   │       ├── ❓ FAQServiceImpl.java
    │   │       └── 🏷️ TicketCategoryServiceImpl.java
    │   ├── 📂 repository/                  # Acceso a datos (JPA)
    │   │   ├── 🎫 TicketRepository.java    # Repositorio de tickets
    │   │   ├── 📝 MessageRepository.java   # Repositorio de mensajes
    │   │   ├── ❓ FAQRepository.java        # Repositorio de FAQs
    │   │   └── 🏷️ TicketCategoryRepository.java # Repositorio de categorías
    │   ├── 📂 model/                       # Entidades del dominio
    │   │   ├── 🎫 Ticket.java              # Entidad principal de tickets
    │   │   ├── 📝 Message.java             # Entidad de mensajes
    │   │   ├── ❓ FAQ.java                  # Entidad de FAQs
    │   │   └── 🏷️ TicketCategory.java      # Entidad de categorías
    │   ├── 📂 exception/                   # Manejo de excepciones
    │   │   ├── 🛑 GlobalExceptionHandler.java # Manejador central de errores
    │   │   ├── ⚠️ ResourceNotFoundException.java # Excepción personalizada
    │   │   └── 📄 ErrorResponse.java       # Estructura de respuestas de error
    │   └── 📂 util/                        # Utilidades del sistema
    │       ├── 📊 AuditLogger.java         # Logger de auditoría
    │       └── ✔️ ValidationUtil.java      # Utilidades de validación
    └── 📂 resources/
        └── 📄 application.properties       # Configuración con variables de entorno
```

### 🗄️ Modelo de Base de Datos
```sql
-- 📊 Esquema Empresarial Optimizado
TicketCategories (
  id BIGINT PRIMARY KEY,
  name VARCHAR(255) UNIQUE NOT NULL,
  description TEXT,
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)

Tickets (
  id BIGINT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  status VARCHAR(50) NOT NULL,
  priority VARCHAR(50) NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  closed_at TIMESTAMP,
  user_id BIGINT NOT NULL,
  assigned_to_id BIGINT,
  category_id BIGINT REFERENCES TicketCategories(id),
  course_id BIGINT,
  satisfaction_rating INTEGER,
  feedback TEXT
)

Messages (
  id BIGINT PRIMARY KEY,
  content TEXT NOT NULL,
  created_at TIMESTAMP,
  sender_id BIGINT NOT NULL,
  sender_name VARCHAR(255),
  sender_email VARCHAR(255),
  sender_type VARCHAR(50) NOT NULL,
  attachment_url VARCHAR(500),
  attachment_type VARCHAR(100),
  is_internal_note BOOLEAN DEFAULT FALSE,
  is_read BOOLEAN DEFAULT FALSE,
  ticket_id BIGINT REFERENCES Tickets(id)
)

FAQs (
  id BIGINT PRIMARY KEY,
  question VARCHAR(500) NOT NULL,
  answer TEXT NOT NULL,
  view_count INTEGER DEFAULT 0,
  helpful_votes INTEGER DEFAULT 0,
  unhelpful_votes INTEGER DEFAULT 0,
  published BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  search_keywords TEXT,
  display_order INTEGER DEFAULT 0,
  category_id BIGINT REFERENCES TicketCategories(id)
)
```

### 🏛️ Arquitectura del Sistema

```
                    🌐 CLIENT REQUESTS
                           │
                           ▼
    ┌─────────────────────────────────────────────────────────────┐
    │                    🎯 CONTROLLER LAYER                      │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
    │  │ TicketController│  │MessageController│  │FAQController│ │
    │  │   (Tickets)     │  │   (Messages)    │  │   (FAQs)    │ │
    │  └─────────┬───────┘  └─────────┬───────┘  └─────┬───────┘ │
    │  ┌─────────────────┐  ┌─────────────────────────────────┐ │
    │  │CategoryController│  │TicketCategoryController       │ │
    │  │  (Categories)   │  │     (Ticket Categories)        │ │
    │  └─────────────────┘  └─────────────────────────────────┘ │
    └────────────┼──────────────────────┼──────────────┼───────────┘
                 │                      │              │
                 ▼                      ▼              ▼
    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
    │       DTO       │◄──►│   Validation    │◄──►│   Exception     │
    │   (TicketDTO)   │    │   (Jakarta)     │    │   (Handlers)    │
    │  (MessageDTO)   │    │ Bean Validation │    │ GlobalException │
    │   (FAQDTO)      │    │  ValidationUtil │    │  ErrorResponse  │
    │(CategoryDTO)    │    └─────────────────┘    └─────────────────┘
    └─────────┬───────┘                               
              │
              ▼
    ┌─────────────────────────────────────────────────────────────┐
    │                    ⚡ SERVICE LAYER                          │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
    │  │  TicketService  │  │ MessageService  │  │ FAQService  │ │
    │  │ (Business Logic)│  │ (Business Logic)│  │ (Business)  │ │
    │  └─────────┬───────┘  └─────────┬───────┘  └─────┬───────┘ │
    │  ┌─────────────────┐  ┌─────────────────────────────────┐ │
    │  │TicketCategory   │  │        Config Services         │ │
    │  │    Service      │  │  (Cache, CORS, Security, etc)  │ │
    │  └─────────────────┘  └─────────────────────────────────┘ │
    └────────────┼──────────────────────┼──────────────┼───────────┘
                 │                      │              │
                 ▼                      ▼              ▼
    ┌─────────────────────────────────────────────────────────────┐
    │                  🗄️ REPOSITORY LAYER                        │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
    │  │TicketRepository │  │MessageRepository│  │FAQRepository│ │
    │  │  (Data Access)  │  │  (Data Access)  │  │(Data Access)│ │
    │  └─────────┬───────┘  └─────────┬───────┘  └─────┬───────┘ │
    │  ┌─────────────────┐  ┌─────────────────────────────────┐ │
    │  │TicketCategory   │  │         JPA/ORM                │ │
    │  │   Repository    │  │       (Hibernate)              │ │
    │  └─────────────────┘  └─────────────────────────────────┘ │
    └────────────┼──────────────────────┼──────────────┼───────────┘
                 │                      │              │
                 ▼                      ▼              ▼
    ┌─────────────────────────────────────────────────────────────┐
    │                    📊 MODEL LAYER                           │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
    │  │     Ticket      │◄─┤     Message     │  │     FAQ     │ │
    │  │    (Entity)     │  │    (Entity)     │  │  (Entity)   │ │
    │  │     @Entity     │  │     @Entity     │  │   @Entity   │ │
    │  └─────────┬───────┘  └─────────────────┘  └─────────────┘ │
    │  ┌─────────────────┐  ┌─────────────────────────────────┐ │
    │  │ TicketCategory  │  │        Utility Classes         │ │
    │  │   (Entity)      │  │   (AuditLogger, ValidationUtil) │ │
    │  │   @Entity       │  └─────────────────────────────────┘ │
    │  └─────────────────┘                                     │
    └─────────────────────────┼───────────────────────────────────┘
                              │
                              ▼
    ┌─────────────────────────────────────────────────────────────┐
    │                🐘 DATABASE LAYER                            │
    │                                                             │
    │        PostgreSQL 16.8 (Railway Cloud Production)          │
    │                                                             │
    │  Tables: Tickets, Messages, FAQs, TicketCategories        │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
    │  │    Tickets      │  │    Messages     │  │    FAQs     │ │
    │  │ (Primary Table) │◄─┤ (Linked to     │  │(Knowledge   │ │
    │  │                 │  │   Tickets)      │  │    Base)    │ │
    │  └─────────────────┘  └─────────────────┘  └─────────────┘ │
    │  ┌─────────────────┐                                       │
    │  │TicketCategories │                                       │
    │  │  (Lookup Table) │                                       │
    │  └─────────────────┘                                       │
    └─────────────────────────────────────────────────────────────┘
```

### 🔗 Flujo de Datos del Support Service

```
1. 🌐 HTTP Request → Controller Layer
2. 🎯 Controller → DTO Validation & Exception Handling  
3. ⚡ Service → Business Logic Processing
4. 🗄️ Repository → JPA/Hibernate ORM
5. 📊 Model → Entity Mapping  
6. 🐘 Database → PostgreSQL Storage
```

### 🛠️ Componentes Clave

| Capa | Componentes | Responsabilidad |
|------|-------------|-----------------|
| **🎯 Controller** | TicketController, MessageController, FAQController, CategoryController, TicketCategoryController | Manejo de requests HTTP y responses |
| **📋 DTO** | TicketDTO, MessageDTO, FAQDTO, TicketCategoryDTO | Transferencia y validación de datos |
| **⚡ Service** | TicketService, MessageService, FAQService, TicketCategoryService | Lógica de negocio y reglas empresariales |
| **🗄️ Repository** | TicketRepository, MessageRepository, FAQRepository, TicketCategoryRepository | Acceso a datos y operaciones CRUD |
| **📊 Model** | Ticket, Message, FAQ, TicketCategory | Entidades del dominio |
| **🛡️ Config** | CacheConfig, CorsConfig, SecurityConfig, EncodingConfig, SecurityHeadersConfig, DataInitializer | Configuraciones del sistema |
| **🔧 Util** | AuditLogger, ValidationUtil | Utilidades del sistema |
| **🚨 Exception** | GlobalExceptionHandler, ResourceNotFoundException, ErrorResponse | Manejo de errores |
| **🐘 Database** | PostgreSQL en Railway | Persistencia de datos |

### 📊 Relaciones Entre Entidades

```
TicketCategory (1) ──────────────► (N) Ticket
                                       │
                                       │ (1)
                                       ▼
                                   (N) Message
                                       
FAQ (N) ◄──────────────────────── (1) TicketCategory
```

**Relaciones del Modelo:**
- **TicketCategory → Ticket**: Una categoría puede tener múltiples tickets
- **Ticket → Message**: Un ticket puede tener múltiples mensajes  
- **TicketCategory → FAQ**: Una categoría puede tener múltiples FAQs
- **Message**: Entidad independiente vinculada a tickets específicos

---

<div align="center">

**🌟 ¡Gracias por usar EduTech Support Service! 🌟**

*Desarrollado por **Felipe López***

Para más información, visita nuestra [documentación completa](https://github.com/feliplvz/edutech-support-service)

[![API Status](https://img.shields.io/badge/API-Online-brightgreen.svg)](http://localhost:8084/)
[![Last Updated](https://img.shields.io/badge/Updated-Junio%202025-blue.svg)](https://github.com/feliplvz/support-service)
[![Developer](https://img.shields.io/badge/Developer-Felipe%20López-purple.svg)](https://github.com/feliplvz)

</div>

## 🧪 Testing y Validación

### 🚀 Pruebas Funcionales
Este proyecto incluye pruebas unitarias y de integración:

```bash
📂 src/test/                           # Directorio de pruebas
├── 📂 java/com/edutech/supportservice/
│   ├── 📂 controller/                # Pruebas de controladores
│   │   ├── 🧪 TicketControllerTest.java
│   │   ├── 🧪 MessageControllerTest.java
│   │   └── 🧪 FAQControllerTest.java
│   ├── 📂 service/                   # Pruebas de servicios
│   │   ├── 🧪 TicketServiceTest.java
│   │   └── 🧪 MessageServiceTest.java
│   ├── 📂 integration/              # Pruebas de integración
│   │   └── 🧪 TicketControllerIntegrationTest.java
│   └── 🧪 SupportServiceApplicationTests.java # Pruebas de carga de contexto
└── 📂 resources/                    # Recursos para pruebas
    └── 📄 application-test.properties # Configuración de test
```

### 🗂️ Estructura de Tests
- 🏥 **Health Check & Monitoring** (2 tests)
- 🎫 **Tickets Management** (15+ tests) - CRUD completo
- 📝 **Messages Management** (10+ tests) - Comunicación
- ❓ **FAQs Management** (8+ tests) - Base de conocimiento
- ❌ **Error Handling Tests** (5+ tests) - Casos edge
- 🧪 **Integration Tests** (5+ tests) - Flujos completos

### 🚀 Ejecución de Tests
```bash
# Ejecución completa
mvn test

# Ejecución de tests específicos
mvn test -Dtest=TicketControllerTest

# Cobertura de tests
mvn test jacoco:report
```

### ✅ Validaciones Automáticas
- Validaciones automáticas de respuesta
- Tests de códigos de estado HTTP
- Verificación de estructura JSON
- Manejo de transacciones en pruebas

---

## 📈 Métricas y Monitoreo

### 📊 Datos de Demostración
#### 🏷️ Categorías de Tickets Preconfiguradas
| ID | Categoría | Descripción | Estado |
|----|-----------|-------------|--------|
| 1 | **💻 Problemas Técnicos** | Problemas técnicos con la plataforma | Activo |
| 2 | **💳 Facturación** | Problemas con pagos o suscripciones | Activo |
| 3 | **📚 Contenido** | Problemas con el contenido de los cursos | Activo |
| 4 | **❓ General** | Consultas generales sobre la plataforma | Activo |

#### 🎫 Estados de Tickets
- **🆕 NUEVO** - Ticket recién creado
- **🔄 ASIGNADO** - Asignado a personal de soporte
- **⏳ EN_PROGRESO** - En proceso de resolución
- **⏸️ EN_ESPERA** - Esperando respuesta del usuario
- **✅ RESUELTO** - Problema solucionado
- **🚫 CERRADO** - Ticket finalizado

### 🎯 Métricas de Calidad
- **🔍 Cobertura de Funcionalidades**: 100%
- **⚡ Performance de API**: Optimizada
- **🛡️ Manejo de Errores**: Empresarial
- **📊 Calidad de Código**: Alta
- **🌐 Preparación para Producción**: Completa

### 🏥 Health Monitoring
- **📊 Health Checks**: Endpoints de actuator para monitoreo
- **📝 Logging Estructurado**: Logs informativos y de auditoría
- **🔍 Error Tracking**: Respuestas de error consistentes y detalladas
- **🗄️ Database Monitoring**: Validación automática de conexiones

---

## 🔒 Seguridad

### 🛡️ Validaciones y Protección
- ✅ **Validación de Entrada**: Bean Validation con mensajes personalizados
- ✅ **Manejo de Excepciones**: GlobalExceptionHandler empresarial
- ✅ **Headers de Seguridad**: Configuración de cabeceras HTTP
- ✅ **Encoding UTF-8**: Manejo adecuado de caracteres especiales

### 🔐 Gestión de Credenciales
- ✅ **Variables de Entorno**: Credenciales nunca en código fuente
- ✅ **GitIgnore Seguro**: Archivos sensibles excluidos del repositorio
- ✅ **Separación de Entornos**: Configuraciones por ambiente

### 🌐 Configuración CORS
- ✅ **CORS Empresarial**: Configuración avanzada para integración
- ✅ **Headers Permitidos**: Content-Type, Authorization
- ✅ **Métodos HTTP**: GET, POST, PUT, PATCH, DELETE
- ✅ **Orígenes Configurables**: Para desarrollo y producción

### 🔐 Mejores Prácticas Implementadas
- ✅ **Validación Robusta**: Datos de entrada siempre validados
- ✅ **Error Handling**: Respuestas consistentes y seguras
- ✅ **SQL Injection**: Protección mediante JPA/Hibernate
- ✅ **XSS Prevention**: Validación de contenido HTML
- ✅ **Secrets Management**: Variables de entorno para credenciales
- ✅ **Environment Separation**: Configuraciones por entorno
