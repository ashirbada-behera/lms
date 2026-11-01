package org.example.lms.model;

public class DashboardStats {

    private int totalBooks;
    private int totalMembers;
    private int booksIssued;
    private int overdueBooks;

    public DashboardStats(int totalBooks, int totalMembers,
                          int booksIssued, int overdueBooks) {
        this.totalBooks = totalBooks;
        this.totalMembers = totalMembers;
        this.booksIssued = booksIssued;
        this.overdueBooks = overdueBooks;
    }

    public int getTotalBooks() {
        return totalBooks;
    }

    public int getTotalMembers() {
        return totalMembers;
    }

    public int getBooksIssued() {
        return booksIssued;
    }

    public int getOverdueBooks() {
        return overdueBooks;
    }
}
