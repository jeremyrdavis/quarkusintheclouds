package io.arrogantprogrammer;

import io.quarkus.logging.Log;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.UriInfo;

@Path("/affirmation")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AffirmationResource {

    @Inject
    AffirmationRepository affirmationRepository;

    @GET
    public AffirmationRecord getAffirmation() {
        AffirmationRecord affirmationRecord = AffirmationRecord.randomAffirmation();
        Log.debug("Returning affirmation: " + affirmationRecord.text());
        return affirmationRecord;
    }

    @POST
    public Response createAffirmation(CreateAffirmationCommand createAffirmationCommand, @Context UriInfo uriInfo) {
        Log.debug("Creating affirmation from: " + createAffirmationCommand.toString());
        AffirmationRecord affirmationRecord = affirmationRepository.createAffirmation(createAffirmationCommand);
        return Response.created(uriInfo.getAbsolutePathBuilder().path(affirmationRecord.id()).build()).build();
    }

    @GET
    @Path("/{id}")
    public Response readAffirmation(@PathParam("id") String id) {
        return Response.ok(affirmationRepository.readAffirmation(id)).build();
    }

    @PUT
    public Response updateAffirmation(AffirmationRecord affirmationRecord) {
        Log.debug("Updating affirmation: " + affirmationRecord.toString());
        affirmationRepository.updateAffirmation(affirmationRecord);
        return Response.ok().build();
    }

    @DELETE
    @Path("/{id}")
    public Response deleteAffirmation(@PathParam("id") String id) {
        Log.debug("Deleting affirmation with id: " + id);
        affirmationRepository.deleteAffirmation(id);
        return Response.noContent().build();
    }


}
