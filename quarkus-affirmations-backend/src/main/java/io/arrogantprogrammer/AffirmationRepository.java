package io.arrogantprogrammer;

import com.azure.cosmos.CosmosClient;
import com.azure.cosmos.CosmosContainer;
import com.azure.cosmos.models.CosmosItemResponse;
import com.azure.cosmos.models.PartitionKey;
import io.quarkus.logging.Log;
import jakarta.inject.Inject;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.Random;
import java.util.UUID;

import org.eclipse.microprofile.config.inject.ConfigProperty;

@ApplicationScoped
public class AffirmationRepository {

    @Inject
    CosmosClient cosmosClient;

    @ConfigProperty(name = "affirmations.database-name")
    private String DATABASE_NAME;

    @ConfigProperty(name = "affirmations.container-name")
    private String CONTAINER_NAME;

    protected AffirmationRecord createAffirmation(CreateAffirmationCommand createAffirmationCommand) {
        Log.debug("Creating affirmation: " + createAffirmationCommand);
        Affirmation affirmation = new Affirmation(createAffirmationCommand.text(), createAffirmationCommand.author());
        Log.debug("Affirmation: " + affirmation);
        CosmosContainer container = getContainer();

        CosmosItemResponse<Affirmation> cosmosItemResponse = container.createItem(affirmation); //getContainer().createItem(affirmation);
        Log.debugf("Created affirmation with id: %s", cosmosItemResponse.toString());
        return new AffirmationRecord(affirmation.getId(), affirmation.getText(),affirmation.getAuthor());
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

    protected AffirmationRecord randomAffirmation() {
        CosmosContainer container = getContainer();
        long count = container.readAllItems(new PartitionKey("partitionKey"), AffirmationRecord.class).stream().count();
        int randomIndex = new Random().nextInt(Long.valueOf(count).intValue());
        AffirmationRecord randomAffirmation = container.readAllItems(new PartitionKey("partitionKey"), AffirmationRecord.class)
            .stream()
            .skip(randomIndex)
            .findFirst()
            .orElseThrow(() -> new RuntimeException("No affirmation found"));
        return randomAffirmation;
    }
}
