<%@ page language="java" contentType="text/csv; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    response.setHeader("Content-Disposition", "attachment; filename=\"students.csv\"");
    
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/student_management",
            "root",
            "Huy882002"
        );
        
        stmt = conn.createStatement();
        
        // Write CSV header
        out.println("ID,Student Code,Full Name,Email,Major,Created At");
        
        // Get all students
        String sql = "SELECT * FROM students ORDER BY id DESC";
        rs = stmt.executeQuery(sql);
        
        while (rs.next()) {
            int id = rs.getInt("id");
            String studentCode = rs.getString("student_code");
            String fullName = rs.getString("full_name");
            String email = rs.getString("email") != null ? rs.getString("email") : "";
            String major = rs.getString("major") != null ? rs.getString("major") : "";
            Timestamp createdAt = rs.getTimestamp("created_at");
            
            // Escape quotes in data
            fullName = fullName.replace("\"", "\"\"");
            email = email.replace("\"", "\"\"");
            major = major.replace("\"", "\"\"");
            
            out.println("\"" + id + "\",\"" + studentCode + "\",\"" + fullName + "\",\"" + email + "\",\"" + major + "\",\"" + createdAt + "\"");
        }
        
    } catch (ClassNotFoundException e) {
        out.println("Error: JDBC Driver not found!");
        e.printStackTrace();
    } catch (SQLException e) {
        out.println("Database Error: " + e.getMessage());
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
