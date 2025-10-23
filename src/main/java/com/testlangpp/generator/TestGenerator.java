package com.testlangpp.generator;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

import com.testlangpp.model.Program;
import com.testlangpp.model.RequestHeader;

public class TestGenerator {

    public static void generate(Program program) throws IOException {
        File outFile = new File("GeneratedTests.java");
        try (PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(outFile)))) {

            // --- Header imports ---
            pw.println("import org.junit.jupiter.api.*;");
            pw.println("import static org.junit.jupiter.api.Assertions.*;");
            pw.println("import java.net.http.*;");
            pw.println("import java.net.*;");
            pw.println("import java.time.Duration;");
            pw.println("import java.nio.charset.StandardCharsets;");
            pw.println("import java.util.*;");
            pw.println();
            
            // --- Class start ---
            pw.println("public class GeneratedTests {");

            // --- Static fields ---
            String base = (program.config != null && program.config.baseUrl != null)
                    ? program.config.baseUrl
                    : "http://localhost:8080";
            pw.println("  static String BASE = \"" + base + "\";");
            pw.println("  static Map<String,String> DEFAULT_HEADERS = new HashMap<>();");
            pw.println("  static HttpClient client;");
            pw.println();

            // --- Setup method ---
            pw.println("  @BeforeAll");
            pw.println("  static void setup() {");
            pw.println("    client = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(5)).build();");

            // Default headers from config block
            if (program.config != null && program.config.headers != null) {
                for (RequestHeader h : program.config.headers) {
                    pw.println("    DEFAULT_HEADERS.put(" 
                        + "\"" + h.key + "\", \"" + h.value + "\");");
                }
            }
            pw.println("  }");

            // --- End class ---
            pw.println("}");
        }
        System.out.println("✅ Generated: " + outFile.getAbsolutePath());
    }
}
