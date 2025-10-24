package com.testlangpp.model;

import java.util.List;

public class Config {  // ← Must be PUBLIC
    public String baseUrl;
    public List<RequestHeader> headers;

    public Config(String baseUrl, List<RequestHeader> headers) {
        this.baseUrl = baseUrl;
        this.headers = headers;
    }

    @Override
    public String toString() {
        return "Config{baseUrl='" + baseUrl + "', headers=" + headers + "}";
    }
}