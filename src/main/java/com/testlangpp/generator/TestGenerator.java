package com.testlangpp.generator;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import com.testlangpp.model.Assertion;
import com.testlangpp.model.Program;
import com.testlangpp.model.RequestHeader;
import com.testlangpp.model.RequestStatement;
import com.testlangpp.model.TestBlock;
import com.testlangpp.model.Variable;

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
                    pw.println("    DEFAULT_HEADERS.put(\"" + h.key + "\", \"" + h.value + "\");");
                }
            }
            pw.println("  }");
            pw.println();

            // --- Generate test methods ---
            if (program.tests != null) {
                for (TestBlock test : program.tests) {
                    generateTestMethod(pw, test, program.variables);
                }
            }

            // --- End class ---
            pw.println("}");
        }
        System.out.println("✅ Generated: " + outFile.getAbsolutePath());
    }

    private static void generateTestMethod(PrintWriter pw, TestBlock test, List<Variable> variables) {
        pw.println("  @Test");
        pw.println("  void test_" + test.name + "() throws Exception {");

        RequestStatement req = test.request;
        
        // Substitute variables in path
        String path = substituteVariables(req.path, variables);
        
        // Determine full URL
        String url;
        if (path.startsWith("http://") || path.startsWith("https://")) {
            url = path;
        } else {
            url = "BASE + \"" + path + "\"";
        }

        // Build HTTP request
        pw.println("    HttpRequest.Builder b = HttpRequest.newBuilder(URI.create(" + url + "))");
        pw.println("      .timeout(Duration.ofSeconds(10))");

        // Set HTTP method and body
        String method = req.method.toUpperCase();
        if (method.equals("GET")) {
            pw.println("      .GET();");
        } else if (method.equals("DELETE")) {
            pw.println("      .DELETE();");
        } else if (method.equals("POST") || method.equals("PUT")) {
            if (req.body != null && req.body.content != null) {
                String bodyContent = substituteVariables(req.body.content, variables);
                bodyContent = escapeJavaString(bodyContent);
                pw.println("      ." + method + "(HttpRequest.BodyPublishers.ofString(\"" + bodyContent + "\"));");
            } else {
                pw.println("      ." + method + "(HttpRequest.BodyPublishers.noBody());");
            }
        }

        // Add default headers
        pw.println("    for (var e: DEFAULT_HEADERS.entrySet()) b.header(e.getKey(), e.getValue());");

        // Add request-specific headers
        if (req.headers != null) {
            for (RequestHeader h : req.headers) {
                String value = substituteVariables(h.value, variables);
                pw.println("    b.header(\"" + h.key + "\", \"" + value + "\");");
            }
        }

        // Send request
        pw.println("    HttpResponse<String> resp = client.send(b.build(), HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));");
        pw.println();

        // Generate assertions
        if (test.assertions != null) {
            for (Assertion assertion : test.assertions) {
                generateAssertion(pw, assertion, variables);
            }
        }

        pw.println("  }");
        pw.println();
    }

    private static void generateAssertion(PrintWriter pw, Assertion assertion, List<Variable> variables) {
        if (assertion.statusCode != null) {
            // expect status = NUMBER
            pw.println("    assertEquals(" + assertion.statusCode + ", resp.statusCode());");
        } else if (assertion.headerKey != null) {
            // expect header "K" = "V" or contains "V"
            String value = substituteVariables(assertion.headerValue, variables);
            if (assertion.isExactMatch) {
                pw.println("    assertEquals(\"" + value + "\", resp.headers().firstValue(\"" 
                    + assertion.headerKey + "\").orElse(\"\"));");
            } else {
                pw.println("    assertTrue(resp.headers().firstValue(\"" + assertion.headerKey 
                    + "\").orElse(\"\").contains(\"" + value + "\"));");
            }
        } else if (assertion.bodyContains != null) {
            // expect body contains "sub"
            String value = substituteVariables(assertion.bodyContains, variables);
            value = escapeJavaString(value);
            pw.println("    assertTrue(resp.body().contains(\"" + value + "\"));");
        }
    }

    /**
     * Substitutes $variableName with actual values from variable declarations.
     * Handles both string and integer variables.
     */
    private static String substituteVariables(String text, List<Variable> variables) {
        if (text == null || variables == null) return text;
        
        String result = text;
        
        // Sort variables by name length (longest first) to avoid partial matches
        // This prevents $user from matching part of $userId
        List<Variable> sortedVars = new ArrayList<>(variables);
        sortedVars.sort((a, b) -> Integer.compare(b.name.length(), a.name.length()));
        
        for (Variable var : sortedVars) {
            String placeholder = "$" + var.name;
            String value;
            if (var.stringValue != null) {
                value = var.stringValue;
            } else if (var.intValue != null) {
                value = var.intValue.toString();
            } else {
                continue;
            }
            result = result.replace(placeholder, value);
        }
        return result;
    }

    /**
     * Escapes special characters for Java string literals.
     * Handles: \" \\ \n \r \t
     */
    private static String escapeJavaString(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}