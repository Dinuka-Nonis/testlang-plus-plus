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
        StringBuilder sb = new StringBuilder();
        sb.append("test ").append(name).append(" {\n");
        if (request != null)
            sb.append("  ").append(request).append("\n");
        if (assertions != null) {
            for (Assertion a : assertions) {
                sb.append("  ").append(a).append("\n");
            }
        }
        sb.append("}");
        return sb.toString();
    }
}
