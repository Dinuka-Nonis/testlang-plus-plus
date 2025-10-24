package com.testlangpp.model;

import java.util.List;

public class TestBlock {
    public String name;
    public RequestStatement request;
    public List<Assertion> assertions;

    public TestBlock(String name, RequestStatement request, List<Assertion> assertions) {
        this.name = name;
        this.request = request;
        this.assertions = assertions;
    }

    @Override
    public String toString() {
        return "TestBlock{name='" + name + "', request=" + request + ", assertions=" + assertions + "}";
    }
}