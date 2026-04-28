<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        h1 { color: #333; }
        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin-bottom: 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
        }
        th {
            background-color: #007bff;
            color: white;
            padding: 12px;
            text-align: left;
        }
        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        tr:hover { background-color: #f8f9fa; }
        .action-link {
            color: #007bff;
            text-decoration: none;
            margin-right: 10px;
        }
        .delete-link { color: #dc3545; }
        th a {
            color: white;
            text-decoration: none;
            cursor: pointer;
        }
        th a:hover {
            text-decoration: underline;
        }
        .sort-indicator {
            margin-left: 5px;
            font-size: 12px;
        }
        .student-checkbox {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        .search-form {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
        }
        .search-form input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        .search-form button {
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }
        .search-form button:hover {
            background-color: #218838;
        }
        .pagination {
            display: flex;
            justify-content: center;
            gap: 5px;
            margin-top: 20px;
            align-items: center;
        }
        .pagination a, .pagination span {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            text-decoration: none;
            color: #007bff;
            background-color: white;
        }
        .pagination a:hover {
            background-color: #007bff;
            color: white;
        }
        .pagination .current {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        .pagination .disabled {
            color: #ccc;
            cursor: not-allowed;
            border-color: #ddd;
        }
        .table-responsive {
            overflow-x: auto;
        }
        @media (max-width: 768px) {
            body {
                margin: 10px;
            }
            h1 {
                font-size: 20px;
            }
            table {
                font-size: 12px;
            }
            th, td {
                padding: 5px;
            }
            .action-link {
                margin-right: 5px;
            }
            .btn {
                padding: 8px 15px;
        
        function toggleCheckboxes(selectAllCheckbox) {
            var checkboxes = document.querySelectorAll('.student-checkbox');
            checkboxes.forEach(function(checkbox) {
                checkbox.checked = selectAllCheckbox.checked;
            });
            updateSelectedCount();
        }
        
        function updateSelectedCount() {
            var checkboxes = document.querySelectorAll('.student-checkbox:checked');
            var count = checkboxes.length;
            var countSpan = document.getElementById('selectedCount');
            if (count > 0) {
                countSpan.textContent = '(' + count + ' selected)';
            } else {
                countSpan.textContent = '';
            }
        }
        
        document.addEventListener('change', function(e) {
            if (e.target.classList.contains('student-checkbox')) {
                updateSelectedCount();
            }
        });
        
        window.addEventListener('load', function() {
            setTimeout(hideMessage, 3000);
            updateSelectedCount(
            .search-form {
                flex-direction: column;
            }
            .search-form input, .search-form button {
                width: 100%;
            }
        }
    </style>
    <script>
        function hideMessage() {
            var messages = document.querySelectorAll('.message');
            messages.forEach(function(msg) {
                msg.style.display = 'none';
            });
        }
        window.addEventListener('load', function() {
            setTimeout(hideMessage, 3000);
        });
    </script>
</head>
<body>
    <h1>📚 Student Management System</h1>
    
    <% if (request.getParameter("message") != null) { %>
        <div class="message success">
            ✅ <%= request.getParameter("message") %>
        </div>
    <% } %>
    
    <% if (request.getParameter("error") != null) { %>
        <div class="message error">
            ❌ <%= request.getParameter("error") %>
        </div>
    <% } %>
    
    <a href="add_student.jsp" class="btn">➕ Add New Student</a>
    <a href="export_csv.jsp" class="btn" style="background-color: #28a745;">📥 Export to CSV</a>
    
    <!-- Search Form -->
    <form action="list_students.jsp" method="GET" class="search-form">
        <input type="text" name="keyword" placeholder="Search by name or code..." 
               value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
        <button type="submit">Search</button>
    </form>
    
    <div class="table-responsive">
    <form id="bulkDeleteForm" method="POST" action="bulk_delete.jsp">
    <table>
        <thead>
            <tr>
                <th style="width: 40px;">
                    <input type="checkbox" id="selectAll" onchange="toggleCheckboxes(this)">
                </th>
                <th>
                    <a href="list_students.jsp?sort=id&order=<%= "id".equals(request.getParameter("sort")) && "asc".equals(request.getParameter("order")) ? "desc" : "asc" %><%= request.getParameter("keyword") != null ? "&keyword=" + request.getParameter("keyword") : "" %>">
                        ID <span class="sort-indicator"><%= "id".equals(request.getParameter("sort")) ? ("asc".equals(request.getParameter("order")) ? "▲" : "▼") : "" %></span>
                    </a>
                </th>
                <th>
                    <a href="list_students.jsp?sort=student_code&order=<%= "student_code".equals(request.getParameter("sort")) && "asc".equals(request.getParameter("order")) ? "desc" : "asc" %><%= request.getParameter("keyword") != null ? "&keyword=" + request.getParameter("keyword") : "" %>">
                        Student Code <span class="sort-indicator"><%= "student_code".equals(request.getParameter("sort")) ? ("asc".equals(request.getParameter("order")) ? "▲" : "▼") : "" %></span>
                    </a>
                </th>
                <th>
                    <a href="list_students.jsp?sort=full_name&order=<%= "full_name".equals(request.getParameter("sort")) && "asc".equals(request.getParameter("order")) ? "desc" : "asc" %><%= request.getParameter("keyword") != null ? "&keyword=" + request.getParameter("keyword") : "" %>">
                        Full Name <span class="sort-indicator"><%= "full_name".equals(request.getParameter("sort")) ? ("asc".equals(request.getParameter("order")) ? "▲" : "▼") : "" %></span>
                    </a>
                </th>
                <th>Email</th>
                <th>Major</th>
                <th>
                    <a href="list_students.jsp?sort=created_at&order=<%= "created_at".equals(request.getParameter("sort")) && "asc".equals(request.getParameter("order")) ? "desc" : "asc" %><%= request.getParameter("keyword") != null ? "&keyword=" + request.getParameter("keyword") : "" %>">
                        Created At <span class="sort-indicator"><%= "created_at".equals(request.getParameter("sort")) ? ("asc".equals(request.getParameter("order")) ? "▲" : "▼") : "" %></span>
                    </a>
                </th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    // Get page number from URL (default = 1)
    String pageParam = request.getParameter("page");
    int currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
    
    // Records per page
    int recordsPerPage = 10;
    
    // Calculate offset
    int offset = (currentPage - 1) * recordsPerPage;
    
    // Get total records for pagination
    int totalRecords = 0;
    int totalPages = 0;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/student_management",
            "root",
            "Huy882002"
        );
        
        stmt = conn.createStatement();
        
        // Build SQL with search functionality
        String keyword = request.getParameter("keyword");
        String whereClause = "";
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            whereClause = " WHERE LOWER(full_name) LIKE LOWER('%" + keyword + "%') " +
                         "OR LOWER(student_code) LIKE LOWER('%" + keyword + "%') " +
                         "OR LOWER(major) LIKE LOWER('%" + keyword + "%')";
        }
        
        // Get total records count
        String countSql = "SELECT COUNT(*) FROM students" + whereClause;
        rs = stmt.executeQuery(countSql);
        if (rs.next()) {
            totalRe style="text-align: center;">
                    <input type="checkbox" name="selectedIds" value="<%= id %>" class="student-checkbox">
                </td>
                <tdcords = rs.getInt(1);
        }
        rs.close();
        
        // Calculate total pages
        totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        
        // Handle sorting
        String sortBy = request.getParameter("sort") != null ? request.getParameter("sort") : "id";
        String order = request.getParameter("order") != null ? request.getParameter("order") : "desc";
        
        // Validate sort column to prevent SQL injection
        if (!sortBy.matches("^(id|student_code|full_name|email|major|created_at)$")) {
            sortBy = "id";
        }
        if (!order.matches("^(asc|desc)$")) {
            order = "desc";
        }
        
        // Get paginated data with sorting
        String sql = "SELECT * FROM students" + whereClause + " ORDER BY " + sortBy + " " + order + " LIMIT " + recordsPerPage + " OFFSET " + offset;
        rs = stmt.executeQuery(sql);
        
        while (rs.next()) {
            int id = rs.getInt("id");
            String studentCode = rs.getString("student_code");
            String fullName = rs.getString("full_name");
            String email = rs.getString("email");
            String major = rs.getString("major");
            Timestamp createdAt = rs.getTimestamp("created_at");
%>
            <tr>
                <td><%= id %></td>
                <td><%= studentCode %></td>
                <td><%= fullName %></td>
                <td><%= email != null ? email : "N/A" %></td>
                <td><%= major != null ? major : "N/A" %></td>
                <td><%= createdAt %></td>
                <td>
                    <a href="edit_student.jsp?id=<%= id %>" class="action-link">✏️ Edit</a>
                    <a href="delete_student.jsp?id=<%= id %>" 
                       class="action-link delete-link"
                       onclick="return confirm('Are you sure?')">🗑️ Delete</a>
                </td>
            </tr>
<%
        }
    } catch (ClassNotFoundException e) {
        out.println("<tr><td colspan='7'>Error: JDBC Driver not found!</td></tr>");
        e.printStackTrace();
    } catch (SQLException e) {
        out.println("<tr><td colspan='7'>Database Error: " + e.getMessage() + "</td></tr>");
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
    <div style="margin-top: 15px;">
        <button type="submit" onclick="return confirm('Delete selected students?')" style="background-color: #dc3545; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer;">
            🗑️ Delete Selected
        </button>
        <span id="selectedCount" style="margin-left: 20px; font-weight: bold;"></span>
    </div>
    </form>
    
        </tbody>
    </table>
    </div>
    
    <!-- Pagination Links -->
    <div class="pagination">
        <% 
            int currentPage = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
            String searchParam = !keyword.isEmpty() ? "&keyword=" + keyword : "";
        %>
        
        <!-- Previous Link -->
        <% if (currentPage > 1) { %>
            <a href="list_students.jsp?page=<%= currentPage - 1 %><%= searchParam %>">Previous</a>
        <% } else { %>
            <span class="disabled">Previous</span>
        <% } %>
        
        <!-- Page Numbers -->
        <% for (int i = 1; i <= totalPages; i++) { %>
            <% if (i == currentPage) { %>
                <span class="current"><%= i %></span>
            <% } else { %>
                <a href="list_students.jsp?page=<%= i %><%= searchParam %>"><%= i %></a>
            <% } %>
        <% } %>
        
        <!-- Next Link -->
        <% if (currentPage < totalPages) { %>
            <a href="list_students.jsp?page=<%= currentPage + 1 %><%= searchParam %>">Next</a>
        <% } else { %>
            <span class="disabled">Next</span>
        <% } %>
    </div>
</body>
</html>