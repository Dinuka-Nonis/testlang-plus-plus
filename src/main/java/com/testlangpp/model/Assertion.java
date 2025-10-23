package com.testlangpp.model;

public class Assertion {
    public String type;    // "status", "header_equals", "header_contains", "body_contains"
    public String key;     // for header assertions
    public String value;   // expected value or substring
    public Integer status; // for status assertion

    public Assertion() { }

    // Status assertion
    public Assertion(int status) {
        this.type = "status";
        this.status = status;
    }

    // Header equals or contains
    public Assertion(String key, String value, boolean exact) {
        this.type = exact ? "header_equals" : "header_contains";
        this.key = key;
        this.value = value;
    }

    // Body contains
    public Assertion(String value) {
        this.type = "body_contains";
        this.value = value;
    }

    @Override
    public String toString() {
        switch (type) {
            case "status":
                return "expect status = " + status + ";";
            case "header_equals":
                return "expect header \"" + key + "\" = \"" + value + "\";";
            case "header_contains":
                return "expect header \"" + key + "\" contains \"" + value + "\";";
            case "body_contains":
                return "expect body contains \"" + value + "\";";
            default:
                return "unknown assertion";
        }
    }
}