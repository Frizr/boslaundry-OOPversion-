<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Karyawan - PoS Laundry</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background: #f8f9fa; }
        .sidebar { height: 100vh; position: fixed; top: 0; left: 0; background: #343a40; color: white; padding-top: 20px; }
        .content { margin-left: 250px; padding: 20px; }
        .nav-link { color: #adb5bd; }
        .nav-link.active { color: white; background: #495057; }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="text-center mb-4">
            <h4><i class="fas fa-tshirt me-2"></i>PoSLaundry</h4>
            <p>Karyawan Panel</p>
        </div>
        <ul class="nav flex-column">
            <li class="nav-item"><a href="karyawan.jsp" class="nav-link active"><i class="fas fa-home me-2"></i>Dashboard</a></li>
            <li class="nav-item"><a href="new_order.jsp" class="nav-link"><i class="fas fa-plus me-2"></i>Buat Pesanan</a></li>
            <li class="nav-item"><a href="orders.jsp" class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Pesanan Saya</a></li>
            <li class="nav-item"><a href="logout" class="nav-link text-danger"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
        </ul>
    </div>

    <!-- Content -->
    <div class="content">
        <nav class="navbar navbar-expand-lg bg-white shadow-sm mb-4">
            <div class="container-fluid">
                <h4 class="mb-0">Dashboard Karyawan</h4>
                <span class="ms-auto">Halo, <%= session.getAttribute("username") %>!</span>
            </div>
        </nav>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="card text-white bg-primary">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-shopping-cart me-2"></i>Pesanan Hari Ini</h5>
                        <%
                            int todayOrders = 0;
                            try (Connection conn = DatabaseConnection.getConnection()) {
                                String sql = "SELECT COUNT(*) as total FROM orders WHERE DATE(created_at) = CURDATE() AND employee_id = ?";
                                PreparedStatement stmt = conn.prepareStatement(sql);
                                stmt.setInt(1, (int)session.getAttribute("userId"));
                                ResultSet rs = stmt.executeQuery();
                                if (rs.next()) todayOrders = rs.getInt("total");
                            } catch (Exception e) { e.printStackTrace(); }
                        %>
                        <h2 class="display-4"><%= todayOrders %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-success">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-check-circle me-2"></i>Pesanan Selesai</h5>
                        <%
                            int completedOrders = 0;
                            try (Connection conn = DatabaseConnection.getConnection()) {
                                String sql = "SELECT COUNT(*) as total FROM orders WHERE status IN ('done', 'paid') AND employee_id = ?";
                                PreparedStatement stmt = conn.prepareStatement(sql);
                                stmt.setInt(1, (int)session.getAttribute("userId"));
                                ResultSet rs = stmt.executeQuery();
                                if (rs.next()) completedOrders = rs.getInt("total");
                            } catch (Exception e) { e.printStackTrace(); }
                        %>
                        <h2 class="display-4"><%= completedOrders %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-info">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-money-bill-wave me-2"></i>Pendapatan Hari Ini</h5>
                        <%
                            double todayRevenue = 0;
                            try (Connection conn = DatabaseConnection.getConnection()) {
                                String sql = "SELECT SUM(total_amount) as revenue FROM orders WHERE DATE(created_at) = CURDATE() AND employee_id = ?";
                                PreparedStatement stmt = conn.prepareStatement(sql);
                                stmt.setInt(1, (int)session.getAttribute("userId"));
                                ResultSet rs = stmt.executeQuery();
                                if (rs.next()) todayRevenue = rs.getDouble("revenue");
                            } catch (Exception e) { e.printStackTrace(); }
                        %>
                        <h2 class="display-4">Rp <%= String.format("%,.0f", todayRevenue) %></h2>
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-4">
            <h5><i class="fas fa-history me-2"></i>Riwayat Pesanan Terakhir</h5>
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
                        <%
                            try (Connection conn = DatabaseConnection.getConnection()) {
                                String sql = "SELECT o.id, c.name as customer_name, o.total_amount, o.status, o.created_at " +
                                            "FROM orders o JOIN customers c ON o.customer_id = c.id " +
                                            "WHERE o.employee_id = ? ORDER BY o.created_at DESC LIMIT 5";
                                PreparedStatement stmt = conn.prepareStatement(sql);
                                stmt.setInt(1, (int)session.getAttribute("userId"));
                                ResultSet rs = stmt.executeQuery();
                                while (rs.next()) {
                                    String statusClass = "badge bg-warning";
                                    if ("paid".equals(rs.getString("status"))) statusClass = "badge bg-success";
                                    else if ("done".equals(rs.getString("status"))) statusClass = "badge bg-info";
                        %>
                        <tr>
                            <td><%= rs.getInt("id") %></td>
                            <td><%= rs.getString("customer_name") %></td>
                            <td>Rp <%= String.format("%,.0f", rs.getDouble("total_amount")) %></td>
                            <td><span class="<%= statusClass %>"><%= rs.getString("status") %></span></td>
                            <td><%= rs.getTimestamp("created_at") %></td>
                        </tr>
                        <%
                                }
                            } catch (Exception e) { e.printStackTrace(); }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>