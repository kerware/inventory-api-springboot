package fr.training.inventory.product;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ProductRepository repository;

    public ProductController(ProductRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<ProductResponse> findAll() {
        return repository.findAll()
                .stream()
                .map(ProductResponse::from)
                .toList();
    }

    @GetMapping("/{id}")
    public ProductResponse findById(@PathVariable Long id) {
        return repository.findById(id)
                .map(ProductResponse::from)
                .orElseThrow(() -> new ProductNotFoundException(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ProductResponse create(@Valid @RequestBody ProductRequest request) {
        Product saved = repository.save(new Product(request.name(), request.quantity()));
        return ProductResponse.from(saved);
    }

    @PutMapping("/{id}")
    public ProductResponse update(@PathVariable Long id, @Valid @RequestBody ProductRequest request) {
        Product product = repository.findById(id)
                .orElseThrow(() -> new ProductNotFoundException(id));

        product.setName(request.name());
        product.setQuantity(request.quantity());

        return ProductResponse.from(repository.save(product));
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id) {
        if (!repository.existsById(id)) {
            throw new ProductNotFoundException(id);
        }
        repository.deleteById(id);
    }
}
