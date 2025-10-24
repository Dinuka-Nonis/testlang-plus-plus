package com.testlangpp.model;

import java.util.List;

public class RequestStatement {
    public String method;  // GET, POST, PUT, DELETE
    public String path;
    public List<RequestHeader> headers;
    public RequestBody body;

    public RequestStatement(String method, String path, List<RequestHeader> headers, RequestBody body) {
        this.method = method;
        this.path = path;
        this.headers = headers;
        this.body = body;
    }

    @Override
    public String toString() {
        return "Request{" + method + " " + path + ", headers=" + headers + ", body=" + body + "}";
    }
}
