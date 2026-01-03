<%-- Document : admin Created on : 21 Dec 2025, 02.12.08 Author : ASUS --%>

    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ page import="java.sql.*, util.DatabaseConnection" %>
            <% if (session.getAttribute("role")==null || !"admin".equals(session.getAttribute("role"))) {
                response.sendRedirect(request.getContextPath() + "/orders" ); return; } %>
                <!DOCTYPE html>
                <html lang="id">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Admin Dashboard - PoS Laundry</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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

                        .card-stats {
                            background: linear-gradient(135deg, #667eea, #764ba2);
                            color: white;
                        }
                    </style>
                </head>

                <body>
                    <!-- Sidebar -->
                    <div class="sidebar">
                        <div class="text-center mb-4">
                            <h4><i class="fas fa-tshirt me-2"></i>PoSLaundry</h4>
                            <p>Admin Panel</p>
                        </div>
                        <ul class="nav flex-column">
                            <% if("admin".equals(session.getAttribute("role"))) { %>
                                <li class="nav-item"><a href="${pageContext.request.contextPath}/login"
                                        class="nav-link active"><i class="fas fa-home me-2"></i>Dashboard</a></li>
                                <li class="nav-item"><a href="${pageContext.request.contextPath}/services"
                                        class="nav-link"><i class="fas fa-list me-2"></i>Layanan</a></li>
                                <% } %>
                                    <li class="nav-item"><a href="${pageContext.request.contextPath}/orders"
                                            class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Pesanan</a></li>
                                    <% if("admin".equals(session.getAttribute("role"))) { %>
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
                                <h4 class="mb-0">Dashboard Admin</h4>
                                <span class="ms-auto">Halo, <%= session.getAttribute("username") %>!</span>
                            </div>
                        </nav>

                        <div class="row g-4">
                            <div class="col-md-4">
                                <div class="card card-stats">
                                    <div class="card-body">
                                        <h5 class="card-title"><i class="fas fa-users me-2"></i>Total Layanan</h5>
                                        <% int totalServices=0; try (Connection conn=DatabaseConnection.getConnection())
                                            { String sql="SELECT COUNT(*) as total FROM services" ; PreparedStatement
                                            stmt=conn.prepareStatement(sql); ResultSet rs=stmt.executeQuery(); if
                                            (rs.next()) totalServices=rs.getInt("total"); } catch (Exception e) {
                                            e.printStackTrace(); } %>
                                            <h2 class="display-4">
                                                <%= totalServices %>
                                            </h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card card-stats">
                                    <div class="card-body">
                                        <h5 class="card-title"><i class="fas fa-shopping-cart me-2"></i>Total Pesanan
                                        </h5>
                                        <% int totalOrders=0; try (Connection conn=DatabaseConnection.getConnection()) {
                                            String sql="SELECT COUNT(*) as total FROM orders" ; PreparedStatement
                                            stmt=conn.prepareStatement(sql); ResultSet rs=stmt.executeQuery(); if
                                            (rs.next()) totalOrders=rs.getInt("total"); } catch (Exception e) {
                                            e.printStackTrace(); } %>
                                            <h2 class="display-4">
                                                <%= totalOrders %>
                                            </h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card card-stats">
                                    <div class="card-body">
                                        <h5 class="card-title"><i class="fas fa-money-bill-wave me-2"></i>Total
                                            Pendapatan
                                        </h5>
                                        <% double totalRevenue=0; try (Connection
                                            conn=DatabaseConnection.getConnection()) { String
                                            sql="SELECT SUM(total_amount) as revenue FROM orders WHERE status = 'paid'"
                                            ; PreparedStatement stmt=conn.prepareStatement(sql); ResultSet
                                            rs=stmt.executeQuery(); if (rs.next()) totalRevenue=rs.getDouble("revenue");
                                            } catch (Exception e) { e.printStackTrace(); } %>
                                            <h2 class="display-4">Rp <%= String.format("%,.0f", totalRevenue) %>
                                            </h2>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Pencarian Pesanan -->
                        <div class="mb-4">
                            <form method="GET" action="orders.jsp" class="row g-2">
                                <div class="col-md-6">
                                    <input type="text" name="search" class="form-control"
                                        placeholder="Cari pelanggan, status, atau ID pesanan..."
                                        value="<%= request.getParameter(" search") !=null ?
                                        request.getParameter("search") : "" %>">
                                </div>
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-primary w-100"><i
                                            class="fas fa-search me-1"></i>Cari</button>
                                </div>
                                <div class="col-md-2">
                                    <a href="orders" class="btn btn-outline-secondary w-100">Reset</a>
                                </div>
                            </form>
                        </div>

                        <div class="mt-4">
                            <h5><i class="fas fa-chart-line me-2"></i>Statistik Pesanan Terbaru</h5>
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
                                            sql="SELECT o.id, c.name as customer_name, o.total_amount, o.status, o.created_at "
                                            + "FROM orders o JOIN customers c ON o.customer_id = c.id "
                                            + "ORDER BY o.created_at DESC LIMIT 5" ; PreparedStatement
                                            stmt=conn.prepareStatement(sql); ResultSet rs=stmt.executeQuery(); while
                                            (rs.next()) { String statusClass="badge bg-warning" ; if
                                            ("paid".equals(rs.getString("status"))) statusClass="badge bg-success" ;
                                            else if ("done".equals(rs.getString("status"))) statusClass="badge bg-info"
                                            ; %>
                                            <tr>
                                                <td>
                                                    <%= rs.getInt("id") %>
                                                </td>
                                                <td>
                                                    <%= rs.getString("customer_name") %>
                                                </td>
                                                <td>Rp <%= String.format("%,.0f", rs.getDouble("total_amount")) %>
                                                </td>
                                                <td><span class="<%= statusClass %>">
                                                        <%= rs.getString("status") %>
                                                    </span></td>
                                                <td>
                                                    <%= rs.getTimestamp("created_at") %>
                                                </td>
                                            </tr>
                                            <% } } catch (Exception e) { e.printStackTrace(); } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>