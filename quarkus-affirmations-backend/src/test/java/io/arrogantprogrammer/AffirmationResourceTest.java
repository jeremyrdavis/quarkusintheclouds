package io.arrogantprogrammer;

import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;

import java.util.List;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.isIn;

@QuarkusTest
public class AffirmationResourceTest {

    List<String> expectedAffirmations = List.of(
            "You are amazing!",
            "Believe in yourself!",
            "You can achieve anything!",
            "Stay positive and strong!",
            "Your potential is limitless!"
    );

    @Test
    void testHelloEndpoint() {
        given()
                .header("Accept", "application/json")
                .when().get("/affirmation")
                .then()
                .statusCode(200)
                .body("text", isIn(expectedAffirmations));
    }
}
