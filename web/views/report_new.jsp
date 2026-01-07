<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, util.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laporan - PoS Laundry</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #f8f9fa;
        }

        .sidebar {
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background: #343a40;
            color: white;
            padding-top: 20px;
            width: 250px;
            overflow-y: auto;
        }

        .content {
            margin-left: 250px;
            padding: 20px;
        }

        .nav-link {
            color: #adb5bd;
        }

        .nav-link.active {
            color: white;
            background: #495057;
        }

        .stat-card {
            transition: transform 0.2s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .status-badge {
            font-size: 0.8rem;
            padding: 0.5em 0.75em;
        }
    </style>
</head>

<body>
    <%
        Integer userId = (Integer) session.getAttribute("userId");
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");
        String period = (String) request.getAttribute("period");
        if (period == null) period = "today";
        
        String dateFilter = "";
        switch(period) {
            case "week":
                dateFilter = "AND o.created_at >= DATE_SUB(NOW(), INTERVAL 1 WEEK)";
                break;
            case "month":
                dateFilter = "AND o.created_at >= DATE_SUB(NOW(), INTERVAL 1 MONTH)";
                break;
            case "all":
                dateFilter = "";
                break;
            default:
                dateFilter = "AND DATE(o.created_at) = CURDATE()";
        }
    %>
