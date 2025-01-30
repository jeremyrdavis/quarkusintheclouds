package io.arrogantprogrammer.developerscorner.quarkusintheclouds.cosmosdb;

import com.azure.cosmos.CosmosClient;
import com.azure.cosmos.CosmosContainer;
import com.azure.cosmos.CosmosDatabase;
import com.azure.cosmos.models.CosmosContainerResponse;
import com.azure.cosmos.models.CosmosDatabaseResponse;
import com.azure.cosmos.models.CosmosItemResponse;
import com.azure.cosmos.models.PartitionKey;
import io.quarkus.logging.Log;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.UriInfo;

@Path("/cosmosdb")
public class CosmosDBEndpoint {

    @Inject
    CosmosClient cosmosClient;

    String database = "quarkusdb";
    String container = "quarkuscontainer";

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    public Response createAffirmation(Item item, @Context UriInfo uriInfo) {
        Log.debug("Received item: " + item.toString());
        getContainer(database, container, false).upsertItem(item);
        return Response.created(uriInfo.getAbsolutePathBuilder().path(item.getId()).build()).build();
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getItem() {
        CosmosItemResponse<Item> item = getContainer(database, container, false).readItem("1", new PartitionKey("1"),
                Item.class);
        return Response.ok().entity(item.getItem()).build();
    }


    private CosmosContainer getContainer(String database, String container, boolean createIfNotExists) {
        if (!createIfNotExists) {
            return cosmosClient.getDatabase(database).getContainer(container);
        }
        CosmosDatabaseResponse databaseResponse = cosmosClient.createDatabaseIfNotExists(database);
        CosmosDatabase cosmosDatabase = cosmosClient.getDatabase(databaseResponse.getProperties().getId());
        CosmosContainerResponse containerResponse = cosmosDatabase.createContainerIfNotExists(container, Item.PARTITION_KEY);
        return cosmosDatabase.getContainer(containerResponse.getProperties().getId());
    }
}
