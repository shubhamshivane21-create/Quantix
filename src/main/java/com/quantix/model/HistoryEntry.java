package com.quantix.model;

public class HistoryEntry {
    private int id;
    private String expression;
    private String result;
    private String angleMode;
    private String createdAt;

    public HistoryEntry(int id, String expression, String result, String angleMode, String createdAt) {
        this.id = id;
        this.expression = expression;
        this.result = result;
        this.angleMode = angleMode;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public String getExpression() { return expression; }
    public String getResult() { return result; }
    public String getAngleMode() { return angleMode; }
    public String getCreatedAt() { return createdAt; }
}
