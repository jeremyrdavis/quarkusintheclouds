package io.arrogantprogrammer.developerscorner.quarkusintheclouds.eventhubs;

import com.azure.core.util.IterableStream;
import com.azure.messaging.eventhubs.EventData;
import com.azure.messaging.eventhubs.EventHubConsumerClient;
import com.azure.messaging.eventhubs.models.EventPosition;
import com.azure.messaging.eventhubs.models.PartitionEvent;
import com.azure.messaging.eventhubs.models.SendOptions;
import io.quarkus.logging.Log;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;

import com.azure.messaging.eventhubs.EventHubProducerClient;
import jakarta.ws.rs.core.Response;

import java.util.Arrays;
import java.util.List;

@Path("/eventhubs")
public class EventHubResource {

    @Inject
    EventHubProducerClient producer;

    @Inject
    EventHubConsumerClient consumer;

    @Path("/publishEvents")
    @GET
    public Response publishEvents() {
        Log.debug("QUARKUS_AZURE_EVENTHUBS_NAMESPACE: " + System.getenv("QUARKUS_AZURE_EVENTHUBS_NAMESPACE"));
        List<EventData> allEvents = Arrays.asList(new EventData("Foo"), new EventData("Bar"));
        producer.send(allEvents, new SendOptions().setPartitionId("0"));
        return Response.accepted().build();
    }

    @Path("/consumeEvents")
    @GET
    public Response consumeEvents() {

        Log.info("Receiving message using Event Hub consumer client.");
        String PARTITION_ID = "0";
        // Reads events from partition '0' and returns the first 2 received.
        IterableStream<PartitionEvent> events = consumer.receiveFromPartition(PARTITION_ID, 2,
                EventPosition.earliest());

        for (PartitionEvent partitionEvent : events) {
            // For each event, perform some sort of processing.
            Log.info("Message Body received: " + partitionEvent.getData().getBodyAsString());
            Log.info("Message SequenceNumber is: " + partitionEvent.getData().getSequenceNumber());

        }
        List returnList = events.stream().map(e -> {
            return e.getData().getBodyAsString();
        }).toList();

            return Response.ok().entity(returnList).build();
    }
}