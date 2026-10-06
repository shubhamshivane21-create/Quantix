package com.quantix.model;

import java.util.Map;

public class DashboardStats {
    private final int total;
    private final int today;
    private final Map<String, Integer> perDay;
    private final Map<String, Integer> topFeatures;

    public DashboardStats(int total, int today, Map<String, Integer> perDay, Map<String, Integer> topFeatures) {
        this.total = total;
        this.today = today;
        this.perDay = perDay;
        this.topFeatures = topFeatures;
    }

    public int getTotal() { return total; }
    public int getToday() { return today; }
    public Map<String, Integer> getPerDay() { return perDay; }
    public Map<String, Integer> getTopFeatures() { return topFeatures; }
}
