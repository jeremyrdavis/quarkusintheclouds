package io.arrogantprogrammer;

import io.quarkus.logging.Log;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import org.eclipse.microprofile.rest.client.inject.RestClient;

@Path("/affirmations")
public class AffirmationResource {

    @RestClient
    AffirmationsRESTClient affirmationsRESTClient;

    @GET
    public String getAffirmation() {
        AffirmationJSON affirmationJSON = affirmationsRESTClient.randomAffirmation();
        Log.debug("Received affirmation: " + affirmationJSON);
        return affirmationJSON.text();
    }
}
