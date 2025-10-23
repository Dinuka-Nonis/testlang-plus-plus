package com.testlangpp.model;

public class RequestBody {
    public String content;

    public RequestBody() { }

    public RequestBody(String content) {
        this.content = content;
    }

    @Override
    public String toString() {
        return "body \"" + content + "\";";
    }
}
