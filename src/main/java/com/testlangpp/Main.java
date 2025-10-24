package com.testlangpp;

import java.io.FileReader;
import com.testlangpp.lexer.Lexer;
import com.testlangpp.parser.Parser;
import com.testlangpp.model.Program;
import com.testlangpp.generator.TestGenerator;

public class Main {
    public static void main(String[] args) {
        try {
            // Determine which test file to use
            String testFile = "input.test"; // default
            if (args.length > 0) {
                testFile = args[0];
            }
            
            System.out.println("TestLang++ Compiler Starting...");
            System.out.println("Parsing " + testFile + " ...");
            
            // Create parser with lexer
            Parser parser = new Parser(new Lexer(new FileReader("src/main/java/com/testlangpp/lexer/" + testFile)));

            // Parse the input file
            Program program = (Program) parser.parse().value;
            System.out.println("\n✅ Parsing successful!");
            System.out.println("Program parsed: " + program);
            
            // Generate JUnit tests
            System.out.println("\n🔧 Generating JUnit tests...");
            TestGenerator.generate(program);
            
            System.out.println("\n🎉 TestLang++ compilation completed successfully!");
            System.out.println("Generated: GeneratedTests.java");
            
        } catch (Exception e) {
            System.err.println("\n❌ Compilation failed: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}
