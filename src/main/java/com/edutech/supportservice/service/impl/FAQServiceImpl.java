package com.edutech.supportservice.service.impl;

import com.edutech.supportservice.dto.FAQDTO;
import com.edutech.supportservice.exception.ResourceNotFoundException;
import com.edutech.supportservice.model.FAQ;
import com.edutech.supportservice.model.TicketCategory;
import com.edutech.supportservice.repository.FAQRepository;
import com.edutech.supportservice.repository.TicketCategoryRepository;
import com.edutech.supportservice.service.FAQService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class FAQServiceImpl implements FAQService {

    private final FAQRepository faqRepository;
    private final TicketCategoryRepository categoryRepository;

    @Autowired
    public FAQServiceImpl(FAQRepository faqRepository, TicketCategoryRepository categoryRepository) {
        this.faqRepository = faqRepository;
        this.categoryRepository = categoryRepository;
    }

    @Override
    public List<FAQDTO> getAllFAQs() {
        return faqRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<FAQDTO> getPublishedFAQs() {
        return faqRepository.findByPublishedTrueOrderByDisplayOrderAsc().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public FAQDTO getFAQById(Long id) {
        FAQ faq = faqRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FAQ", "id", id));
        return convertToDTO(faq);
    }

    @Override
    public List<FAQDTO> getFAQsByCategory(Long categoryId) {
        if (!categoryRepository.existsById(categoryId)) {
            throw new ResourceNotFoundException("Categoría", "id", categoryId);
        }

        return faqRepository.findByCategoryIdAndPublishedTrue(categoryId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public Page<FAQDTO> searchFAQs(String keyword, Pageable pageable) {
        return faqRepository.searchByKeyword(keyword, pageable)
                .map(this::convertToDTO);
    }

    @Override
    @Transactional
    public FAQDTO createFAQ(FAQDTO faqDTO) {
        TicketCategory category = null;
        if (faqDTO.getCategoryId() != null) {
            category = categoryRepository.findById(faqDTO.getCategoryId())
                    .orElseThrow(() -> new ResourceNotFoundException("Categoría", "id", faqDTO.getCategoryId()));
        }

        FAQ faq = new FAQ();
        faq.setQuestion(faqDTO.getQuestion());
        faq.setAnswer(faqDTO.getAnswer());
        faq.setCategory(category);
        faq.setSearchKeywords(faqDTO.getSearchKeywords());
        faq.setDisplayOrder(faqDTO.getDisplayOrder());
        faq.setPublished(faqDTO.getPublished() != null ? faqDTO.getPublished() : false);

        FAQ savedFAQ = faqRepository.save(faq);
        return convertToDTO(savedFAQ);
    }

    @Override
    @Transactional
    public FAQDTO updateFAQ(Long id, FAQDTO faqDTO) {
        FAQ faq = faqRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FAQ", "id", id));

        TicketCategory category = null;
        if (faqDTO.getCategoryId() != null) {
            category = categoryRepository.findById(faqDTO.getCategoryId())
                    .orElseThrow(() -> new ResourceNotFoundException("Categoría", "id", faqDTO.getCategoryId()));
        }

        faq.setQuestion(faqDTO.getQuestion());
        faq.setAnswer(faqDTO.getAnswer());
        faq.setCategory(category);
        faq.setSearchKeywords(faqDTO.getSearchKeywords());
        faq.setDisplayOrder(faqDTO.getDisplayOrder());

        if (faqDTO.getPublished() != null) {
            faq.setPublished(faqDTO.getPublished());
        }

        FAQ updatedFAQ = faqRepository.save(faq);
        return convertToDTO(updatedFAQ);
    }

    @Override
    @Transactional
    public void deleteFAQ(Long id) {
        FAQ faq = faqRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FAQ", "id", id));

        faqRepository.delete(faq);
    }

    @Override
    @Transactional
    public FAQDTO publishFAQ(Long id) {
        FAQ faq = faqRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FAQ", "id", id));

        faq.setPublished(true);
        FAQ updatedFAQ = faqRepository.save(faq);
        return convertToDTO(updatedFAQ);
    }

    @Override
    @Transactional
    public FAQDTO unpublishFAQ(Long id) {
        FAQ faq = faqRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FAQ", "id", id));

        faq.setPublished(false);
        FAQ updatedFAQ = faqRepository.save(faq);
        return convertToDTO(updatedFAQ);
    }

    @Override
    @Transactional
    public FAQDTO incrementViewCount(Long id) {
        FAQ faq = faqRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FAQ", "id", id));

        faq.incrementViewCount();
        FAQ updatedFAQ = faqRepository.save(faq);
        return convertToDTO(updatedFAQ);
    }

    @Override
    @Transactional
    public FAQDTO addHelpfulVote(Long id) {
        FAQ faq = faqRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FAQ", "id", id));

        faq.addHelpfulVote();
        FAQ updatedFAQ = faqRepository.save(faq);
        return convertToDTO(updatedFAQ);
    }

    @Override
    @Transactional
    public FAQDTO addUnhelpfulVote(Long id) {
        FAQ faq = faqRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FAQ", "id", id));

        faq.addUnhelpfulVote();
        FAQ updatedFAQ = faqRepository.save(faq);
        return convertToDTO(updatedFAQ);
    }

    @Override
    public List<FAQDTO> getMostViewedFAQs(int limit) {
        return faqRepository.findMostViewedFAQs(0, PageRequest.of(0, limit)).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<FAQDTO> getMostHelpfulFAQs(int limit) {
        return faqRepository.findMostHelpfulFAQs(0, PageRequest.of(0, limit)).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public Double getHelpfulnessRatio() {
        return faqRepository.getAverageHelpfulRatio();
    }

    // Método para convertir una entidad FAQ a DTO
    private FAQDTO convertToDTO(FAQ faq) {
        FAQDTO dto = new FAQDTO();
        dto.setId(faq.getId());
        dto.setQuestion(faq.getQuestion());
        dto.setAnswer(faq.getAnswer());
        dto.setViewCount(faq.getViewCount());
        dto.setHelpfulVotes(faq.getHelpfulVotes());
        dto.setUnhelpfulVotes(faq.getUnhelpfulVotes());
        dto.setPublished(faq.getPublished());
        dto.setSearchKeywords(faq.getSearchKeywords());
        dto.setDisplayOrder(faq.getDisplayOrder());

        if (faq.getCategory() != null) {
            dto.setCategoryId(faq.getCategory().getId());
            dto.setCategoryName(faq.getCategory().getName());
        }

        // Calcular ratio de votos útiles
        if ((faq.getHelpfulVotes() != null && faq.getHelpfulVotes() > 0) ||
            (faq.getUnhelpfulVotes() != null && faq.getUnhelpfulVotes() > 0)) {
            int totalVotes = (faq.getHelpfulVotes() != null ? faq.getHelpfulVotes() : 0) +
                           (faq.getUnhelpfulVotes() != null ? faq.getUnhelpfulVotes() : 0);
            if (totalVotes > 0) {
                dto.setHelpfulRatio((double) faq.getHelpfulVotes() / totalVotes * 100);
            }
        }

        return dto;
    }
}
