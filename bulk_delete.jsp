<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String[] selectedIds = request.getParameterValues("selectedIds");
    
    if (selectedIds != null && selectedIds.length > 0) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/student_management",
                "root",
                "Huy882002"
            );
            
            for (String id : selectedIds) {
                String sql = "DELETE FROM students WHERE id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(id));
                pstmt.executeUpdate();
                pstmt.close();
            }
            
            response.sendRedirect("list_students.jsp?message=" + selectedIds.length + " student(s) deleted successfully!");
            
        } catch (ClassNotFoundException e) {
            response.sendRedirect("list_students.jsp?error=JDBC Driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            response.sendRedirect("list_students.jsp?error=Database Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    } else {
        response.sendRedirect("list_students.jsp?error=No students selected for deletion!");
    }
%>
