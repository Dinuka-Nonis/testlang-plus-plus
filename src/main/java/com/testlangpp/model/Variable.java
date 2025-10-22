package com.testlangpp.model;

public class Variable {
    public String name;
    public String value;

    public Variable(String name, String value) {
        this.name = name;
        this.value = value;
    }

    public String toString() {
        return "let " + name + " = \"" + value + "\";";
    }
}