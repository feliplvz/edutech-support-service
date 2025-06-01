package com.edutech.supportservice.controller;

import com.edutech.supportservice.dto.TicketDTO;
import com.edutech.supportservice.service.TicketService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/tickets")
public class TicketController {

    private final TicketService ticketService;

    @Autowired
    public TicketController(TicketService ticketService) {
        this.ticketService = ticketService;
    }

    @GetMapping
    public ResponseEntity<List<TicketDTO>> getAllTickets() {
        return ResponseEntity.ok(ticketService.getAllTickets());
    }

    @GetMapping("/{id}")
    public ResponseEntity<TicketDTO> getTicketById(@PathVariable Long id) {
        return ResponseEntity.ok(ticketService.getTicketById(id));
    }

    @PostMapping
    public ResponseEntity<TicketDTO> createTicket(@Valid @RequestBody TicketDTO ticketDTO) {
        return new ResponseEntity<>(ticketService.createTicket(ticketDTO), HttpStatus.CREATED);
    }

    @GetMapping("/paginated")
    public ResponseEntity<Page<TicketDTO>> getTicketsPaginated(
            @PageableDefault(size = 10, sort = "createdAt") Pageable pageable) {
        return ResponseEntity.ok(ticketService.getTicketsPaginated(pageable));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<TicketDTO>> getTicketsByUser(@PathVariable Long userId) {
        return ResponseEntity.ok(ticketService.getTicketsByUser(userId));
    }

    @GetMapping("/assigned/{staffId}")
    public ResponseEntity<List<TicketDTO>> getTicketsByAssignedTo(@PathVariable Long staffId) {
        return ResponseEntity.ok(ticketService.getTicketsByAssignedTo(staffId));
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<TicketDTO>> getTicketsByStatus(@PathVariable String status) {
        return ResponseEntity.ok(ticketService.getTicketsByStatus(status));
    }

    @GetMapping("/category/{categoryId}")
    public ResponseEntity<List<TicketDTO>> getTicketsByCategory(@PathVariable Long categoryId) {
        return ResponseEntity.ok(ticketService.getTicketsByCategory(categoryId));
    }

    @GetMapping("/course/{courseId}")
    public ResponseEntity<List<TicketDTO>> getTicketsByCourse(@PathVariable Long courseId) {
        return ResponseEntity.ok(ticketService.getTicketsByCourse(courseId));
    }

    @GetMapping("/search")
    public ResponseEntity<Page<TicketDTO>> searchTickets(
            @RequestParam String keyword,
            @PageableDefault(size = 10) Pageable pageable) {
        return ResponseEntity.ok(ticketService.searchTickets(keyword, pageable));
    }

    @PutMapping("/{id}")
    public ResponseEntity<TicketDTO> updateTicket(
            @PathVariable Long id,
            @Valid @RequestBody TicketDTO ticketDTO) {
        return ResponseEntity.ok(ticketService.updateTicket(id, ticketDTO));
    }

    @PatchMapping("/{id}/assign/{staffId}")
    public ResponseEntity<TicketDTO> assignTicket(
            @PathVariable Long id,
            @PathVariable Long staffId) {
        return ResponseEntity.ok(ticketService.assignTicket(id, staffId));
    }

    @PatchMapping("/{id}/status/{status}")
    public ResponseEntity<TicketDTO> changeTicketStatus(
            @PathVariable Long id,
            @PathVariable String status) {
        return ResponseEntity.ok(ticketService.changeTicketStatus(id, status));
    }

    @PatchMapping("/{id}/priority/{priority}")
    public ResponseEntity<TicketDTO> changeTicketPriority(
            @PathVariable Long id,
            @PathVariable String priority) {
        return ResponseEntity.ok(ticketService.changeTicketPriority(id, priority));
    }

    @PostMapping("/{id}/rate")
    public ResponseEntity<TicketDTO> rateTicket(
            @PathVariable Long id,
            @RequestParam Integer rating,
            @RequestParam(required = false) String feedback) {
        return ResponseEntity.ok(ticketService.rateTicket(id, rating, feedback));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTicket(@PathVariable Long id) {
        ticketService.deleteTicket(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/stats/status-counts")
    public ResponseEntity<Map<String, Integer>> getTicketStatusCounts() {
        return ResponseEntity.ok(ticketService.getTicketStatusCounts());
    }

    @GetMapping("/stats/priority-counts")
    public ResponseEntity<Map<String, Integer>> getTicketPriorityCounts() {
        return ResponseEntity.ok(ticketService.getTicketPriorityCounts());
    }

    @GetMapping("/stats/category-counts")
    public ResponseEntity<Map<String, Integer>> getTicketCategoryCounts() {
        return ResponseEntity.ok(ticketService.getTicketCategoryCounts());
    }

    @GetMapping("/stats/avg-resolution-time")
    public ResponseEntity<Map<String, Double>> getAverageResolutionTime() {
        Double avgTime = ticketService.getAverageResolutionTime();
        return ResponseEntity.ok(Map.of("averageResolutionTimeInDays", avgTime != null ? avgTime : 0));
    }

    @GetMapping("/stats/avg-satisfaction")
    public ResponseEntity<Map<String, Double>> getAverageSatisfactionRating() {
        Double avgRating = ticketService.getAverageSatisfactionRating();
        return ResponseEntity.ok(Map.of("averageSatisfactionRating", avgRating != null ? avgRating : 0));
    }
}
