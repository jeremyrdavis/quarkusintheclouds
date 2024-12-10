package io.arrogantprogrammer.developerscorner.quarkusonazure.infrastructure;

import io.arrogantprogrammer.developerscorner.quarkusonazure.Affirmation;
import jakarta.enterprise.context.ApplicationScoped;
import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.eclipse.microprofile.health.Readiness;

@Readiness
@ApplicationScoped
public class SimpleReadinessCheck implements HealthCheck {

    @Override
    public HealthCheckResponse call() {
        if(Affirmation.getAffirmationList() != null & Affirmation.getAffirmationList().size() >= 3 ) {
            return HealthCheckResponse.up("Simple readiness check passed");
        }else{
            return HealthCheckResponse.down("Simple readiness check failed");
        }
    }
}
