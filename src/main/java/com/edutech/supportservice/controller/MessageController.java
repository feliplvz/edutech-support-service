package com.edutech.supportservice.controller;

import com.edutech.supportservice.dto.MessageDTO;
import com.edutech.supportservice.service.MessageService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/messages")
public class MessageController {

    private final MessageService messageService;

    @Autowired
    public MessageController(MessageService messageService) {
        this.messageService = messageService;
    }

    @GetMapping("/ticket/{ticketId}")
    public ResponseEntity<List<MessageDTO>> getMessagesByTicket(@PathVariable Long ticketId) {
        return ResponseEntity.ok(messageService.getMessagesByTicket(ticketId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<MessageDTO> getMessageById(@PathVariable Long id) {
        return ResponseEntity.ok(messageService.getMessageById(id));
    }

    @PostMapping
    public ResponseEntity<MessageDTO> createMessage(@Valid @RequestBody MessageDTO messageDTO) {
        return new ResponseEntity<>(messageService.createMessage(messageDTO), HttpStatus.CREATED);
    }

    @PostMapping("/internal-note")
    public ResponseEntity<MessageDTO> createInternalNote(@Valid @RequestBody MessageDTO messageDTO) {
        return new ResponseEntity<>(messageService.createInternalNote(messageDTO), HttpStatus.CREATED);
    }

    @PatchMapping("/{id}/mark-read")
    public ResponseEntity<Void> markMessageAsRead(@PathVariable Long id) {
        messageService.markMessageAsRead(id);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/ticket/{ticketId}/mark-all-read")
    public ResponseEntity<Void> markAllTicketMessagesAsRead(
            @PathVariable Long ticketId,
            @RequestParam Long userId) {
        messageService.markAllTicketMessagesAsRead(ticketId, userId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/ticket/{ticketId}/unread-count")
    public ResponseEntity<Map<String, Integer>> countUnreadMessagesByTicket(
            @PathVariable Long ticketId,
            @RequestParam Long userId) {
        Integer count = messageService.countUnreadMessagesByTicket(ticketId, userId);
        return ResponseEntity.ok(Map.of("unreadCount", count));
    }

    @GetMapping("/ticket/{ticketId}/internal-notes")
    public ResponseEntity<List<MessageDTO>> getInternalNotesByTicket(@PathVariable Long ticketId) {
        return ResponseEntity.ok(messageService.getInternalNotesByTicket(ticketId));
    }

    @GetMapping("/stats/avg-messages-per-ticket")
    public ResponseEntity<Map<String, Double>> getAverageMessagesPerTicket() {
        Double avg = messageService.getAverageMessagesPerTicket();
        return ResponseEntity.ok(Map.of("averageMessagesPerTicket", avg != null ? avg : 0));
    }
}
