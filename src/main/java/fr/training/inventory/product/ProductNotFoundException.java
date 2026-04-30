package fr.training.inventory.product;

public class ProductNotFoundException extends RuntimeException {
    public ProductNotFoundException(Long id) {
        super("Produit introuvable avec l'identifiant " + id);
    }
}
