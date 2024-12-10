package io.arrogantprogrammer.developerscorner.quarkusonazure;

import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

import java.util.ArrayList;
import java.util.List;

@Path("/affirmation")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class AffirmationResource {

    @GET
    public Affirmation affirmation() {
        return new Affirmation("You are awesome!", "Motivation Jane");
    }
}
