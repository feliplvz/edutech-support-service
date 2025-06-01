package com.edutech.supportservice.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import com.edutech.supportservice.service.TicketCategoryService;
import com.edutech.supportservice.dto.TicketCategoryDTO;
import java.util.List;

@RestController
@RequestMapping("/api/categories")
public class CategoryController {

    private final TicketCategoryService categoryService;

    @Autowired
    public CategoryController(TicketCategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping
    public ResponseEntity<List<TicketCategoryDTO>> getAllCategories() {
        return ResponseEntity.ok(categoryService.getAllCategories());
    }

    @GetMapping("/{id}")
    public ResponseEntity<TicketCategoryDTO> getCategoryById(@PathVariable Long id) {
        return ResponseEntity.ok(categoryService.getCategoryById(id));
    }
}
