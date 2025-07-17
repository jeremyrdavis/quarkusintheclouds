package io.arrogantprogrammer.developerscorner.quarkusintheclouds.eventbus;

import com.azure.messaging.servicebus.ServiceBusClientBuilder;
import com.azure.messaging.servicebus.ServiceBusProcessorClient;
import com.azure.messaging.servicebus.ServiceBusSenderClient;
import io.quarkus.logging.Log;
import jakarta.annotation.PostConstruct;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;
import org.eclipse.microprofile.config.inject.ConfigProperty;

@Path("/eventbus")
public class EventBusResource {

//    @ConfigProperty(name = "quarkus.azure.servicebus.queue-name", defaultValue = "test-queue")
//    private String queueName;
//
    @Inject
    private ServiceBusClientBuilder clientBuilder;

    private ServiceBusSenderClient senderClient;
    private ServiceBusProcessorClient processorClient;

    @GET
    public Response getEvents() {
        return  Response.ok().build();
    }

    @PostConstruct
    void init() {
        Log.debugf("Initializing service bus client");
    }
}
