package com.edutech.supportservice.service;

import com.edutech.supportservice.dto.FAQDTO;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface FAQService {

    List<FAQDTO> getAllFAQs();

    List<FAQDTO> getPublishedFAQs();

    FAQDTO getFAQById(Long id);

    List<FAQDTO> getFAQsByCategory(Long categoryId);

    Page<FAQDTO> searchFAQs(String keyword, Pageable pageable);

    FAQDTO createFAQ(FAQDTO faqDTO);

    FAQDTO updateFAQ(Long id, FAQDTO faqDTO);

    void deleteFAQ(Long id);

    FAQDTO publishFAQ(Long id);

    FAQDTO unpublishFAQ(Long id);

    FAQDTO incrementViewCount(Long id);

    FAQDTO addHelpfulVote(Long id);

    FAQDTO addUnhelpfulVote(Long id);

    List<FAQDTO> getMostViewedFAQs(int limit);

    List<FAQDTO> getMostHelpfulFAQs(int limit);

    Double getHelpfulnessRatio();
}
