<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.sql.*, util.DatabaseConnection" %>
        <!DOCTYPE html>
        <html lang="id">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Pesanan - PoS Laundry</title>
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

                .status-badge {
                    font-size: 0.8rem;
                    padding: 0.5em 0.75em;
                }
            </style>
        </head>

        <body>
            <div class="sidebar">
                <div class="text-center mb-4">
                    <h4><i class="fas fa-tshirt me-2"></i>PoSLaundry</h4>
                </div>
                <ul class="nav flex-column">
                    <% if("admin".equals(session.getAttribute("role"))) { %>
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/login" class="nav-link"><i
                                    class="fas fa-home me-2"></i>Dashboard</a></li>
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/services" class="nav-link"><i
                                    class="fas fa-list me-2"></i>Layanan</a></li>
                        <% } %>
                            <li class="nav-item"><a href="${pageContext.request.contextPath}/orders"
                                    class="nav-link active"><i class="fas fa-shopping-cart me-2"></i>Pesanan</a></li>
                            <% if(!"admin".equals(session.getAttribute("role"))) { %>
                                <li class="nav-item"><a href="${pageContext.request.contextPath}/report"
                                        class="nav-link"><i class="fas fa-chart-bar me-2"></i>Laporan</a></li>
                                <% } %>
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

            <div class="content">
                <nav class="navbar navbar-expand-lg bg-white shadow-sm mb-4">
                    <div class="container-fluid">
                        <h4 class="mb-0">Daftar Pesanan</h4>
                        <a href="${pageContext.request.contextPath}/new_order" class="btn btn-primary"><i
                                class="fas fa-plus me-2"></i>Buat Pesanan</a>
                    </div>
                </nav>

                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Pelanggan</th>
                                <th>Karyawan</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th>Tanggal</th>
                                <th>Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% try (Connection conn=DatabaseConnection.getConnection()) { String
                                sql="SELECT o.id, c.name as customer_name, u.username as employee_name, o.total_amount, o.status, o.created_at FROM orders o JOIN customers c ON o.customer_id = c.id JOIN users u ON o.employee_id = u.id ORDER BY o.created_at DESC"
                                ; PreparedStatement stmt=conn.prepareStatement(sql); ResultSet rs=stmt.executeQuery();
                                int no=1; while (rs.next()) { int orderId=rs.getInt("id"); String
                                customerName=rs.getString("customer_name"); String
                                employeeName=rs.getString("employee_name"); double
                                totalAmount=rs.getDouble("total_amount"); String status=rs.getString("status");
                                java.sql.Timestamp createdAt=rs.getTimestamp("created_at"); String
                                statusClass="badge bg-warning" ; if ("paid".equals(status))
                                statusClass="badge bg-success" ; else if ("done".equals(status))
                                statusClass="badge bg-info" ; else if ("process".equals(status))
                                statusClass="badge bg-primary" ; String contextPath=request.getContextPath(); %>
                                <tr>
                                    <td>
                                        <%= no++ %>
                                    </td>
                                    <td>
                                        <%= customerName %>
                                    </td>
                                    <td>
                                        <%= employeeName %>
                                    </td>
                                    <td>Rp <%= String.format("%,.0f", totalAmount) %>
                                    </td>
                                    <td><span class="<%= statusClass %> status-badge">
                                            <%= status %>
                                        </span></td>
                                    <td>
                                        <%= createdAt %>
                                    </td>
                                    <td>
                                        <% if (!"paid".equals(status) && !"cancelled".equals(status)) { %>
                                            <a href="<%= contextPath %>/payment?orderId=<%= orderId %>"
                                                class="btn btn-sm btn-outline-success" title="Bayar"><i
                                                    class="fas fa-money-bill-wave"></i></a>
                                            <a href="<%= contextPath %>/orders?action=cancel&id=<%= orderId %>"
                                                onclick="return confirm('Yakin batalkan pesanan ini?')"
                                                class="btn btn-sm btn-outline-warning" title="Batalkan"><i
                                                    class="fas fa-times"></i></a>
                                            <% } else if ("cancelled".equals(status)) { %>
                                                <a href="<%= contextPath %>/orders?action=delete&id=<%= orderId %>"
                                                    onclick="return confirm('Yakin hapus permanen pesanan ini?')"
                                                    class="btn btn-sm btn-outline-danger" title="Hapus"><i
                                                        class="fas fa-trash"></i></a>
                                                <% } else { %>
                                                    <span class="text-success"><i class="fas fa-check-circle"></i>
                                                        Selesai</span>
                                                    <% } %>
                                    </td>
                                </tr>
                                <% } } catch (Exception e) { e.printStackTrace(); } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>