package io.arrogantprogrammer;

import java.util.ArrayList;
import java.util.List;

public record Affirmation(String text, String author) {

    static List<Affirmation> allAffirmations() {
        return new ArrayList<>(){{
            add(new Affirmation("You are amazing!", "ArrogantProgrammer"));
            add(new Affirmation("Believe in yourself!", "ConfidentCoder"));
            add(new Affirmation("You can achieve anything!", "DiabolicalDeveloper"));
            add(new Affirmation("Stay positive and strong!", "HopefulHacker"));
            add(new Affirmation("Your potential is limitless!", "AngelicArchitect"));
        }};
    }

    static Affirmation randomAffirmation() {
        return allAffirmations().get((int) (Math.random() * allAffirmations().size()));
    }
}
