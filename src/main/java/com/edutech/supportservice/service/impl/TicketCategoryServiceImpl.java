package com.edutech.supportservice.service.impl;

import com.edutech.supportservice.dto.TicketCategoryDTO;
import com.edutech.supportservice.exception.ResourceNotFoundException;
import com.edutech.supportservice.model.TicketCategory;
import com.edutech.supportservice.repository.TicketCategoryRepository;
import com.edutech.supportservice.service.TicketCategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class TicketCategoryServiceImpl implements TicketCategoryService {

    private final TicketCategoryRepository categoryRepository;

    @Autowired
    public TicketCategoryServiceImpl(TicketCategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    @Override
    public List<TicketCategoryDTO> getAllCategories() {
        return categoryRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<TicketCategoryDTO> getActiveCategories() {
        return categoryRepository.findByActiveTrue().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public TicketCategoryDTO getCategoryById(Long id) {
        TicketCategory category = categoryRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Categoría", "id", id));
        return convertToDTO(category);
    }

    @Override
    public TicketCategoryDTO getCategoryByName(String name) {
        TicketCategory category = categoryRepository.findByName(name)
                .orElseThrow(() -> new ResourceNotFoundException("Categoría", "nombre", name));
        return convertToDTO(category);
    }

    @Override
    @Transactional
    public TicketCategoryDTO createCategory(TicketCategoryDTO categoryDTO) {
        if (categoryRepository.existsByName(categoryDTO.getName())) {
            throw new IllegalArgumentException("Ya existe una categoría con este nombre");
        }

        TicketCategory category = new TicketCategory();
        updateCategoryFromDTO(category, categoryDTO);

        TicketCategory savedCategory = categoryRepository.save(category);
        return convertToDTO(savedCategory);
    }

    @Override
    @Transactional
    public TicketCategoryDTO updateCategory(Long id, TicketCategoryDTO categoryDTO) {
        TicketCategory category = categoryRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Categoría", "id", id));

        // Verificar si ya existe otra categoría con ese nombre
        if (!category.getName().equals(categoryDTO.getName()) &&
            categoryRepository.existsByName(categoryDTO.getName())) {
            throw new IllegalArgumentException("Ya existe otra categoría con este nombre");
        }

        updateCategoryFromDTO(category, categoryDTO);

        TicketCategory updatedCategory = categoryRepository.save(category);
        return convertToDTO(updatedCategory);
    }

    @Override
    @Transactional
    public void deleteCategory(Long id) {
        TicketCategory category = categoryRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Categoría", "id", id));

        // Verificar si tiene tickets asociados
        if (!category.getTickets().isEmpty()) {
            throw new IllegalStateException("No se puede eliminar una categoría con tickets asociados");
        }

        categoryRepository.delete(category);
    }

    @Override
    @Transactional
    public TicketCategoryDTO activateCategory(Long id) {
        TicketCategory category = categoryRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Categoría", "id", id));

        category.setActive(true);
        TicketCategory updatedCategory = categoryRepository.save(category);
        return convertToDTO(updatedCategory);
    }

    @Override
    @Transactional
    public TicketCategoryDTO deactivateCategory(Long id) {
        TicketCategory category = categoryRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Categoría", "id", id));

        category.setActive(false);
        TicketCategory updatedCategory = categoryRepository.save(category);
        return convertToDTO(updatedCategory);
    }

    // Método auxiliar para actualizar una entidad TicketCategory a partir de un DTO
    private void updateCategoryFromDTO(TicketCategory category, TicketCategoryDTO dto) {
        category.setName(dto.getName());
        category.setDescription(dto.getDescription());

        if (dto.getActive() != null) {
            category.setActive(dto.getActive());
        }

        if (dto.getExpectedResolutionTimeHours() != null) {
            category.setExpectedResolutionTimeHours(dto.getExpectedResolutionTimeHours());
        }
    }

    // Método para convertir una entidad TicketCategory a DTO
    private TicketCategoryDTO convertToDTO(TicketCategory category) {
        TicketCategoryDTO dto = new TicketCategoryDTO();
        dto.setId(category.getId());
        dto.setName(category.getName());
        dto.setDescription(category.getDescription());
        dto.setActive(category.getActive());
        dto.setExpectedResolutionTimeHours(category.getExpectedResolutionTimeHours());
        dto.setTicketCount(category.getTickets().size());
        return dto;
    }
}
