package com.edutech.supportservice.service.impl;

import com.edutech.supportservice.dto.MessageDTO;
import com.edutech.supportservice.exception.ResourceNotFoundException;
import com.edutech.supportservice.model.Message;
import com.edutech.supportservice.model.Ticket;
import com.edutech.supportservice.repository.MessageRepository;
import com.edutech.supportservice.repository.TicketRepository;
import com.edutech.supportservice.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class MessageServiceImpl implements MessageService {

    private final MessageRepository messageRepository;
    private final TicketRepository ticketRepository;

    @Autowired
    public MessageServiceImpl(MessageRepository messageRepository, TicketRepository ticketRepository) {
        this.messageRepository = messageRepository;
        this.ticketRepository = ticketRepository;
    }

    @Override
    public List<MessageDTO> getMessagesByTicket(Long ticketId) {
        if (!ticketRepository.existsById(ticketId)) {
            throw new ResourceNotFoundException("Ticket", "id", ticketId);
        }

        return messageRepository.findByTicketIdOrderByCreatedAtAsc(ticketId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public MessageDTO getMessageById(Long id) {
        Message message = messageRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Mensaje", "id", id));
        return convertToDTO(message);
    }

    @Override
    @Transactional
    public MessageDTO createMessage(MessageDTO messageDTO) {
        Ticket ticket = ticketRepository.findById(messageDTO.getTicketId())
                .orElseThrow(() -> new ResourceNotFoundException("Ticket", "id", messageDTO.getTicketId()));

        Message message = new Message();
        message.setTicket(ticket);
        message.setContent(messageDTO.getContent());
        message.setSenderId(messageDTO.getSenderId());
        message.setSenderName(messageDTO.getSenderName());
        message.setSenderEmail(messageDTO.getSenderEmail());
        message.setSenderType(messageDTO.getSenderType());
        message.setAttachmentUrl(messageDTO.getAttachmentUrl());
        message.setAttachmentType(messageDTO.getAttachmentType());
        message.setIsInternalNote(false);
        message.setIsRead(false);

        Message savedMessage = messageRepository.save(message);

        // Actualizar el estado del ticket si es necesario
        if ("ASIGNADO".equals(ticket.getStatus()) && "SOPORTE".equals(messageDTO.getSenderType())) {
            ticket.setStatus("EN_PROGRESO");
            ticketRepository.save(ticket);
        }

        return convertToDTO(savedMessage);
    }

    @Override
    @Transactional
    public MessageDTO createInternalNote(MessageDTO messageDTO) {
        Ticket ticket = ticketRepository.findById(messageDTO.getTicketId())
                .orElseThrow(() -> new ResourceNotFoundException("Ticket", "id", messageDTO.getTicketId()));

        // Validar que el remitente sea personal de soporte
        if (!"SOPORTE".equals(messageDTO.getSenderType()) && !"SISTEMA".equals(messageDTO.getSenderType())) {
            throw new IllegalArgumentException("Solo el personal de soporte puede crear notas internas");
        }

        Message message = new Message();
        message.setTicket(ticket);
        message.setContent(messageDTO.getContent());
        message.setSenderId(messageDTO.getSenderId());
        message.setSenderName(messageDTO.getSenderName());
        message.setSenderEmail(messageDTO.getSenderEmail());
        message.setSenderType(messageDTO.getSenderType());
        message.setAttachmentUrl(messageDTO.getAttachmentUrl());
        message.setAttachmentType(messageDTO.getAttachmentType());
        message.setIsInternalNote(true);
        message.setIsRead(false);

        Message savedMessage = messageRepository.save(message);
        return convertToDTO(savedMessage);
    }

    @Override
    @Transactional
    public void markMessageAsRead(Long messageId) {
        Message message = messageRepository.findById(messageId)
                .orElseThrow(() -> new ResourceNotFoundException("Mensaje", "id", messageId));

        message.setIsRead(true);
        messageRepository.save(message);
    }

    @Override
    @Transactional
    public void markAllTicketMessagesAsRead(Long ticketId, Long userId) {
        if (!ticketRepository.existsById(ticketId)) {
            throw new ResourceNotFoundException("Ticket", "id", ticketId);
        }

        List<Message> unreadMessages = messageRepository.findUnreadMessagesByTicketForUser(ticketId, userId);

        for (Message message : unreadMessages) {
            message.setIsRead(true);
            messageRepository.save(message);
        }
    }

    @Override
    public Integer countUnreadMessagesByTicket(Long ticketId, Long userId) {
        if (!ticketRepository.existsById(ticketId)) {
            throw new ResourceNotFoundException("Ticket", "id", ticketId);
        }

        return messageRepository.findUnreadMessagesByTicketForUser(ticketId, userId).size();
    }

    @Override
    public List<MessageDTO> getInternalNotesByTicket(Long ticketId) {
        if (!ticketRepository.existsById(ticketId)) {
            throw new ResourceNotFoundException("Ticket", "id", ticketId);
        }

        return messageRepository.findInternalNotesByTicketId(ticketId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public Double getAverageMessagesPerTicket() {
        return messageRepository.getAverageMessagesPerTicket();
    }

    // Método para convertir una entidad Message a DTO
    private MessageDTO convertToDTO(Message message) {
        MessageDTO dto = new MessageDTO();
        dto.setId(message.getId());
        dto.setContent(message.getContent());
        dto.setSenderId(message.getSenderId());
        dto.setSenderName(message.getSenderName());
        dto.setSenderEmail(message.getSenderEmail());
        dto.setSenderType(message.getSenderType());
        dto.setAttachmentUrl(message.getAttachmentUrl());
        dto.setAttachmentType(message.getAttachmentType());
        dto.setIsInternalNote(message.getIsInternalNote());
        dto.setCreatedAt(message.getCreatedAt());
        dto.setTicketId(message.getTicket().getId());
        dto.setIsRead(message.getIsRead());
        return dto;
    }
}
