package io.arrogantprogrammer;

import java.util.ArrayList;
import java.util.List;

public record AffirmationRecord(String id, String text, String author) {

    static List<AffirmationRecord> allAffirmations() {
        return new ArrayList<>(){{
            add(new AffirmationRecord("1","You are amazing!", "ArrogantProgrammer"));
            add(new AffirmationRecord("2", "Believe in yourself!", "ConfidentCoder"));
            add(new AffirmationRecord("3","You can achieve anything!", "DiabolicalDeveloper"));
            add(new AffirmationRecord("4","Stay positive and strong!", "HopefulHacker"));
            add(new AffirmationRecord("5","Your potential is limitless!", "AngelicArchitect"));
        }};
    }

    static AffirmationRecord randomAffirmation() {
        return allAffirmations().get((int) (Math.random() * allAffirmations().size()));
    }

}
