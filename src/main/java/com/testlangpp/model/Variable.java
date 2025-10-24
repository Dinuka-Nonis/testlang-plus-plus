package com.testlangpp.model;

public class Variable {  // ← Must be PUBLIC
    public String name;
    public String stringValue;
    public Integer intValue;

    public Variable(String name, String stringValue) {
        this.name = name;
        this.stringValue = stringValue;
        this.intValue = null;
    }

    public Variable(String name, Integer intValue) {
        this.name = name;
        this.stringValue = null;
        this.intValue = intValue;
    }

    @Override
    public String toString() {
        if (stringValue != null) {
            return "Variable{" + name + "=\"" + stringValue + "\"}";
        } else {
            return "Variable{" + name + "=" + intValue + "}";
        }
    }
}