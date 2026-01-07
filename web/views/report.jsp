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
            <% // Get session attributes Integer userId=(Integer) session.getAttribute("userId"); String
                username=(String) session.getAttribute("username"); String role=(String) session.getAttribute("role");
                String period=(String) request.getAttribute("period"); if (period==null) period="today" ; // SQL date
                filter based on period String dateFilter="" ; switch(period) { case "week" :
                dateFilter="AND o.created_at >= DATE_SUB(NOW(), INTERVAL 1 WEEK)" ; break; case "month" :
                dateFilter="AND o.created_at >= DATE_SUB(NOW(), INTERVAL 1 MONTH)" ; break; case "all" : dateFilter="" ;
                break; default: // today dateFilter="AND DATE(o.created_at) = CURDATE()" ; } %>

                <!-- Sidebar -->
                <div class="sidebar">
                    <div class="text-center mb-4">
                        <h4><i class="fas fa-tshirt me-2"></i>PoSLaundry</h4>
                        <% if("admin".equals(role)) { %>
                            <p>Admin Panel</p>
                            <% } else { %>
                                <p>Karyawan Panel</p>
                                <% } %>
                    </div>
                    <ul class="nav flex-column">
                        <% if("admin".equals(role)) { %>
                            <li class="nav-item"><a href="${pageContext.request.contextPath}/login" class="nav-link"><i
                                        class="fas fa-home me-2"></i>Dashboard</a></li>
                            <li class="nav-item"><a href="${pageContext.request.contextPath}/services"
                                    class="nav-link"><i class="fas fa-list me-2"></i>Layanan</a></li>
                            <% } else { %>
                                <li class="nav-item"><a href="${pageContext.request.contextPath}/views/karyawan.jsp"
                                        class="nav-link"><i class="fas fa-home me-2"></i>Dashboard</a></li>
                                <% } %>
                                    <li class="nav-item"><a href="${pageContext.request.contextPath}/orders"
                                            class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Pesanan</a></li>
                                    <li class="nav-item"><a href="${pageContext.request.contextPath}/report"
                                            class="nav-link active"><i class="fas fa-chart-bar me-2"></i>Laporan</a>
                                    </li>
                                    <% if("admin".equals(role)) { %>
                                        <li class="nav-item"><a href="${pageContext.request.contextPath}/admin-panel"
                                                class="nav-link"><i class="fas fa-user-shield me-2"></i>Admin Panel</a>
                                        </li>
                                        <% } %>
                                            <li class="nav-item"><a href="${pageContext.request.contextPath}/logout"
                                                    class="nav-link text-danger"><i
                                                        class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                    </ul>
                </div>

                <!-- Content -->
                <div class="content">
                    <nav class="navbar navbar-expand-lg bg-white shadow-sm mb-4">
                        <div class="container-fluid">
                            <h4 class="mb-0"><i class="fas fa-chart-bar me-2"></i>Laporan Kinerja</h4>
                            <form method="get" action="${pageContext.request.contextPath}/report" class="d-flex">
                                <select name="period" class="form-select" onchange="this.form.submit()">
                                    <option value="today" <%="today" .equals(period) ? "selected" : "" %>>Hari Ini
                                    </option>
                                    <option value="week" <%="week" .equals(period) ? "selected" : "" %>>Minggu Ini
                                    </option>
                                    <option value="month" <%="month" .equals(period) ? "selected" : "" %>>Bulan Ini
                                    </option>
                                    <option value="all" <%="all" .equals(period) ? "selected" : "" %>>Semua Waktu
                                    </option>
                                </select>
                            </form>
                        </div>
                    </nav>

                    <!-- Statistics Cards -->
                    <div class="row g-4 mb-4">
                        <% int totalOrders=0; int completedOrders=0; double totalRevenue=0; double avgOrderValue=0; try
                            (Connection conn=DatabaseConnection.getConnection()) { // Total Orders String
                            sqlTotal="SELECT COUNT(*) as total FROM orders o WHERE employee_id = ? " + dateFilter;
                            PreparedStatement stmtTotal=conn.prepareStatement(sqlTotal); stmtTotal.setInt(1, userId);
                            ResultSet rsTotal=stmtTotal.executeQuery(); if (rsTotal.next())
                            totalOrders=rsTotal.getInt("total"); // Completed Orders String
                            sqlCompleted="SELECT COUNT(*) as total FROM orders o WHERE employee_id = ? AND status IN ('paid', 'done') "
                            + dateFilter; PreparedStatement stmtCompleted=conn.prepareStatement(sqlCompleted);
                            stmtCompleted.setInt(1, userId); ResultSet rsCompleted=stmtCompleted.executeQuery(); if
                            (rsCompleted.next()) completedOrders=rsCompleted.getInt("total"); // Total Revenue String
                            sqlRevenue="SELECT COALESCE(SUM(total_amount), 0) as revenue FROM orders o WHERE employee_id = ? AND status IN ('paid', 'done') "
                            + dateFilter; PreparedStatement stmtRevenue=conn.prepareStatement(sqlRevenue);
                            stmtRevenue.setInt(1, userId); ResultSet rsRevenue=stmtRevenue.executeQuery(); if
                            (rsRevenue.next()) totalRevenue=rsRevenue.getDouble("revenue"); // Average Order Value if
                            (completedOrders> 0) {
                            avgOrderValue = totalRevenue / completedOrders;
                            }
                            } catch (Exception e) {
                            e.printStackTrace();
                            }
                            %>

                            <div class="col-md-3">
                                <div class="card text-white bg-primary stat-card">
                                    <div class="card-body">
                                        <h6 class="card-title"><i class="fas fa-shopping-cart me-2"></i>Total Pesanan
                                        </h6>
                                        <h2 class="display-5">
                                            <%= totalOrders %>
                                        </h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card text-white bg-success stat-card">
                                    <div class="card-body">
                                        <h6 class="card-title"><i class="fas fa-check-circle me-2"></i>Pesanan Selesai
                                        </h6>
                                        <h2 class="display-5">
                                            <%= completedOrders %>
                                        </h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card text-white bg-info stat-card">
                                    <div class="card-body">
                                        <h6 class="card-title"><i class="fas fa-money-bill-wave me-2"></i>Total
                                            Pendapatan</h6>
                                        <h2 class="display-6">Rp <%= String.format("%,.0f", totalRevenue) %>
                                        </h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card text-white bg-warning stat-card">
                                    <div class="card-body">
                                        <h6 class="card-title"><i class="fas fa-chart-line me-2"></i>Rata-rata Pesanan
                                        </h6>
                                        <h2 class="display-6">Rp <%= String.format("%,.0f", avgOrderValue) %>
                                        </h2>
                                    </div>
                                </div>
                            </div>
                    </div>

                    <div class="row g-4">
                        <!-- Order Status Breakdown -->
                        <div class="col-md-6">
                            <div class="card shadow-sm">
                                <div class="card-header bg-white">
                                    <h5 class="mb-0"><i class="fas fa-pie-chart me-2"></i>Status Pesanan</h5>
                                </div>
                                <div class="card-body">
                                    <table class="table table-sm">
                                        <thead>
                                            <tr>
                                                <th>Status</th>
                                                <th class="text-end">Jumlah</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% try (Connection conn=DatabaseConnection.getConnection()) { String
                                                sqlStatus="SELECT status, COUNT(*) as count FROM orders o WHERE employee_id = ? "
                                                + dateFilter + " GROUP BY status ORDER BY count DESC" ;
                                                PreparedStatement stmtStatus=conn.prepareStatement(sqlStatus);
                                                stmtStatus.setInt(1, userId); ResultSet
                                                rsStatus=stmtStatus.executeQuery(); while (rsStatus.next()) { String
                                                status=rsStatus.getString("status"); int count=rsStatus.getInt("count");
                                                String badgeClass="badge bg-secondary" ; if ("pending".equals(status))
                                                badgeClass="badge bg-warning" ; else if ("paid".equals(status))
                                                badgeClass="badge bg-success" ; else if ("done".equals(status))
                                                badgeClass="badge bg-info" ; else if ("process".equals(status))
                                                badgeClass="badge bg-primary" ; else if ("cancelled".equals(status))
                                                badgeClass="badge bg-danger" ; %>
                                                <tr>
                                                    <td><span class="<%= badgeClass %>">
                                                            <%= status %>
                                                        </span></td>
                                                    <td class="text-end"><strong>
                                                            <%= count %>
                                                        </strong></td>
                                                </tr>
                                                <% } } catch (Exception e) { e.printStackTrace(); } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Top Customers -->
                        <div class="col-md-6">
                            <div class="card shadow-sm">
                                <div class="card-header bg-white">
                                    <h5 class="mb-0"><i class="fas fa-users me-2"></i>Pelanggan Teratas</h5>
                                </div>
                                <div class="card-body">
                                    <table class="table table-sm">
                                        <thead>
                                            <tr>
                                                <th>Pelanggan</th>
                                                <th class="text-end">Jumlah Pesanan</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% try (Connection conn=DatabaseConnection.getConnection()) { String
                                                sqlCustomers="SELECT c.name, COUNT(*) as order_count "
                                                + "FROM orders o JOIN customers c ON o.customer_id = c.id "
                                                + "WHERE o.employee_id = ? " + dateFilter
                                                + " GROUP BY c.id, c.name ORDER BY order_count DESC LIMIT 5" ;
                                                PreparedStatement stmtCustomers=conn.prepareStatement(sqlCustomers);
                                                stmtCustomers.setInt(1, userId); ResultSet
                                                rsCustomers=stmtCustomers.executeQuery(); while (rsCustomers.next()) {
                                                %>
                                                <tr>
                                                    <td><i class="fas fa-user-circle me-2 text-muted"></i>
                                                        <%= rsCustomers.getString("name") %>
                                                    </td>
                                                    <td class="text-end"><span class="badge bg-primary">
                                                            <%= rsCustomers.getInt("order_count") %>
                                                        </span></td>
                                                </tr>
                                                <% } } catch (Exception e) { e.printStackTrace(); } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Detailed Orders Table -->
                    <div class="mt-4">
                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <h5 class="mb-0"><i class="fas fa-list me-2"></i>Detail Pesanan</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Pelanggan</th>
                                                <th>Total</th>
                                                <th>Status</th>
                                                <th>Tanggal</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% try (Connection conn=DatabaseConnection.getConnection()) { String
                                                sqlOrders="SELECT o.id, c.name as customer_name, o.total_amount, o.status, o.created_at "
                                                + "FROM orders o JOIN customers c ON o.customer_id = c.id "
                                                + "WHERE o.employee_id = ? " + dateFilter
                                                + " ORDER BY o.created_at DESC LIMIT 50" ; PreparedStatement
                                                stmtOrders=conn.prepareStatement(sqlOrders); stmtOrders.setInt(1,
                                                userId); ResultSet rsOrders=stmtOrders.executeQuery(); while
                                                (rsOrders.next()) { String status=rsOrders.getString("status"); String
                                                statusClass="badge bg-warning" ; if ("paid".equals(status))
                                                statusClass="badge bg-success" ; else if ("done".equals(status))
                                                statusClass="badge bg-info" ; else if ("process".equals(status))
                                                statusClass="badge bg-primary" ; else if ("cancelled".equals(status))
                                                statusClass="badge bg-danger" ; %>
                                                <tr>
                                                    <td>
                                                        <%= rsOrders.getInt("id") %>
                                                    </td>
                                                    <td>
                                                        <%= rsOrders.getString("customer_name") %>
                                                    </td>
                                                    <td>Rp <%= String.format("%,.0f",
                                                            rsOrders.getDouble("total_amount")) %>
                                                    </td>
                                                    <td><span class="<%= statusClass %> status-badge">
                                                            <%= status %>
                                                        </span></td>
                                                    <td>
                                                        <%= rsOrders.getTimestamp("created_at") %>
                                                    </td>
                                                </tr>
                                                <% } } catch (Exception e) { e.printStackTrace(); } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>