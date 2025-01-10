package io.arrogantprogrammer.developerscorner.quarkusintheclouds.appconfiguration;

import io.quarkus.logging.Log;
import io.smallrye.config.SmallRyeConfig;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;

@Path("/app-configuration")
public class AppConfigurationResource {

    @Inject
    SmallRyeConfig config;

    @GET
    public String getAppConfiguration() {
        Log.debug("Getting App Configuration");
        String valueOne = config.getConfigValue("myKeyOne").getValue();
        String valueTwo = config.getConfigValue("myKeyTwo").getValue();
        return "Config Value One: " + valueOne + " Config Value Two: " + valueTwo;
    }
}
