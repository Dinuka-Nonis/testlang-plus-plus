package com.testlangpp.model;

public class RequestBody {
    public String content;

    public RequestBody(String content) {
        this.content = content;
    }

    @Override
    public String toString() {
        return "Body{" + content + "}";
    }
}
