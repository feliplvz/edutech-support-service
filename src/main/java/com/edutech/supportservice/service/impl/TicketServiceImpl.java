package com.edutech.supportservice.service.impl;

import com.edutech.supportservice.dto.MessageDTO;
import com.edutech.supportservice.dto.TicketDTO;
import com.edutech.supportservice.exception.ResourceNotFoundException;
import com.edutech.supportservice.model.Message;
import com.edutech.supportservice.model.Ticket;
import com.edutech.supportservice.model.TicketCategory;
import com.edutech.supportservice.repository.MessageRepository;
import com.edutech.supportservice.repository.TicketCategoryRepository;
import com.edutech.supportservice.repository.TicketRepository;
import com.edutech.supportservice.service.TicketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class TicketServiceImpl implements TicketService {

    private final TicketRepository ticketRepository;
    private final TicketCategoryRepository categoryRepository;
    private final MessageRepository messageRepository;

    @Autowired
    public TicketServiceImpl(TicketRepository ticketRepository,
                            TicketCategoryRepository categoryRepository,
                            MessageRepository messageRepository) {
        this.ticketRepository = ticketRepository;
        this.categoryRepository = categoryRepository;
        this.messageRepository = messageRepository;
    }

    @Override
    public List<TicketDTO> getAllTickets() {
        return ticketRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public Page<TicketDTO> getTicketsPaginated(Pageable pageable) {
        return ticketRepository.findAll(pageable)
                .map(this::convertToDTO);
    }

    @Override
    public TicketDTO getTicketById(Long id) {
        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket", "id", id));
        return convertToDTO(ticket);
    }

    @Override
    public List<TicketDTO> getTicketsByUser(Long userId) {
        return ticketRepository.findByUserId(userId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<TicketDTO> getTicketsByAssignedTo(Long staffId) {
        return ticketRepository.findByAssignedToId(staffId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<TicketDTO> getTicketsByStatus(String status) {
        return ticketRepository.findByStatus(status).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<TicketDTO> getTicketsByCategory(Long categoryId) {
        if (!categoryRepository.existsById(categoryId)) {
            throw new ResourceNotFoundException("Categoría", "id", categoryId);
        }
        return ticketRepository.findByCategoryId(categoryId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<TicketDTO> getTicketsByCourse(Long courseId) {
        return ticketRepository.findByCourseId(courseId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public Page<TicketDTO> searchTickets(String keyword, Pageable pageable) {
        return ticketRepository.searchByKeyword(keyword, pageable)
                .map(this::convertToDTO);
    }

    @Override
    @Transactional
    public TicketDTO createTicket(TicketDTO ticketDTO) {
        TicketCategory category = null;
        if (ticketDTO.getCategoryId() != null) {
            category = categoryRepository.findById(ticketDTO.getCategoryId())
                    .orElseThrow(() -> new ResourceNotFoundException("Categoría", "id", ticketDTO.getCategoryId()));
        }

        Ticket ticket = new Ticket();
        ticket.setTitle(ticketDTO.getTitle());
        ticket.setDescription(ticketDTO.getDescription());
        ticket.setUserId(ticketDTO.getUserId());
        ticket.setUserEmail(ticketDTO.getUserEmail());
        ticket.setUserName(ticketDTO.getUserName());
        ticket.setUserType(ticketDTO.getUserType());
        ticket.setCourseId(ticketDTO.getCourseId());
        ticket.setCourseName(ticketDTO.getCourseName());
        ticket.setCategory(category);

        // Valores por defecto
        ticket.setStatus("NUEVO");
        ticket.setPriority(ticketDTO.getPriority() != null ? ticketDTO.getPriority() : "MEDIA");

        Ticket savedTicket = ticketRepository.save(ticket);

        // Si hay un mensaje inicial, añadirlo
        if (ticketDTO.getMessages() != null && !ticketDTO.getMessages().isEmpty()) {
            MessageDTO initialMessageDTO = ticketDTO.getMessages().get(0);
            Message initialMessage = new Message();
            initialMessage.setTicket(savedTicket);
            initialMessage.setContent(initialMessageDTO.getContent());
            initialMessage.setSenderId(ticketDTO.getUserId());
            initialMessage.setSenderName(ticketDTO.getUserName());
            initialMessage.setSenderEmail(ticketDTO.getUserEmail());
            initialMessage.setSenderType("USUARIO");
            initialMessage.setIsInternalNote(false);
            messageRepository.save(initialMessage);
        }

        return convertToDTO(savedTicket);
    }

    @Override
    @Transactional
    public TicketDTO updateTicket(Long id, TicketDTO ticketDTO) {
        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket", "id", id));

        TicketCategory category = null;
        if (ticketDTO.getCategoryId() != null &&
            (ticket.getCategory() == null || !ticket.getCategory().getId().equals(ticketDTO.getCategoryId()))) {
            category = categoryRepository.findById(ticketDTO.getCategoryId())
                    .orElseThrow(() -> new ResourceNotFoundException("Categoría", "id", ticketDTO.getCategoryId()));
            ticket.setCategory(category);
        }

        ticket.setTitle(ticketDTO.getTitle());
        ticket.setDescription(ticketDTO.getDescription());

        if (ticketDTO.getPriority() != null && !ticketDTO.getPriority().equals(ticket.getPriority())) {
            ticket.setPriority(ticketDTO.getPriority());
        }

        Ticket updatedTicket = ticketRepository.save(ticket);
        return convertToDTO(updatedTicket);
    }

    @Override
    @Transactional
    public TicketDTO assignTicket(Long id, Long staffId) {
        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket", "id", id));

        ticket.setAssignedToId(staffId);

        // Si el estado es NUEVO, cambiarlo a ASIGNADO
        if ("NUEVO".equals(ticket.getStatus())) {
            ticket.setStatus("ASIGNADO");
        }

        Ticket updatedTicket = ticketRepository.save(ticket);
        return convertToDTO(updatedTicket);
    }

    @Override
    @Transactional
    public TicketDTO changeTicketStatus(Long id, String status) {
        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket", "id", id));

        // Validar que el estado sea válido
        if (!isValidStatus(status)) {
            throw new IllegalArgumentException("Estado de ticket inválido: " + status);
        }

        ticket.setStatus(status);

        // Si el estado cambia a CERRADO, registrar la fecha de cierre
        if ("CERRADO".equals(status) && ticket.getClosedAt() == null) {
            ticket.setClosedAt(LocalDateTime.now());
        }

        Ticket updatedTicket = ticketRepository.save(ticket);
        return convertToDTO(updatedTicket);
    }

    @Override
    @Transactional
    public TicketDTO changeTicketPriority(Long id, String priority) {
        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket", "id", id));

        // Validar que la prioridad sea válida
        if (!isValidPriority(priority)) {
            throw new IllegalArgumentException("Prioridad de ticket inválida: " + priority);
        }

        ticket.setPriority(priority);
        Ticket updatedTicket = ticketRepository.save(ticket);
        return convertToDTO(updatedTicket);
    }

    @Override
    @Transactional
    public TicketDTO rateTicket(Long id, Integer rating, String feedback) {
        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket", "id", id));

        // Validar que el ticket esté cerrado
        if (!"CERRADO".equals(ticket.getStatus())) {
            throw new IllegalStateException("Solo se pueden calificar tickets cerrados");
        }

        // Validar que la calificación sea válida (1-5)
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("La calificación debe estar entre 1 y 5");
        }

        ticket.setSatisfactionRating(rating);
        ticket.setFeedback(feedback);

        Ticket updatedTicket = ticketRepository.save(ticket);
        return convertToDTO(updatedTicket);
    }

    @Override
    @Transactional
    public void deleteTicket(Long id) {
        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket", "id", id));

        // Primero eliminar los mensajes asociados para evitar problemas de clave foránea
        messageRepository.findByTicketId(id).forEach(messageRepository::delete);

        ticketRepository.delete(ticket);
    }

    @Override
    public Map<String, Integer> getTicketStatusCounts() {
        Map<String, Integer> statusCounts = new HashMap<>();
        List<Object[]> results = ticketRepository.getTicketCountsByStatus();

        for (Object[] result : results) {
            String status = (String) result[0];
            Long count = (Long) result[1];
            statusCounts.put(status, count.intValue());
        }

        return statusCounts;
    }

    @Override
    public Map<String, Integer> getTicketPriorityCounts() {
        Map<String, Integer> priorityCounts = new HashMap<>();
        List<Object[]> results = ticketRepository.getTicketCountsByPriority();

        for (Object[] result : results) {
            String priority = (String) result[0];
            Long count = (Long) result[1];
            priorityCounts.put(priority, count.intValue());
        }

        return priorityCounts;
    }

    @Override
    public Map<String, Integer> getTicketCategoryCounts() {
        Map<String, Integer> categoryCounts = new HashMap<>();
        List<Object[]> results = ticketRepository.getTicketCountsByCategory();

        for (Object[] result : results) {
            String category = (String) result[0];
            if (category != null) {
                Long count = (Long) result[1];
                categoryCounts.put(category, count.intValue());
            }
        }

        return categoryCounts;
    }

    @Override
    public Double getAverageResolutionTime() {
        return ticketRepository.getAverageResolutionTimeInDays();
    }

    @Override
    public Double getAverageSatisfactionRating() {
        return ticketRepository.getAverageSatisfactionRating();
    }

    // Método auxiliar para validar estados de ticket
    private boolean isValidStatus(String status) {
        return "NUEVO".equals(status) ||
               "ASIGNADO".equals(status) ||
               "EN_PROGRESO".equals(status) ||
               "RESUELTO".equals(status) ||
               "CERRADO".equals(status);
    }

    // Método auxiliar para validar prioridades de ticket
    private boolean isValidPriority(String priority) {
        return "BAJA".equals(priority) ||
               "MEDIA".equals(priority) ||
               "ALTA".equals(priority) ||
               "CRÍTICA".equals(priority);
    }

    // Método para convertir una entidad Ticket a DTO
    private TicketDTO convertToDTO(Ticket ticket) {
        TicketDTO dto = new TicketDTO();
        dto.setId(ticket.getId());
        dto.setTitle(ticket.getTitle());
        dto.setDescription(ticket.getDescription());
        dto.setStatus(ticket.getStatus());
        dto.setPriority(ticket.getPriority());
        dto.setUserId(ticket.getUserId());
        dto.setUserEmail(ticket.getUserEmail());
        dto.setUserName(ticket.getUserName());
        dto.setUserType(ticket.getUserType());
        dto.setAssignedToId(ticket.getAssignedToId());
        dto.setCourseId(ticket.getCourseId());
        dto.setCourseName(ticket.getCourseName());
        dto.setCreatedAt(ticket.getCreatedAt());
        dto.setUpdatedAt(ticket.getUpdatedAt());
        dto.setClosedAt(ticket.getClosedAt());
        dto.setSatisfactionRating(ticket.getSatisfactionRating());
        dto.setFeedback(ticket.getFeedback());

        if (ticket.getCategory() != null) {
            dto.setCategoryId(ticket.getCategory().getId());
            dto.setCategoryName(ticket.getCategory().getName());
        }

        // Calcular tiempo de respuesta en minutos (si hay mensajes)
        if (!ticket.getMessages().isEmpty() && ticket.getMessages().size() > 1) {
            LocalDateTime firstUserMessage = null;
            LocalDateTime firstStaffResponse = null;

            for (Message message : ticket.getMessages()) {
                if (firstUserMessage == null && "USUARIO".equals(message.getSenderType())) {
                    firstUserMessage = message.getCreatedAt();
                } else if (firstStaffResponse == null && "SOPORTE".equals(message.getSenderType()) && firstUserMessage != null) {
                    firstStaffResponse = message.getCreatedAt();
                    break;
                }
            }

            if (firstUserMessage != null && firstStaffResponse != null) {
                long responseTimeMinutes = java.time.Duration.between(firstUserMessage, firstStaffResponse).toMinutes();
                dto.setResponseTimeMinutes((int) responseTimeMinutes);
            }
        }

        // Contar mensajes
        dto.setMessageCount(ticket.getMessages().size());

        return dto;
    }
}
