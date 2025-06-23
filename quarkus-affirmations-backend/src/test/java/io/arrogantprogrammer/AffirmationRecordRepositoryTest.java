package io.arrogantprogrammer;

import com.azure.cosmos.CosmosClient;
import com.azure.cosmos.CosmosContainer;
import com.azure.cosmos.CosmosDatabase;
import com.azure.cosmos.models.CosmosItemResponse;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

public class AffirmationRecordRepositoryTest {

    private AffirmationRepository affirmationRepository;
    private CosmosClient mockCosmosClient;

    @BeforeEach
    public void setup() {
        // Create mocks
        CosmosItemResponse<AffirmationRecord> mockCosmosItemResponse = Mockito.mock(CosmosItemResponse.class);
        when(mockCosmosItemResponse.getItem()).thenReturn(new AffirmationRecord("1", "You are awesome!", "ArrogantProgrammer"));

        CosmosContainer mockCosmosContainer = Mockito.mock(CosmosContainer.class);
        when(mockCosmosContainer.createItem(any(AffirmationRecord.class))).thenReturn(mockCosmosItemResponse);  

        CosmosDatabase mockCosmosDatabase = Mockito.mock(CosmosDatabase.class);
        when(mockCosmosDatabase.getContainer(anyString())).thenReturn(mockCosmosContainer);

        mockCosmosClient = Mockito.mock(CosmosClient.class);
        when(mockCosmosClient.getDatabase(anyString())).thenReturn(mockCosmosDatabase);
        
        // Create repository with mocked client
        affirmationRepository = new AffirmationRepository();
        
        // Use reflection to inject the mock client and config properties
        try {
            java.lang.reflect.Field clientField = AffirmationRepository.class.getDeclaredField("cosmosClient");
            clientField.setAccessible(true);
            clientField.set(affirmationRepository, mockCosmosClient);
            
            java.lang.reflect.Field dbNameField = AffirmationRepository.class.getDeclaredField("DATABASE_NAME");
            dbNameField.setAccessible(true);
            dbNameField.set(affirmationRepository, "test-database");
            
            java.lang.reflect.Field containerNameField = AffirmationRepository.class.getDeclaredField("CONTAINER_NAME");
            containerNameField.setAccessible(true);
            containerNameField.set(affirmationRepository, "test-container");
        } catch (Exception e) {
            throw new RuntimeException("Failed to inject mock dependencies", e);
        }
    }

    @Test
    public void testCreateAffirmation() {
        CreateAffirmationCommand createAffirmationCommand = new CreateAffirmationCommand("You are awesome!", "ArrogantProgrammer");

        AffirmationRecord response = affirmationRepository.createAffirmation(createAffirmationCommand);
        assertNotNull(response);
        assertEquals(response.text(), "You are awesome!");
    }

    // Additional tests for readAffirmation, updateAffirmation, and deleteAffirmation can be added similarly
}