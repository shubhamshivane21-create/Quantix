package com.quantix.dao;

import com.quantix.model.HistoryEntry;
import com.quantix.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class HistoryDAO {

    public void save(int userId, String expression, String result, String angleMode) throws SQLException {
        String sql = "INSERT INTO history (user_id, expression, result, angle_mode) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, expression);
            ps.setString(3, result);
            ps.setString(4, angleMode);
            ps.executeUpdate();
        }
    }

    public List<HistoryEntry> list(int userId, int limit) throws SQLException {
        String sql = "SELECT id, expression, result, angle_mode, DATE_FORMAT(created_at, '%d %b %Y, %h:%i %p') AS created_text "
                   + "FROM history WHERE user_id = ? ORDER BY id DESC LIMIT ?";
        List<HistoryEntry> items = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(new HistoryEntry(rs.getInt("id"), rs.getString("expression"),
                                               rs.getString("result"), rs.getString("angle_mode"),
                                               rs.getString("created_text")));
                }
            }
        }
        return items;
    }

    // user_id is checked too, so one user can never delete another user's rows
    public void delete(int id, int userId) throws SQLException {
        String sql = "DELETE FROM history WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public void clearAll(int userId) throws SQLException {
        String sql = "DELETE FROM history WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
}
