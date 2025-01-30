package io.arrogantprogrammer.developerscorner.quarkusintheclouds.blobstorage;

import com.azure.core.util.BinaryData;
import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobServiceClient;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;

import java.time.LocalDateTime;

import static jakarta.ws.rs.core.Response.Status.CREATED;

@Path("/blobstorage")
@ApplicationScoped
public class BlobStorageResource {

    @Inject
    BlobServiceClient blobServiceClient;

    @GET
    @Path("/upload")
    public Response uploadBlob() {
        BlobContainerClient blobContainerClient = blobServiceClient
                .createBlobContainerIfNotExists("azstorageblob011225");
        BlobClient blobClient = blobContainerClient.getBlobClient("quarkus-azure-storage-blob.txt");
        blobClient.upload(BinaryData.fromString("Hello quarkus-azure-storage-blob at " + LocalDateTime.now()), true);

        return Response.status(CREATED).build();
    }

    @GET
    public String downloadBlob() {
        BlobContainerClient blobContainerClient = blobServiceClient
                .getBlobContainerClient("azstorageblob011225");
        BlobClient blobClient = blobContainerClient.getBlobClient("quarkus-azure-storage-blob.txt");

        return blobClient.downloadContent().toString();
    }
}
