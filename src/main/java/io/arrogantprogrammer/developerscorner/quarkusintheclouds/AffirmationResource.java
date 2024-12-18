package io.arrogantprogrammer.developerscorner.quarkusintheclouds;

import io.quarkus.logging.Log;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@Path("/affirmation")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class AffirmationResource {

    @GET
    public Affirmation affirmation() {
        Affirmation affirmation = Affirmation.randomAffirmation();
        Log.debugf("Returning affirmation: %s", affirmation);
        return affirmation;
    }
}
