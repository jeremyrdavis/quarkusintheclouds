package io.arrogantprogrammer;

import com.azure.cosmos.CosmosClient;
import com.azure.cosmos.CosmosContainer;
import com.azure.cosmos.CosmosDatabase;
import com.azure.cosmos.models.CosmosItemResponse;
import com.azure.cosmos.models.PartitionKey;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

public class AffirmationRecordRepositoryTest {

    private AffirmationRepository affirmationRepository;
    private CosmosClient mockCosmosClient;
    private CosmosContainer mockCosmosContainer;

    @BeforeEach
    public void setup() {
        // Create a mock Affirmation for the response
        Affirmation mockAffirmation = new Affirmation("You are awesome!", "ArrogantProgrammer");
        
        // Create mocks
        CosmosItemResponse<Affirmation> mockCosmosItemResponse = Mockito.mock(CosmosItemResponse.class);
        when(mockCosmosItemResponse.getItem()).thenReturn(mockAffirmation);

        mockCosmosContainer = Mockito.mock(CosmosContainer.class);
        when(mockCosmosContainer.createItem(any(Affirmation.class))).thenReturn(mockCosmosItemResponse);  

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
        assertEquals("You are awesome!", response.text());
        assertEquals("ArrogantProgrammer", response.author());
        
        // Verify that the container createItem method was called
        verify(mockCosmosContainer, times(1)).createItem(any(Affirmation.class));
    }

    @Test
    public void testReadAffirmation() {
        // Setup mock for read operation
        AffirmationRecord mockRecord = new AffirmationRecord("123", "Test affirmation", "TestAuthor");
        CosmosItemResponse<AffirmationRecord> mockReadResponse = Mockito.mock(CosmosItemResponse.class);
        when(mockReadResponse.getItem()).thenReturn(mockRecord);
        when(mockCosmosContainer.readItem(eq("123"), any(PartitionKey.class), eq(AffirmationRecord.class)))
                .thenReturn(mockReadResponse);

        AffirmationRecord result = affirmationRepository.readAffirmation("123");
        
        assertNotNull(result);
        assertEquals("123", result.id());
        assertEquals("Test affirmation", result.text());
        assertEquals("TestAuthor", result.author());
        
        // Verify that the container readItem method was called with correct parameters
        verify(mockCosmosContainer, times(1)).readItem(eq("123"), any(PartitionKey.class), eq(AffirmationRecord.class));
    }

    @Test
    public void testUpdateAffirmation() {
        // Setup mock for update operation
        AffirmationRecord inputRecord = new AffirmationRecord("123", "Updated affirmation", "UpdatedAuthor");
        CosmosItemResponse<AffirmationRecord> mockUpdateResponse = Mockito.mock(CosmosItemResponse.class);
        when(mockUpdateResponse.getItem()).thenReturn(inputRecord);
        when(mockCosmosContainer.upsertItem(inputRecord)).thenReturn(mockUpdateResponse);

        AffirmationRecord result = affirmationRepository.updateAffirmation(inputRecord);
        
        assertNotNull(result);
        assertEquals("123", result.id());
        assertEquals("Updated affirmation", result.text());
        assertEquals("UpdatedAuthor", result.author());
        
        // Verify that the container upsertItem method was called
        verify(mockCosmosContainer, times(1)).upsertItem(inputRecord);
    }

    @Test
    public void testDeleteAffirmation() {
        // Delete operation doesn't return anything, just verify it's called
        affirmationRepository.deleteAffirmation("123");
        
        // Verify that the container deleteItem method was called with correct parameters
        verify(mockCosmosContainer, times(1)).deleteItem(eq("123"), any(PartitionKey.class), any());
    }

    // Additional tests for edge cases can be added here
}