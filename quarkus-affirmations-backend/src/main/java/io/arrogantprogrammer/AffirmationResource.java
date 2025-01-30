package io.arrogantprogrammer;

import io.quarkus.logging.Log;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

import java.util.ArrayList;
import java.util.List;

@Path("/affirmation")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AffirmationResource {

    @GET
    public Affirmation getAffirmation() {
        Affirmation affirmation = Affirmation.randomAffirmation();
        Log.debug("Returning affirmation: " + affirmation.text());
        return affirmation;
    }
}
