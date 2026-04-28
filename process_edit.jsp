<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.regex.*" %>
<%
    String idParam = request.getParameter("id");
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String major = request.getParameter("major");
    
    if (idParam == null || idParam.trim().isEmpty() || fullName == null || fullName.trim().isEmpty()) {
        response.sendRedirect("list_students.jsp?error=Invalid data");
        return;
    }
    
    int studentId = 0;
    try {
        studentId = Integer.parseInt(idParam);
    } catch (NumberFormatException e) {
        response.sendRedirect("list_students.jsp?error=Invalid student ID");
        return;
    }
    
    // 6.1: Validate email format if provided
    if (email != null && !email.trim().isEmpty()) {
        String emailPattern = "^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        if (!email.matches(emailPattern)) {
            response.sendRedirect("edit_student.jsp?id=" + studentId + "&error=Invalid email format");
            return;
        }
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/student_management",
            "root",
            "Huy882002"
        );
        
        String sql = "UPDATE students SET full_name = ?, email = ?, major = ? WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, fullName);
        pstmt.setString(2, email);
        pstmt.setString(3, major);
        pstmt.setInt(4, studentId);
        
        int rowsAffected = pstmt.executeUpdate();
        
        if (rowsAffected > 0) {
            response.sendRedirect("list_students.jsp?message=Student updated successfully");
        } else {
            response.sendRedirect("edit_student.jsp?id=" + studentId + "&error=Update failed");
        }
        
    } catch (Exception e) {
        response.sendRedirect("edit_student.jsp?id=" + studentId + "&error=Error occurred");
        e.printStackTrace();
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
