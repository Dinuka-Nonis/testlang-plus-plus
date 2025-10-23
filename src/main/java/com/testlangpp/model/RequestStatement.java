package com.testlangpp.model;

import java.util.ArrayList;
import java.util.List;

public class RequestStatement {
    public String method;           // GET, POST, PUT, DELETE
    public String path;
    public List<RequestHeader> headers;
    public RequestBody body;

    public RequestStatement(String method, String path, List<RequestHeader> headers, RequestBody body) {
        this.method = method;
        this.path = path;
        this.headers = headers != null ? headers : new ArrayList<>();
        this.body = body;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(method).append(" \"").append(path).append("\"");
        if (!headers.isEmpty() || body != null) {
            sb.append(" {\n");
            for (RequestHeader h : headers) {
                sb.append("    ").append(h).append("\n");
            }
            if (body != null) {
                sb.append("    ").append(body).append("\n");
            }
            sb.append("  }");
        }
        sb.append(";");
        return sb.toString();
    }
}
