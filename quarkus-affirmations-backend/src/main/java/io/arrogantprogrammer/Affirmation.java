package io.arrogantprogrammer;

public class Affirmation {

    static final String PARTITION_KEY = "/id";

    String id = java.util.UUID.randomUUID().toString();

    String text;

    String author;

    Affirmation(String text, String author) {
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
