package com.quantix.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public final class CsrfUtil {
    private static final SecureRandom RANDOM = new SecureRandom();

    private CsrfUtil() { }

    public static String createToken() {
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    public static boolean isValid(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;
        Object saved = session.getAttribute("csrf");
        String received = req.getParameter("_csrf");
        if (received == null) received = req.getHeader("X-CSRF-Token");
        if (!(saved instanceof String) || received == null) return false;
        return MessageDigest.isEqual(((String) saved).getBytes(java.nio.charset.StandardCharsets.US_ASCII),
                                     received.getBytes(java.nio.charset.StandardCharsets.US_ASCII));
    }
}
