package com.edutech.supportservice.service;

import com.edutech.supportservice.dto.TicketCategoryDTO;

import java.util.List;

public interface TicketCategoryService {

    List<TicketCategoryDTO> getAllCategories();

    List<TicketCategoryDTO> getActiveCategories();

    TicketCategoryDTO getCategoryById(Long id);

    TicketCategoryDTO getCategoryByName(String name);

    TicketCategoryDTO createCategory(TicketCategoryDTO categoryDTO);

    TicketCategoryDTO updateCategory(Long id, TicketCategoryDTO categoryDTO);

    void deleteCategory(Long id);

    TicketCategoryDTO activateCategory(Long id);

    TicketCategoryDTO deactivateCategory(Long id);
}
