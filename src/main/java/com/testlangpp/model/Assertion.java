package com.testlangpp.model;

public class Assertion {
    public Integer statusCode;
    public String headerKey;
    public String headerValue;
    public boolean isExactMatch;
    public String bodyContains;

    // expect status = NUMBER
    public Assertion(Integer statusCode) {
        this.statusCode = statusCode;
    }

    // expect header "K" = "V" or contains "V"
    public Assertion(String headerKey, String headerValue, boolean isExactMatch) {
        this.headerKey = headerKey;
        this.headerValue = headerValue;
        this.isExactMatch = isExactMatch;
    }

    // expect body contains "V"
    public Assertion(String bodyContains) {
        this.bodyContains = bodyContains;
    }

    @Override
    public String toString() {
        if (statusCode != null) {
            return "Assertion{status=" + statusCode + "}";
        } else if (headerKey != null) {
            String op = isExactMatch ? "=" : "contains";
            return "Assertion{header " + headerKey + " " + op + " " + headerValue + "}";
        } else {
            return "Assertion{body contains " + bodyContains + "}";
        }
    }
}