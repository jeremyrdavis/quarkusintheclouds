package io.arrogantprogrammer.developerscorner.quarkusintheclouds;

import java.util.ArrayList;
import java.util.List;

public class Affirmation {

    String affirmation;

    String author;

    public Affirmation(String affirmation, String name) {
        this.affirmation = affirmation;
        this.author = name;
    }

    public String getAffirmation() {
        return affirmation;
    }

    public String getAuthor() {
        return author;
    }

    static List<Affirmation> affirmationList = new ArrayList<Affirmation>(){{
        add(new Affirmation("You are awesome!", "Motivation Jane"));
        add(new Affirmation("You are amazing!", "Surya Shanti"));
        add(new Affirmation("In every challenge lies a gift; seek it, and you shall find your peace.", "St. Seraphina of Briona"));
    }};

    public static List<Affirmation> getAffirmationList() {
        return affirmationList;
    }

    public static Affirmation randomAffirmation() {
        return affirmationList.get((int) (Math.random() * affirmationList.size()));
    }
    public static List<String> getAffirmations() {
        return affirmationList.stream().map(affirmation -> affirmation.getAffirmation()).toList();
    }

    public static List<String> getAuthors() {
        return affirmationList.stream().map(affirmation -> affirmation.getAuthor()).toList();
    }

}
