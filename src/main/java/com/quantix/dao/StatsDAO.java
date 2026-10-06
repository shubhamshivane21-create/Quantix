package com.quantix.dao;

import com.quantix.model.DashboardStats;
import com.quantix.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class StatsDAO {

    // Longer names first so "asin" is not counted as "sin"
    private static final Pattern TOKEN =
        Pattern.compile("asin|acos|atan|sin|cos|tan|log|ln|\u221a|\\^|!|%");

    private static String label(String token) {
        switch (token) {
            case "\u221a": return "sqrt";
            case "^":      return "power (x^y)";
            case "!":      return "factorial";
            case "%":      return "percent";
            default:       return token;
        }
    }

    public DashboardStats get(int userId) throws SQLException {
        int total = 0;
        int today = 0;
        LocalDate todayDate = LocalDate.now();
        LocalDate start = todayDate.minusDays(6);
        Map<LocalDate, Integer> raw = new HashMap<>();
        Map<String, Integer> feats = new HashMap<>();

        try (Connection conn = DBConnection.getConnection()) {

            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM history WHERE user_id = ?")) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) { if (rs.next()) total = rs.getInt(1); }
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COUNT(*) FROM history WHERE user_id = ? AND DATE(created_at) = ?")) {
                ps.setInt(1, userId);
                ps.setString(2, todayDate.toString());
                try (ResultSet rs = ps.executeQuery()) { if (rs.next()) today = rs.getInt(1); }
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT DATE(created_at) AS d, COUNT(*) AS c FROM history "
                  + "WHERE user_id = ? AND DATE(created_at) >= ? GROUP BY DATE(created_at)")) {
                ps.setInt(1, userId);
                ps.setString(2, start.toString());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) raw.put(LocalDate.parse(rs.getString("d")), rs.getInt("c"));
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT expression FROM history WHERE user_id = ? ORDER BY id DESC LIMIT 2000")) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Matcher m = TOKEN.matcher(rs.getString(1));
                        while (m.find()) feats.merge(label(m.group()), 1, Integer::sum);
                    }
                }
            }
        }

        // One entry per day for the last 7 days, including days with zero calculations
        Map<String, Integer> perDay = new LinkedHashMap<>();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("EEE d", Locale.ENGLISH);
        for (int i = 0; i < 7; i++) {
            LocalDate d = start.plusDays(i);
            perDay.put(d.format(fmt), raw.getOrDefault(d, 0));
        }

        // Top 6 most used functions
        List<Map.Entry<String, Integer>> sorted = new ArrayList<>(feats.entrySet());
        sorted.sort((a, b) -> b.getValue() - a.getValue());
        Map<String, Integer> top = new LinkedHashMap<>();
        for (int i = 0; i < Math.min(6, sorted.size()); i++) {
            top.put(sorted.get(i).getKey(), sorted.get(i).getValue());
        }

        return new DashboardStats(total, today, perDay, top);
    }
}
