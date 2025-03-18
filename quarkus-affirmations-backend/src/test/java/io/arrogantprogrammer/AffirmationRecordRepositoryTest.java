package io.arrogantprogrammer;

import com.azure.cosmos.CosmosClient;
import com.azure.cosmos.CosmosContainer;
import com.azure.cosmos.models.CosmosItemResponse;
import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@QuarkusTest
public class AffirmationRecordRepositoryTest {

    @InjectMocks
    AffirmationRepository affirmationRepository;

    @Mock
    CosmosClient cosmosClient;

    @Mock
    CosmosContainer cosmosContainer;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
        when(cosmosClient.getDatabase(anyString()).getContainer(anyString())).thenReturn(cosmosContainer);
    }

    @Test
    public void testCreateAffirmation() {
        CreateAffirmationCommand createAffirmationCommand = new CreateAffirmationCommand( "You are awesome!", "ArrogantProgrammer");
        when(cosmosContainer.upsertItem(any(AffirmationRecord.class))).thenReturn(mock(CosmosItemResponse.class));

        AffirmationRecord response = affirmationRepository.createAffirmation(createAffirmationCommand);
        assertNotNull(response);
        verify(cosmosContainer, times(1)).upsertItem(createAffirmationCommand);
    }

    // Additional tests for readAffirmation, updateAffirmation, and deleteAffirmation can be added similarly
}