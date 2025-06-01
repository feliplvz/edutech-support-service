package com.edutech.supportservice.repository;

import com.edutech.supportservice.model.FAQ;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FAQRepository extends JpaRepository<FAQ, Long> {

    List<FAQ> findByPublishedTrue();

    List<FAQ> findByPublishedTrueOrderByDisplayOrderAsc();

    List<FAQ> findByCategoryId(Long categoryId);

    List<FAQ> findByCategoryIdAndPublishedTrue(Long categoryId);

    @Query("SELECT f FROM FAQ f WHERE f.published = true AND (LOWER(f.question) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(f.answer) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(f.searchKeywords) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<FAQ> searchByKeyword(@Param("keyword") String keyword, Pageable pageable);

    @Query("SELECT f FROM FAQ f WHERE f.viewCount > :minViews ORDER BY f.viewCount DESC")
    List<FAQ> findMostViewedFAQs(@Param("minViews") Integer minViews, Pageable pageable);

    @Query("SELECT f FROM FAQ f WHERE f.helpfulVotes > :minVotes ORDER BY f.helpfulVotes DESC")
    List<FAQ> findMostHelpfulFAQs(@Param("minVotes") Integer minVotes, Pageable pageable);

    @Query("SELECT SUM(f.viewCount) FROM FAQ f")
    Integer getTotalFAQViews();

    @Query("SELECT AVG((f.helpfulVotes * 1.0) / (f.helpfulVotes + f.unhelpfulVotes)) FROM FAQ f WHERE (f.helpfulVotes + f.unhelpfulVotes) > 0")
    Double getAverageHelpfulRatio();
}
