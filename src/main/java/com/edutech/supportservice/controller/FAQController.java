package com.edutech.supportservice.controller;

import com.edutech.supportservice.dto.FAQDTO;
import com.edutech.supportservice.service.FAQService;
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
@RequestMapping("/api/faqs")
public class FAQController {

    private final FAQService faqService;

    @Autowired
    public FAQController(FAQService faqService) {
        this.faqService = faqService;
    }

    @GetMapping
    public ResponseEntity<List<FAQDTO>> getAllFAQs() {
        return ResponseEntity.ok(faqService.getAllFAQs());
    }

    @GetMapping("/published")
    public ResponseEntity<List<FAQDTO>> getPublishedFAQs() {
        return ResponseEntity.ok(faqService.getPublishedFAQs());
    }

    @GetMapping("/{id}")
    public ResponseEntity<FAQDTO> getFAQById(@PathVariable Long id) {
        return ResponseEntity.ok(faqService.getFAQById(id));
    }

    @GetMapping("/category/{categoryId}")
    public ResponseEntity<List<FAQDTO>> getFAQsByCategory(@PathVariable Long categoryId) {
        return ResponseEntity.ok(faqService.getFAQsByCategory(categoryId));
    }

    @GetMapping("/search")
    public ResponseEntity<Page<FAQDTO>> searchFAQs(
            @RequestParam String keyword,
            @PageableDefault(size = 10) Pageable pageable) {
        // Normalize the keyword to handle UTF-8 encoding issues
        String normalizedKeyword = keyword.trim();
        try {
            // Ensure proper UTF-8 handling
            if (!normalizedKeyword.isEmpty()) {
                normalizedKeyword = java.net.URLDecoder.decode(normalizedKeyword, "UTF-8");
            }
        } catch (java.io.UnsupportedEncodingException e) {
            // If decoding fails, use the original keyword
            normalizedKeyword = keyword.trim();
        }
        return ResponseEntity.ok(faqService.searchFAQs(normalizedKeyword, pageable));
    }

    @PostMapping
    public ResponseEntity<FAQDTO> createFAQ(@Valid @RequestBody FAQDTO faqDTO) {
        return new ResponseEntity<>(faqService.createFAQ(faqDTO), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<FAQDTO> updateFAQ(
            @PathVariable Long id,
            @Valid @RequestBody FAQDTO faqDTO) {
        return ResponseEntity.ok(faqService.updateFAQ(id, faqDTO));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteFAQ(@PathVariable Long id) {
        faqService.deleteFAQ(id);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}/publish")
    public ResponseEntity<FAQDTO> publishFAQ(@PathVariable Long id) {
        return ResponseEntity.ok(faqService.publishFAQ(id));
    }

    @PatchMapping("/{id}/unpublish")
    public ResponseEntity<FAQDTO> unpublishFAQ(@PathVariable Long id) {
        return ResponseEntity.ok(faqService.unpublishFAQ(id));
    }

    @PatchMapping("/{id}/view")
    public ResponseEntity<FAQDTO> incrementViewCount(@PathVariable Long id) {
        return ResponseEntity.ok(faqService.incrementViewCount(id));
    }

    @PatchMapping("/{id}/helpful")
    public ResponseEntity<FAQDTO> addHelpfulVote(@PathVariable Long id) {
        return ResponseEntity.ok(faqService.addHelpfulVote(id));
    }

    @PatchMapping("/{id}/unhelpful")
    public ResponseEntity<FAQDTO> addUnhelpfulVote(@PathVariable Long id) {
        return ResponseEntity.ok(faqService.addUnhelpfulVote(id));
    }

    @GetMapping("/most-viewed")
    public ResponseEntity<List<FAQDTO>> getMostViewedFAQs(
            @RequestParam(defaultValue = "5") int limit) {
        return ResponseEntity.ok(faqService.getMostViewedFAQs(limit));
    }

    @GetMapping("/most-helpful")
    public ResponseEntity<List<FAQDTO>> getMostHelpfulFAQs(
            @RequestParam(defaultValue = "5") int limit) {
        return ResponseEntity.ok(faqService.getMostHelpfulFAQs(limit));
    }

    @GetMapping("/stats/helpfulness-ratio")
    public ResponseEntity<Map<String, Double>> getHelpfulnessRatio() {
        Double ratio = faqService.getHelpfulnessRatio();
        return ResponseEntity.ok(Map.of("helpfulnessRatio", ratio != null ? ratio : 0));
    }
}
