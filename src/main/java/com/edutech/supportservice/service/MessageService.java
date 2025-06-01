package com.edutech.supportservice.service;

import com.edutech.supportservice.dto.MessageDTO;

import java.util.List;

public interface MessageService {

    List<MessageDTO> getMessagesByTicket(Long ticketId);

    MessageDTO getMessageById(Long id);

    MessageDTO createMessage(MessageDTO messageDTO);

    MessageDTO createInternalNote(MessageDTO messageDTO);

    void markMessageAsRead(Long messageId);

    void markAllTicketMessagesAsRead(Long ticketId, Long userId);

    Integer countUnreadMessagesByTicket(Long ticketId, Long userId);

    List<MessageDTO> getInternalNotesByTicket(Long ticketId);

    Double getAverageMessagesPerTicket();
}
