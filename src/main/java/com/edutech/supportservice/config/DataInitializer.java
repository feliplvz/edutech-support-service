package com.edutech.supportservice.config;

import com.edutech.supportservice.model.FAQ;
import com.edutech.supportservice.model.TicketCategory;
import com.edutech.supportservice.repository.FAQRepository;
import com.edutech.supportservice.repository.TicketCategoryRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * Inicializa la base de datos con datos básicos necesarios para el funcionamiento del sistema.
 */
@Slf4j
@Component
public class DataInitializer implements CommandLineRunner {

    private final TicketCategoryRepository categoryRepository;
    private final FAQRepository faqRepository;

    @Autowired
    public DataInitializer(TicketCategoryRepository categoryRepository, FAQRepository faqRepository) {
        this.categoryRepository = categoryRepository;
        this.faqRepository = faqRepository;
    }

    @Override
    @Transactional
    public void run(String... args) throws Exception {
        log.info("Iniciando carga de datos básicos...");
        
        initializeCategories();
        initializeFAQs();
        
        log.info("Carga de datos básicos completada.");
    }

    private void initializeCategories() {
        if (categoryRepository.count() == 0) {
            log.info("Creando categorías de tickets por defecto...");
            
            // Crear categorías una por una para respetar la estructura de la entidad
            createTicketCategory("Problemas Técnicos", "Problemas con la plataforma o cursos", 24);
            createTicketCategory("Consultas Académicas", "Preguntas relacionadas con contenidos de cursos", 48);
            createTicketCategory("Facturación", "Consultas sobre pagos y facturación", 24);
            createTicketCategory("Otros", "Otras consultas generales", 72);
            
            log.info("Se crearon 4 categorías de tickets");
        } else {
            log.info("Las categorías ya existen en la base de datos");
        }
    }
    
    private TicketCategory createTicketCategory(String name, String description, Integer expectedTime) {
        TicketCategory category = new TicketCategory();
        category.setName(name);
        category.setDescription(description);
        category.setActive(true);
        category.setExpectedResolutionTimeHours(expectedTime);
        return categoryRepository.save(category);
    }

    private void initializeFAQs() {
        if (faqRepository.count() == 0) {
            log.info("Creando FAQs por defecto...");
            
            TicketCategory tecnicosCategory = categoryRepository.findByName("Problemas Técnicos").orElse(null);
            TicketCategory academicosCategory = categoryRepository.findByName("Consultas Académicas").orElse(null);
            TicketCategory facturacionCategory = categoryRepository.findByName("Facturación").orElse(null);

            FAQ[] faqs = {
                createFAQ("¿Cómo puedo restablecer mi contraseña?",
                    "Puedes restablecer tu contraseña haciendo clic en \"¿Olvidaste tu contraseña?\" en la página de inicio de sesión y siguiendo las instrucciones.",
                    tecnicosCategory, "contraseña, restablecer, olvidé, recuperar", 0),
                    
                createFAQ("¿Cómo puedo obtener un certificado?",
                    "Los certificados se generan automáticamente al completar el 100% del curso y aprobar todas las evaluaciones. Puedes descargarlos desde tu perfil.",
                    academicosCategory, "certificado, diploma, completar curso", 1),
                    
                createFAQ("¿Cuáles son las formas de pago aceptadas?",
                    "Aceptamos tarjetas de crédito/débito (Visa, Mastercard, American Express), PayPal y transferencias bancarias. Para más información, contacta a soporte.",
                    facturacionCategory, "pago, factura, tarjeta, paypal, transferencia", 0),
                    
                createFAQ("¿Cómo puedo acceder a mi curso después de la compra?",
                    "Una vez completada la compra, recibirás un email de confirmación. Inicia sesión en tu cuenta y encontrarás el curso en tu panel de estudiante.",
                    academicosCategory, "acceso, curso, compra, panel estudiante", 2),
                    
                createFAQ("¿Puedo obtener un reembolso?",
                    "Ofrecemos reembolsos dentro de los primeros 30 días de la compra si no estás satisfecho con el curso. Contacta a nuestro equipo de soporte para procesar tu solicitud.",
                    facturacionCategory, "reembolso, devolución, dinero, satisfecho", 1),
                    
                createFAQ("¿Los cursos tienen fecha de vencimiento?",
                    "No, una vez que compras un curso, tienes acceso de por vida al contenido y a todas las actualizaciones futuras.",
                    academicosCategory, "vencimiento, acceso, por vida, actualizaciones", 3)
            };

            for (FAQ faq : faqs) {
                // Simular algunas visualizaciones y votos
                faq.setViewCount((int) (Math.random() * 150) + 20);
                faq.setHelpfulVotes((int) (Math.random() * 50) + 10);
                faq.setUnhelpfulVotes((int) (Math.random() * 10) + 1);
                faq.setPublished(true);
                
                faqRepository.save(faq);
                log.debug("FAQ creada: {}", faq.getQuestion());
            }
            
            log.info("Se crearon {} FAQs", faqs.length);
        } else {
            log.info("Las FAQs ya existen en la base de datos");
        }
    }

    private FAQ createFAQ(String question, String answer, TicketCategory category, String keywords, int displayOrder) {
        FAQ faq = new FAQ();
        faq.setQuestion(question);
        faq.setAnswer(answer);
        faq.setCategory(category);
        faq.setSearchKeywords(keywords);
        faq.setDisplayOrder(displayOrder);
        return faq;
    }
}
