package com.testlangpp.model;

public class RequestHeader {
    public String key;
    public String value;

    public RequestHeader() { }

    public RequestHeader(String key, String value) {
        this.key = key;
        this.value = value;
    }

    @Override
    public String toString() {
        return "header \"" + key + "\" = \"" + value + "\";";
    }
}
