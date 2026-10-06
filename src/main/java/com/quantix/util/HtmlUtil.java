package com.quantix.util;

public class HtmlUtil {
    // Prevents stored text from being interpreted as HTML (XSS protection)
    public static String escape(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
}
