package com.testlangpp.lexer;

import java.io.BufferedReader;
import java.io.FileReader;

import java_cup.runtime.Symbol;

/**
 * Deep diagnostic tool to find lexer issues
 */
public class LexerDebugger {
    public static void main(String[] args) throws Exception {
        String path = "src/main/java/com/testlangpp/lexer/input.test";
        
        // First, show the raw file content
        System.out.println("========================================");
        System.out.println("RAW FILE CONTENT (first 100 chars):");
        System.out.println("========================================");
        BufferedReader reader = new BufferedReader(new FileReader(path));
        String firstLine = reader.readLine();
        reader.close();
        
        if (firstLine != null) {
            int len = Math.min(firstLine.length(), 100);
            String preview = firstLine.substring(0, len);
            System.out.println(preview);
            System.out.println();
            
            // Show character by character with positions
            System.out.println("CHARACTER ANALYSIS:");
            System.out.println("Pos | Char | ASCII | Description");
            System.out.println("----+------+-------+------------------");
            for (int i = 0; i < Math.min(30, firstLine.length()); i++) {
                char c = firstLine.charAt(i);
                String desc;
                if (c == ' ') desc = "SPACE";
                else if (c == '\t') desc = "TAB";
                else if (c == '\n') desc = "NEWLINE";
                else if (c == '\r') desc = "CARRIAGE_RETURN";
                else desc = String.valueOf(c);
                
                System.out.printf("%3d | '%c'  | %5d | %s\n", i, c, (int)c, desc);
            }
            System.out.println();
            
            // Highlight character 15
            if (firstLine.length() > 15) {
                System.out.println(">>> CHARACTER AT POSITION 15 <<<");
                char charAt15 = firstLine.charAt(15);
                System.out.printf("Character: '%c' (ASCII: %d)\n", charAt15, (int)charAt15);
                System.out.println("Context: ..." + firstLine.substring(Math.max(0, 10), Math.min(firstLine.length(), 20)) + "...");
                System.out.println("             ^^^^^");
                System.out.println();
            }
        }
        
        // Now tokenize
        System.out.println("========================================");
        System.out.println("TOKENIZATION:");
        System.out.println("========================================");
        
        Lexer lexer = new Lexer(new FileReader(path));
        
        int count = 0;
        int totalChars = 0;
        Symbol token;
        
        while (count < 20) {
            try {
                token = lexer.next_token();
                
                // EOF check (sym value 0 typically means EOF)
                if (token.sym == 0) {
                    System.out.println("\n[EOF reached]");
                    break;
                }
                
                count++;
                String tokenName = getTokenName(token.sym);
                String valueStr = token.value != null ? " = '" + token.value + "'" : "";
                
                System.out.printf("Token %2d: %-20s (sym=%d)%s\n", 
                    count, tokenName, token.sym, valueStr);
                
            } catch (Exception e) {
                System.err.println("\n❌ LEXER ERROR: " + e.getMessage());
                e.printStackTrace();
                break;
            }
        }
        
        System.out.println("\n========================================");
        System.out.println("DIAGNOSTIC COMPLETE");
        System.out.println("========================================");
    }
    
    private static String getTokenName(int sym) {
        // These need to match your sym.java values
        // You may need to adjust these based on actual generated values
        switch (sym) {
            case 0: return "EOF";
            case 1: return "error";
            case 2: return "CONFIG";
            case 3: return "BASE_URL";
            case 4: return "LET";
            case 5: return "TEST";
            case 6: return "EXPECT";
            case 7: return "STATUS";
            case 8: return "GET";
            case 9: return "POST";
            case 10: return "PUT";
            case 11: return "DELETE";
            case 12: return "HEADER";
            case 13: return "BODY";
            case 14: return "CONTAINS";
            case 15: return "LBRACE";
            case 16: return "RBRACE";
            case 17: return "EQUALS";
            case 18: return "SEMI";
            case 19: return "IDENT";
            case 20: return "STRING";
            case 21: return "NUMBER";
            default: return "UNKNOWN_" + sym;
        }
    }
}