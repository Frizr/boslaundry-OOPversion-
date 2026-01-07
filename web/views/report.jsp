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

                /* Added borders and shadows for premium look */
                .card {
                    border: 1px solid #dee2e6;
                    box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
                    border-radius: 10px;
                }

                .stat-card {
                    transition: transform 0.2s;
                    border: none;
                }

                .stat-card:hover {
                    transform: translateY(-5px);
                }

                .status-badge {
                    font-size: 0.8rem;
                    padding: 0.5em 0.75em;
                }

                .table-container {
                    background: white;
                    border-radius: 10px;
                    border: 1px solid #dee2e6;
                    overflow: hidden;
                }

                .card-header {
                    border-bottom: 1px solid #dee2e6;
                    font-weight: bold;
                }
            </style>
        </head>

        <body>
            <% /* Get session attributes */ Integer userId=(Integer) session.getAttribute("userId"); String
                username=(String) session.getAttribute("username"); String role=(String) session.getAttribute("role");
                String period=(String) request.getAttribute("period"); if (period==null) period="today" ; /* SQL date
                filter based on period */ String dateFilter="" ; if ("week".equals(period)) {
                dateFilter="WHERE o.created_at >= DATE_SUB(NOW(), INTERVAL 1 WEEK)" ; } else if ("month".equals(period))
                { dateFilter="WHERE o.created_at >= DATE_SUB(NOW(), INTERVAL 1 MONTH)" ; } else if
                ("all".equals(period)) { dateFilter="" ; } else { /* Default: today */
                dateFilter="WHERE DATE(o.created_at) = CURDATE()" ; } %>

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
                            <% } %>
                                <% /* Karyawan Dashboard removed, starting with Pesanan */ %>
                                    <li class="nav-item"><a href="${pageContext.request.contextPath}/orders"
                                            class="nav-link"><i class="fas fa-shopping-cart me-2"></i>Pesanan</a></li>
                                    <% if(!"admin".equals(role)) { %>
                                        <li class="nav-item"><a href="${pageContext.request.contextPath}/report"
                                                class="nav-link active"><i class="fas fa-chart-bar me-2"></i>Laporan</a>
                                        </li>
                                        <% } %>
                                            <% if("admin".equals(role)) { %>
                                                <li class="nav-item"><a
                                                        href="${pageContext.request.contextPath}/admin-panel"
                                                        class="nav-link"><i class="fas fa-user-shield me-2"></i>Admin
                                                        Panel</a>
                                                </li>
                                                <% } %>
                                                    <li class="nav-item"><a
                                                            href="${pageContext.request.contextPath}/logout"
                                                            class="nav-link text-danger"><i
                                                                class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                    </ul>
                </div>

                <!-- Content -->
                <div class="content">
                    <nav class="navbar navbar-expand-lg bg-white shadow-sm mb-4 border rounded">
                        <div class="container-fluid">
                            <h4 class="mb-0"><i class="fas fa-chart-bar me-2 text-primary"></i>Laporan Kinerja Toko</h4>
                            <form method="get" action="${pageContext.request.contextPath}/report"
                                class="d-flex align-items-center">
                                <span class="me-2 text-muted">Periode:</span>
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

                    <% int totalOrders=0; int completedOrders=0; double totalRevenue=0; double avgOrderValue=0; try
                        (Connection conn=DatabaseConnection.getConnection()) { /* Removed employee_id filter to show
                        store performance */ String sqlT="SELECT COUNT(*) as total FROM orders o " + dateFilter;
                        PreparedStatement stmtT=conn.prepareStatement(sqlT); ResultSet rsT=stmtT.executeQuery(); if
                        (rsT.next()) totalOrders=rsT.getInt("total"); String
                        sqlC="SELECT COUNT(*) as total FROM orders o " + (dateFilter.isEmpty() ? "WHERE" : dateFilter
                        + " AND" ) + " status IN ('paid', 'done')" ; PreparedStatement
                        stmtC=conn.prepareStatement(sqlC); ResultSet rsC=stmtC.executeQuery(); if (rsC.next())
                        completedOrders=rsC.getInt("total"); String
                        sqlR="SELECT COALESCE(SUM(total_amount), 0) as revenue FROM orders o " + (dateFilter.isEmpty()
                        ? "WHERE" : dateFilter + " AND" ) + " status IN ('paid', 'done')" ; PreparedStatement
                        stmtR=conn.prepareStatement(sqlR); ResultSet rsR=stmtR.executeQuery(); if (rsR.next())
                        totalRevenue=rsR.getDouble("revenue"); if (completedOrders> 0) avgOrderValue = totalRevenue /
                        completedOrders;
                        } catch (Exception e) { e.printStackTrace(); }
                        %>

                        <div class="row g-4 mb-4">
                            <div class="col-md-3">
                                <div class="card text-white bg-primary stat-card h-100">
                                    <div class="card-body d-flex flex-column justify-content-center">
                                        <h6 class="card-title opacity-75">TOTAL PESANAN</h6>
                                        <h2 class="display-5 fw-bold">
                                            <%= totalOrders %>
                                        </h2>
                                        <i
                                            class="fas fa-shopping-basket position-absolute end-0 bottom-0 mb-3 me-3 opacity-25 fa-3x"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card text-white bg-success stat-card h-100">
                                    <div class="card-body d-flex flex-column justify-content-center">
                                        <h6 class="card-title opacity-75">PESANAN SELESAI</h6>
                                        <h2 class="display-5 fw-bold">
                                            <%= completedOrders %>
                                        </h2>
                                        <i
                                            class="fas fa-check-double position-absolute end-0 bottom-0 mb-3 me-3 opacity-25 fa-3x"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card text-white bg-info stat-card h-100">
                                    <div class="card-body d-flex flex-column justify-content-center">
                                        <h6 class="card-title opacity-75">PENDAPATAN</h6>
                                        <h3 class="fw-bold">Rp <%= String.format("%,.0f", totalRevenue) %>
                                        </h3>
                                        <i
                                            class="fas fa-wallet position-absolute end-0 bottom-0 mb-3 me-3 opacity-25 fa-3x"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card text-white bg-warning stat-card h-100">
                                    <div class="card-body d-flex flex-column justify-content-center">
                                        <h6 class="card-title opacity-75">RATA-RATA HARGA</h6>
                                        <h3 class="fw-bold">Rp <%= String.format("%,.0f", avgOrderValue) %>
                                        </h3>
                                        <i
                                            class="fas fa-chart-line position-absolute end-0 bottom-0 mb-3 me-3 opacity-25 fa-3x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row g-4">
                            <div class="col-md-6">
                                <div class="card shadow-sm h-100">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0 text-dark"><i
                                                class="fas fa-tasks me-2 text-primary"></i>Distribusi Status</h5>
                                    </div>
                                    <div class="card-body p-0">
                                        <table class="table table-hover mb-0">
                                            <thead class="table-light">
                                                <tr>
                                                    <th class="ps-3">Status</th>
                                                    <th class="text-end pe-3">Jumlah</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% try (Connection conn=DatabaseConnection.getConnection()) { String
                                                    sqlS="SELECT status, COUNT(*) as count FROM orders o " + dateFilter
                                                    + " GROUP BY status ORDER BY count DESC" ; PreparedStatement
                                                    stmtS=conn.prepareStatement(sqlS); ResultSet
                                                    rsS=stmtS.executeQuery(); while (rsS.next()) { String
                                                    st=rsS.getString("status"); int co=rsS.getInt("count"); String
                                                    badge="bg-secondary" ; if("paid".equals(st)) badge="bg-success" ;
                                                    else if("pending".equals(st)) badge="bg-warning text-dark" ; else
                                                    if("process".equals(st)) badge="bg-primary" ; %>
                                                    <tr>
                                                        <td class="ps-3"><span class="badge <%= badge %>">
                                                                <%= st.toUpperCase() %>
                                                            </span></td>
                                                        <td class="text-end pe-3"><strong>
                                                                <%= co %>
                                                            </strong></td>
                                                    </tr>
                                                    <% } } catch (Exception e) { e.printStackTrace(); } %>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="card shadow-sm h-100">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0 text-dark"><i
                                                class="fas fa-star me-2 text-warning"></i>Pelanggan Teratas</h5>
                                    </div>
                                    <div class="card-body p-0">
                                        <table class="table table-hover mb-0">
                                            <thead class="table-light">
                                                <tr>
                                                    <th class="ps-3">Nama Pelanggan</th>
                                                    <th class="text-end pe-3">Total Pesanan</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% try (Connection conn=DatabaseConnection.getConnection()) { String
                                                    sqlCust="SELECT c.name, COUNT(*) as cnt FROM orders o JOIN customers c ON o.customer_id = c.id "
                                                    + dateFilter + " GROUP BY c.id, c.name ORDER BY cnt DESC LIMIT 5" ;
                                                    PreparedStatement stmtCust=conn.prepareStatement(sqlCust); ResultSet
                                                    rsCust=stmtCust.executeQuery(); while (rsCust.next()) { %>
                                                    <tr>
                                                        <td class="ps-3"><i
                                                                class="fas fa-user-circle me-2 text-muted"></i>
                                                            <%= rsCust.getString("name") %>
                                                        </td>
                                                        <td class="text-end pe-3"><span
                                                                class="badge rounded-pill bg-primary">
                                                                <%= rsCust.getInt("cnt") %> Pesanan
                                                            </span></td>
                                                    </tr>
                                                    <% } } catch (Exception e) { e.printStackTrace(); } %>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4">
                            <div class="card shadow-sm">
                                <div class="card-header bg-white py-3">
                                    <h5 class="mb-0 text-dark"><i class="fas fa-receipt me-2 text-success"></i>Rincian
                                        Pesanan Terbaru</h5>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0 border-top">
                                            <thead class="table-light">
                                                <tr>
                                                    <th class="ps-3">ID</th>
                                                    <th>Pelanggan</th>
                                                    <th>Total Tagihan</th>
                                                    <th>Status</th>
                                                    <th class="pe-3">Waktu Transaksi</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% try (Connection conn=DatabaseConnection.getConnection()) { String
                                                    sqlDet="SELECT o.id, c.name, o.total_amount, o.status, o.created_at FROM orders o JOIN customers c ON o.customer_id = c.id "
                                                    + dateFilter + " ORDER BY o.created_at DESC LIMIT 50" ;
                                                    PreparedStatement stmtDet=conn.prepareStatement(sqlDet); ResultSet
                                                    rsDet=stmtDet.executeQuery(); while (rsDet.next()) { %>
                                                    <tr>
                                                        <td class="ps-3 fw-bold">#<%= rsDet.getInt("id") %>
                                                        </td>
                                                        <td>
                                                            <%= rsDet.getString("name") %>
                                                        </td>
                                                        <td>Rp <%= String.format("%,.0f",
                                                                rsDet.getDouble("total_amount")) %>
                                                        </td>
                                                        <td><span class="badge bg-light text-dark border">
                                                                <%= rsDet.getString("status") %>
                                                            </span></td>
                                                        <td class="pe-3 text-muted small">
                                                            <%= rsDet.getTimestamp("created_at") %>
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