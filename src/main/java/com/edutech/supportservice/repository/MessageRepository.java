package com.edutech.supportservice.repository;

import com.edutech.supportservice.model.Message;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long> {

    List<Message> findByTicketId(Long ticketId);

    Page<Message> findByTicketId(Long ticketId, Pageable pageable);

    List<Message> findByTicketIdOrderByCreatedAtAsc(Long ticketId);

    List<Message> findBySenderId(Long senderId);

    @Query("SELECT m FROM Message m WHERE m.ticket.id = :ticketId AND m.isInternalNote = true")
    List<Message> findInternalNotesByTicketId(@Param("ticketId") Long ticketId);

    @Query("SELECT m FROM Message m WHERE m.ticket.id = :ticketId AND m.isRead = false AND m.senderId != :userId")
    List<Message> findUnreadMessagesByTicketForUser(@Param("ticketId") Long ticketId, @Param("userId") Long userId);

    @Query("SELECT COUNT(m) FROM Message m WHERE m.isInternalNote = false")
    Integer countPublicMessages();

    @Query("SELECT AVG(SIZE(t.messages)) FROM Ticket t")
    Double getAverageMessagesPerTicket();
}
