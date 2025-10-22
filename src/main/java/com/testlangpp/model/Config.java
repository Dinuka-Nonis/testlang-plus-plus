package com.testlangpp.model;

public class Config {
    public String baseUrl;
    
    public Config(String baseUrl) {
        this.baseUrl = baseUrl;
    }
    
    public String toString() {
        return "Config { base_url = \"" + baseUrl + "\" }";
    }
}