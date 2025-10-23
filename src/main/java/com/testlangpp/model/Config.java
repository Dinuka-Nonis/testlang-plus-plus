package com.testlangpp.model;

import java.util.ArrayList;
import java.util.List;

public class Config {
    public String baseUrl;
    public List<RequestHeader> headers;
    
    public Config(String baseUrl) {
        this.baseUrl = baseUrl;
        this.headers = new ArrayList<>();
    }
    
    public Config(String baseUrl, List<RequestHeader> headers) {
        this.baseUrl = baseUrl;
        this.headers = headers != null ? headers : new ArrayList<>();
    }
    
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Config { base_url = \"").append(baseUrl).append("\"");
        if (!headers.isEmpty()) {
            sb.append(", headers = [");
            for (int i = 0; i < headers.size(); i++) {
                if (i > 0) sb.append(", ");
                sb.append(headers.get(i));
            }
            sb.append("]");
        }
        sb.append(" }");
        return sb.toString();
    }
}