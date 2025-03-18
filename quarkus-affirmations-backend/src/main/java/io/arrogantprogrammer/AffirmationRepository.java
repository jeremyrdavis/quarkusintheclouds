package io.arrogantprogrammer;

import com.azure.cosmos.CosmosClient;
import com.azure.cosmos.CosmosContainer;
import com.azure.cosmos.models.CosmosItemResponse;
import io.quarkus.logging.Log;
import jakarta.inject.Inject;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class AffirmationRepository {

    @Inject
    CosmosClient cosmosClient;

    private static final String DATABASE_NAME = "quarkusdb";
    private static final String CONTAINER_NAME = "affirmations";

    protected AffirmationRecord createAffirmation(CreateAffirmationCommand createAffirmationCommand) {
        Affirmation affirmation = new Affirmation(createAffirmationCommand.text(), createAffirmationCommand.author());
        CosmosItemResponse<Affirmation> cosmosItemResponse = getContainer().upsertItem(affirmation);
        Log.debugf("Created affirmation with id: %s", cosmosItemResponse.getItem().id);
        return new AffirmationRecord(cosmosItemResponse.getItem().id, cosmosItemResponse.getItem().text, cosmosItemResponse.getItem().getAuthor());
    }

    protected AffirmationRecord readAffirmation(String id) {
        CosmosItemResponse<AffirmationRecord> result = getContainer().readItem(id, new com.azure.cosmos.models.PartitionKey(id), AffirmationRecord.class);
        Log.debugf("Read affirmation with id: %s", result.getItem().id());
        return new AffirmationRecord(result.getItem().id(), result.getItem().text(), result.getItem().author());
    }

    protected AffirmationRecord updateAffirmation(AffirmationRecord affirmationRecord) {
        CosmosItemResponse<AffirmationRecord> updatedAffirmation =  getContainer().upsertItem(affirmationRecord);
        Log.debugf("Updated affirmation with id: %s", updatedAffirmation.getItem().id());
        return new AffirmationRecord(updatedAffirmation.getItem().id(), updatedAffirmation.getItem().text(), updatedAffirmation.getItem().author());
    }

    protected void deleteAffirmation(String id) {
        getContainer().deleteItem(id, new com.azure.cosmos.models.PartitionKey(id), new com.azure.cosmos.models.CosmosItemRequestOptions());
    }

    private CosmosContainer getContainer() {
        return cosmosClient.getDatabase(DATABASE_NAME).getContainer(CONTAINER_NAME);
    }
}
