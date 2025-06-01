package com.edutech.supportservice.service;

import com.edutech.supportservice.dto.TicketDTO;

import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface TicketService {

    List<TicketDTO> getAllTickets();

    Page<TicketDTO> getTicketsPaginated(Pageable pageable);

    TicketDTO getTicketById(Long id);

    List<TicketDTO> getTicketsByUser(Long userId);

    List<TicketDTO> getTicketsByAssignedTo(Long staffId);

    List<TicketDTO> getTicketsByStatus(String status);

    List<TicketDTO> getTicketsByCategory(Long categoryId);

    List<TicketDTO> getTicketsByCourse(Long courseId);

    Page<TicketDTO> searchTickets(String keyword, Pageable pageable);

    TicketDTO createTicket(TicketDTO ticketDTO);

    TicketDTO updateTicket(Long id, TicketDTO ticketDTO);

    TicketDTO assignTicket(Long id, Long staffId);

    TicketDTO changeTicketStatus(Long id, String status);

    TicketDTO changeTicketPriority(Long id, String priority);

    TicketDTO rateTicket(Long id, Integer rating, String feedback);

    void deleteTicket(Long id);

    Map<String, Integer> getTicketStatusCounts();

    Map<String, Integer> getTicketPriorityCounts();

    Map<String, Integer> getTicketCategoryCounts();

    Double getAverageResolutionTime();

    Double getAverageSatisfactionRating();
}
