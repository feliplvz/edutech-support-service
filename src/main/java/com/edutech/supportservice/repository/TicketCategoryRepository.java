package com.edutech.supportservice.repository;

import com.edutech.supportservice.model.TicketCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TicketCategoryRepository extends JpaRepository<TicketCategory, Long> {

    Optional<TicketCategory> findByName(String name);

    List<TicketCategory> findByActiveTrue();

    boolean existsByName(String name);
}
