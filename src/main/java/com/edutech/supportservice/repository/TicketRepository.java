package com.edutech.supportservice.repository;

import com.edutech.supportservice.model.Ticket;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface TicketRepository extends JpaRepository<Ticket, Long> {

    List<Ticket> findByUserId(Long userId);

    Page<Ticket> findByUserId(Long userId, Pageable pageable);

    List<Ticket> findByAssignedToId(Long staffId);

    Page<Ticket> findByAssignedToId(Long staffId, Pageable pageable);

    List<Ticket> findByStatus(String status);

    Page<Ticket> findByStatus(String status, Pageable pageable);

    List<Ticket> findByCategoryId(Long categoryId);

    Page<Ticket> findByCategoryId(Long categoryId, Pageable pageable);

    @Query("SELECT t FROM Ticket t WHERE t.courseId = :courseId")
    List<Ticket> findByCourseId(@Param("courseId") Long courseId);

    @Query("SELECT t FROM Ticket t WHERE LOWER(t.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(t.description) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    Page<Ticket> searchByKeyword(@Param("keyword") String keyword, Pageable pageable);

    @Query(value = "SELECT AVG(EXTRACT(epoch FROM (closed_at - created_at))/86400.0) FROM tickets WHERE status = 'CERRADO' AND closed_at IS NOT NULL", nativeQuery = true)
    Double getAverageResolutionTimeInDays();

    @Query("SELECT COUNT(t) FROM Ticket t WHERE t.createdAt >= :startDate")
    Integer countTicketsCreatedSince(@Param("startDate") LocalDateTime startDate);

    @Query("SELECT t.status, COUNT(t) FROM Ticket t GROUP BY t.status")
    List<Object[]> getTicketCountsByStatus();

    @Query("SELECT t.priority, COUNT(t) FROM Ticket t GROUP BY t.priority")
    List<Object[]> getTicketCountsByPriority();

    @Query("SELECT t.category.name, COUNT(t) FROM Ticket t GROUP BY t.category.name")
    List<Object[]> getTicketCountsByCategory();

    @Query("SELECT AVG(t.satisfactionRating) FROM Ticket t WHERE t.satisfactionRating IS NOT NULL")
    Double getAverageSatisfactionRating();
}
