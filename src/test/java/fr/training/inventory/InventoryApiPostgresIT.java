package fr.training.inventory;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@ActiveProfiles("qualif")
@SpringBootTest
class InventoryApiPostgresIT {

    @Test
    void contextLoadsWithPostgresProfile() {
        // Ce test est exécuté dans GitHub Actions avec un conteneur de service PostgreSQL.
    }
}
