package com.testlangpp.model;

public class TestBlock {
    public String name;
    public String path;
    public int status;

    public TestBlock(String name, String path, int status) {
        this.name = name;
        this.path = path;
        this.status = status;
    }

    public String toString() {
        return "test " + name + " { GET \"" + path + "\"; expect status = " + status + "; }";
    }
}
