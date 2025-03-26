package io.arrogantprogrammer;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

@Path("/affirmations/random")
@RegisterRestClient(configKey = "affirmations-api")
public interface AffirmationsRESTClient {

    @GET
    public AffirmationJSON randomAffirmation();
}
