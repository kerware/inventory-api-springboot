package fr.training.inventory.product;

public record ProductResponse(
        Long id,
        String name,
        int quantity
) {
    public static ProductResponse from(Product product) {
        return new ProductResponse(product.getId(), product.getName(), product.getQuantity());
    }
}
