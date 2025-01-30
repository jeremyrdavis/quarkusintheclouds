package io.arrogantprogrammer.developerscorner.quarkusintheclouds.keyvault;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;
import org.eclipse.microprofile.config.inject.ConfigProperty;

@Path("/keyvault")
public class KeyVaultResource {

    @ConfigProperty(name = "kv//secret2")
    String secret;

    @GET
    public Response getKeyVaultSecret() {
        return Response.ok().entity(secret).build();
    }
}
