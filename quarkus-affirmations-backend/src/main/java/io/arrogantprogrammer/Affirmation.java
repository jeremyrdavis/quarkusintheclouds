package io.arrogantprogrammer;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.io.Serializable;

public class Affirmation implements Serializable {

    static final String PARTITION_KEY = "/id";

    @JsonProperty("id")
    String id = java.util.UUID.randomUUID().toString();

    @JsonProperty("text")
    String text;

    @JsonProperty("author")
    String author;

    public Affirmation() {
    }

    public Affirmation(String text, String author) {
        this.text = text;
        this.author = author;
    }

    void setText(String text) {
        this.text = text;
    }

    void setAuthor(String author) {
        this.author = author;
    }

    String getId() {
        return id;
    }

    String getText() {
        return text;
    }

    String getAuthor() {
        return author;
    }
}
