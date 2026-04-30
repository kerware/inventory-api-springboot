package fr.training.inventory.product;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.PositiveOrZero;

public record ProductRequest(
        @NotBlank String name,
        @PositiveOrZero int quantity
) {
}
