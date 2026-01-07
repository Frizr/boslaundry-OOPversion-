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
                <li class="nav-item"><a href="${pageContext.request.contextPath}/orders" class="nav-link active"><i
                            class="fas fa-shopping-cart me-2"></i>Pesanan Saya</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/new_order" class="nav-link"><i
                            class="fas fa-plus me-2"></i>Buat Pesanan</a></li>
                <% if(!"admin".equals(session.getAttribute("role"))) { %>
                    <li class="nav-item"><a href="${pageContext.request.contextPath}/report" class="nav-link"><i
                                class="fas fa-chart-bar me-2"></i>Laporan</a></li>
                    <% } %>
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/logout"
                                class="nav-link text-danger"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
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

            <div class="mt-2">
                <div class="card shadow-sm border">
                    <div class="card-header bg-white">
                        <h5 class="mb-0 py-1"><i class="fas fa-history me-2 text-primary"></i>Riwayat Pesanan Saya</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-3">#</th>
                                        <th>Pelanggan</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th class="pe-3">Tanggal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% try (Connection conn=DatabaseConnection.getConnection()) { String
                                        sql="SELECT o.id, c.name as customer_name, o.total_amount, o.status, o.created_at "
                                        + "FROM orders o JOIN customers c ON o.customer_id = c.id "
                                        + "WHERE o.employee_id = ? ORDER BY o.created_at DESC LIMIT 5" ;
                                        PreparedStatement stmt=conn.prepareStatement(sql); stmt.setInt(1,
                                        (int)session.getAttribute("userId")); ResultSet rs=stmt.executeQuery(); while
                                        (rs.next()) { String statusClass="badge bg-warning" ; if
                                        ("paid".equals(rs.getString("status"))) statusClass="badge bg-success" ; else if
                                        ("done".equals(rs.getString("status"))) statusClass="badge bg-info" ; %>
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
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>