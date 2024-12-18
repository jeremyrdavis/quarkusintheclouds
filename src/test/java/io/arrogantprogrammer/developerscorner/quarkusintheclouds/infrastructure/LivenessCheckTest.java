package io.arrogantprogrammer.developerscorner.quarkusintheclouds.infrastructure;

import io.quarkus.test.junit.QuarkusTest;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static io.restassured.RestAssured.when;
import static org.hamcrest.Matchers.equalTo;
import static org.junit.jupiter.api.Assertions.assertEquals;

@QuarkusTest
public class LivenessCheckTest {

    @Test
    void testLivenessCheck() {
        given()
                .when().get("/q/health/live")
                .then()
                .statusCode(200)
                .body("status", equalTo("UP"));
    }
}
