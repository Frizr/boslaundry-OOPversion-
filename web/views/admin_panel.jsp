<%-- Document : admin_panel Created on : 29 Dec 2025 Author : BossLaundry Team Description: Admin Panel untuk manajemen
    user dan order --%>

    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ page import="java.util.*" %>
            <% Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
                    List<Map<String, Object>> userList = (List<Map<String, Object>>) request.getAttribute("userList");
                            List<Map<String, Object>> orderList = (List<Map<String, Object>>)
                                    request.getAttribute("orderList");

                                    if (stats == null) stats = new HashMap<>();
                                        if (userList == null) userList = new ArrayList<>();
                                            if (orderList == null) orderList = new ArrayList<>();
                                                %>
                                                <!DOCTYPE html>
                                                <html lang="id">

                                                <head>
                                                    <meta charset="UTF-8">
                                                    <meta name="viewport"
                                                        content="width=device-width, initial-scale=1.0">
                                                    <title>Admin Panel - PoS Laundry</title>
                                                    <link
                                                        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                                        rel="stylesheet">
                                                    <link rel="stylesheet"
                                                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                                                    <style>
                                                        :root {
                                                            --primary-gradient: linear-gradient(135deg, #667eea, #764ba2);
                                                            --sidebar-bg: #343a40;
                                                            --sidebar-hover: #495057;
                                                            --card-shadow: 0 8px 32px rgba(102, 126, 234, 0.15);
                                                        }

                                                        body {
                                                            background: #f8f9fa;
                                                        }

                                                        /* Sidebar Styling */
                                                        .sidebar {
                                                            height: 100vh;
                                                            position: fixed;
                                                            top: 0;
                                                            left: 0;
                                                            width: 250px;
                                                            background: #343a40;
                                                            color: white;
                                                            padding-top: 20px;
                                                        }

                                                        .nav-link {
                                                            color: #adb5bd;
                                                        }

                                                        .nav-link:hover {
                                                            color: white;
                                                        }

                                                        .nav-link.active {
                                                            color: white;
                                                            background: #495057;
                                                        }

                                                        /* Content Area */
                                                        .content {
                                                            margin-left: 250px;
                                                            padding: 20px;
                                                            min-height: 100vh;
                                                        }

                                                        /* Top Navbar */
                                                        .top-navbar {
                                                            background: white;
                                                            border-radius: 15px;
                                                            padding: 20px 25px;
                                                            margin-bottom: 30px;
                                                            box-shadow: var(--card-shadow);
                                                        }

                                                        .page-title {
                                                            font-weight: 700;
                                                            color: #1a1d29;
                                                            margin: 0;
                                                        }

                                                        .page-title i {
                                                            background: var(--primary-gradient);
                                                            -webkit-background-clip: text;
                                                            -webkit-text-fill-color: transparent;
                                                            background-clip: text;
                                                        }

                                                        /* Cards */
                                                        .custom-card {
                                                            background: white;
                                                            border-radius: 15px;
                                                            box-shadow: var(--card-shadow);
                                                            border: none;
                                                            overflow: hidden;
                                                            transition: transform 0.3s ease, box-shadow 0.3s ease;
                                                        }

                                                        .custom-card:hover {
                                                            transform: translateY(-5px);
                                                            box-shadow: 0 12px 40px rgba(102, 126, 234, 0.2);
                                                        }

                                                        .card-header-custom {
                                                            background: var(--primary-gradient);
                                                            color: white;
                                                            padding: 18px 25px;
                                                            font-weight: 600;
                                                            font-size: 1.1rem;
                                                        }

                                                        .card-body {
                                                            padding: 25px;
                                                        }

                                                        /* Tabs */
                                                        .nav-tabs-custom {
                                                            border: none;
                                                            background: white;
                                                            border-radius: 15px;
                                                            padding: 8px;
                                                            box-shadow: var(--card-shadow);
                                                            margin-bottom: 25px;
                                                        }

                                                        .nav-tabs-custom .nav-link {
                                                            border: none;
                                                            color: #6c757d;
                                                            font-weight: 500;
                                                            padding: 12px 25px;
                                                            border-radius: 10px;
                                                            margin: 0 5px;
                                                            transition: all 0.3s ease;
                                                        }

                                                        .nav-tabs-custom .nav-link:hover {
                                                            background: #f0f2f5;
                                                            color: #667eea;
                                                        }

                                                        .nav-tabs-custom .nav-link.active {
                                                            background: var(--primary-gradient);
                                                            color: white;
                                                        }

                                                        /* Table Styling */
                                                        .table-custom {
                                                            margin: 0;
                                                        }

                                                        .table-custom thead {
                                                            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
                                                        }

                                                        .table-custom thead th {
                                                            border: none;
                                                            padding: 15px;
                                                            font-weight: 600;
                                                            color: #495057;
                                                            text-transform: uppercase;
                                                            font-size: 0.75rem;
                                                            letter-spacing: 0.5px;
                                                        }

                                                        .table-custom tbody td {
                                                            padding: 15px;
                                                            vertical-align: middle;
                                                            border-color: #f0f2f5;
                                                        }

                                                        .table-custom tbody tr {
                                                            transition: background 0.2s ease;
                                                        }

                                                        .table-custom tbody tr:hover {
                                                            background: #f8f9fa;
                                                        }

                                                        /* Badges */
                                                        .badge-role {
                                                            padding: 6px 14px;
                                                            border-radius: 20px;
                                                            font-weight: 500;
                                                            font-size: 0.8rem;
                                                        }

                                                        .badge-admin {
                                                            background: linear-gradient(135deg, #f093fb, #f5576c);
                                                            color: white;
                                                        }

                                                        .badge-karyawan {
                                                            background: linear-gradient(135deg, #4facfe, #00f2fe);
                                                            color: white;
                                                        }

                                                        .badge-status {
                                                            padding: 6px 14px;
                                                            border-radius: 20px;
                                                            font-weight: 500;
                                                            font-size: 0.8rem;
                                                        }

                                                        .badge-pending {
                                                            background: linear-gradient(135deg, #ffecd2, #fcb69f);
                                                            color: #8b5a2b;
                                                        }

                                                        .badge-process {
                                                            background: linear-gradient(135deg, #a1c4fd, #c2e9fb);
                                                            color: #2c5282;
                                                        }

                                                        .badge-done {
                                                            background: linear-gradient(135deg, #d4fc79, #96e6a1);
                                                            color: #276749;
                                                        }

                                                        .badge-paid {
                                                            background: linear-gradient(135deg, #667eea, #764ba2);
                                                            color: white;
                                                        }

                                                        /* Buttons */
                                                        .btn-action {
                                                            padding: 6px 12px;
                                                            border-radius: 8px;
                                                            font-size: 0.85rem;
                                                            transition: all 0.3s ease;
                                                        }

                                                        .btn-edit {
                                                            background: linear-gradient(135deg, #ffecd2, #fcb69f);
                                                            border: none;
                                                            color: #8b5a2b;
                                                        }

                                                        .btn-edit:hover {
                                                            background: linear-gradient(135deg, #fcb69f, #ffecd2);
                                                            transform: scale(1.05);
                                                        }

                                                        .btn-delete {
                                                            background: linear-gradient(135deg, #ff9a9e, #fecfef);
                                                            border: none;
                                                            color: #c53030;
                                                        }

                                                        .btn-delete:hover {
                                                            background: linear-gradient(135deg, #fecfef, #ff9a9e);
                                                            transform: scale(1.05);
                                                        }

                                                        .btn-status {
                                                            background: linear-gradient(135deg, #a1c4fd, #c2e9fb);
                                                            border: none;
                                                            color: #2c5282;
                                                        }

                                                        .btn-status:hover {
                                                            background: linear-gradient(135deg, #c2e9fb, #a1c4fd);
                                                            transform: scale(1.05);
                                                        }

                                                        /* Search & Filter */
                                                        .search-box {
                                                            background: white;
                                                            border-radius: 15px;
                                                            padding: 20px;
                                                            box-shadow: var(--card-shadow);
                                                            margin-bottom: 25px;
                                                        }

                                                        .search-input {
                                                            border: 2px solid #e9ecef;
                                                            border-radius: 10px;
                                                            padding: 12px 20px;
                                                            transition: all 0.3s ease;
                                                        }

                                                        .search-input:focus {
                                                            border-color: #667eea;
                                                            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                                                        }

                                                        .filter-select {
                                                            border: 2px solid #e9ecef;
                                                            border-radius: 10px;
                                                            padding: 12px 20px;
                                                            cursor: pointer;
                                                        }

                                                        .filter-select:focus {
                                                            border-color: #667eea;
                                                            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                                                        }

                                                        .btn-search {
                                                            background: var(--primary-gradient);
                                                            border: none;
                                                            padding: 12px 25px;
                                                            border-radius: 10px;
                                                            color: white;
                                                            font-weight: 500;
                                                            transition: all 0.3s ease;
                                                        }

                                                        .btn-search:hover {
                                                            transform: translateY(-2px);
                                                            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
                                                            color: white;
                                                        }

                                                        /* Modal Styling */
                                                        .modal-content {
                                                            border: none;
                                                            border-radius: 20px;
                                                            overflow: hidden;
                                                        }

                                                        .modal-header-custom {
                                                            background: var(--primary-gradient);
                                                            color: white;
                                                            padding: 20px 25px;
                                                            border: none;
                                                        }

                                                        .modal-body {
                                                            padding: 30px;
                                                        }

                                                        .form-label-custom {
                                                            font-weight: 600;
                                                            color: #495057;
                                                            margin-bottom: 8px;
                                                        }

                                                        .form-control-custom {
                                                            border: 2px solid #e9ecef;
                                                            border-radius: 10px;
                                                            padding: 12px 15px;
                                                            transition: all 0.3s ease;
                                                        }

                                                        .form-control-custom:focus {
                                                            border-color: #667eea;
                                                            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                                                        }

                                                        .btn-save {
                                                            background: var(--primary-gradient);
                                                            border: none;
                                                            padding: 12px 30px;
                                                            border-radius: 10px;
                                                            color: white;
                                                            font-weight: 600;
                                                            transition: all 0.3s ease;
                                                        }

                                                        .btn-save:hover {
                                                            transform: translateY(-2px);
                                                            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
                                                            color: white;
                                                        }

                                                        .btn-cancel {
                                                            background: #e9ecef;
                                                            border: none;
                                                            padding: 12px 30px;
                                                            border-radius: 10px;
                                                            color: #495057;
                                                            font-weight: 600;
                                                            transition: all 0.3s ease;
                                                        }

                                                        .btn-cancel:hover {
                                                            background: #dee2e6;
                                                        }

                                                        /* User Avatar */
                                                        .user-avatar {
                                                            width: 40px;
                                                            height: 40px;
                                                            border-radius: 50%;
                                                            background: var(--primary-gradient);
                                                            display: flex;
                                                            align-items: center;
                                                            justify-content: center;
                                                            color: white;
                                                            font-weight: 600;
                                                            font-size: 0.9rem;
                                                        }

                                                        /* Stats Mini Cards */
                                                        .stats-mini {
                                                            background: white;
                                                            border-radius: 12px;
                                                            padding: 20px;
                                                            box-shadow: var(--card-shadow);
                                                            text-align: center;
                                                        }

                                                        .stats-mini-icon {
                                                            width: 50px;
                                                            height: 50px;
                                                            border-radius: 12px;
                                                            display: flex;
                                                            align-items: center;
                                                            justify-content: center;
                                                            margin: 0 auto 15px;
                                                            font-size: 1.5rem;
                                                        }

                                                        .stats-mini-icon.users {
                                                            background: linear-gradient(135deg, #f093fb, #f5576c);
                                                            color: white;
                                                        }

                                                        .stats-mini-icon.orders {
                                                            background: linear-gradient(135deg, #4facfe, #00f2fe);
                                                            color: white;
                                                        }

                                                        .stats-mini-icon.pending {
                                                            background: linear-gradient(135deg, #ffecd2, #fcb69f);
                                                            color: #8b5a2b;
                                                        }

                                                        .stats-mini-icon.paid {
                                                            background: linear-gradient(135deg, #667eea, #764ba2);
                                                            color: white;
                                                        }

                                                        .stats-value {
                                                            font-size: 1.8rem;
                                                            font-weight: 700;
                                                            color: #1a1d29;
                                                        }

                                                        .stats-label {
                                                            color: #6c757d;
                                                            font-size: 0.85rem;
                                                        }

                                                        /* Empty State */
                                                        .empty-state {
                                                            text-align: center;
                                                            padding: 60px 20px;
                                                            color: #6c757d;
                                                        }

                                                        .empty-state i {
                                                            font-size: 4rem;
                                                            margin-bottom: 20px;
                                                            opacity: 0.3;
                                                        }

                                                        /* Responsive */
                                                        @media (max-width: 768px) {
                                                            .sidebar {
                                                                width: 100%;
                                                                height: auto;
                                                                position: relative;
                                                            }

                                                            .content {
                                                                margin-left: 0;
                                                            }
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
                                                                <li class="nav-item"><a
                                                                        href="${pageContext.request.contextPath}/login"
                                                                        class="nav-link"><i
                                                                            class="fas fa-home me-2"></i>Dashboard</a>
                                                                </li>
                                                                <li class="nav-item"><a
                                                                        href="${pageContext.request.contextPath}/services"
                                                                        class="nav-link"><i
                                                                            class="fas fa-list me-2"></i>Layanan</a>
                                                                </li>
                                                                <% } %>
                                                                    <li class="nav-item"><a
                                                                            href="${pageContext.request.contextPath}/orders"
                                                                            class="nav-link"><i
                                                                                class="fas fa-shopping-cart me-2"></i>Pesanan</a>
                                                                    </li>
                                                                    <% if("admin".equals(session.getAttribute("role")))
                                                                        { %>
                                                                        <li class="nav-item"><a
                                                                                href="${pageContext.request.contextPath}/admin-panel"
                                                                                class="nav-link active"><i
                                                                                    class="fas fa-user-shield me-2"></i>Admin
                                                                                Panel</a></li>
                                                                        <% } %>
                                                                            <li class="nav-item"><a
                                                                                    href="${pageContext.request.contextPath}/logout"
                                                                                    class="nav-link text-danger"><i
                                                                                        class="fas fa-sign-out-alt me-2"></i>Logout</a>
                                                                            </li>
                                                        </ul>
                                                    </div>

                                                    <!-- Content -->
                                                    <div class="content">
                                                        <!-- Top Navbar -->
                                                        <div
                                                            class="top-navbar d-flex justify-content-between align-items-center">
                                                            <h4 class="page-title"><i
                                                                    class="fas fa-user-shield me-2"></i>Admin Panel</h4>
                                                            <div class="d-flex align-items-center">
                                                                <span class="me-3">Halo, <strong>
                                                                        <%= session.getAttribute("username") !=null ?
                                                                            session.getAttribute("username") : "Admin"
                                                                            %>
                                                                    </strong>!</span>
                                                                <div class="user-avatar">
                                                                    <%= session.getAttribute("username") !=null ?
                                                                        session.getAttribute("username").toString().substring(0,
                                                                        1).toUpperCase() : "A" %>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Stats Mini Cards -->
                                                        <div class="row g-4 mb-4">
                                                            <div class="col-md-3">
                                                                <div class="stats-mini">
                                                                    <div class="stats-mini-icon users">
                                                                        <i class="fas fa-users"></i>
                                                                    </div>
                                                                    <div class="stats-value">
                                                                        <%= stats.getOrDefault("totalUsers", 0) %>
                                                                    </div>
                                                                    <div class="stats-label">Total Users</div>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-3">
                                                                <div class="stats-mini">
                                                                    <div class="stats-mini-icon orders">
                                                                        <i class="fas fa-shopping-bag"></i>
                                                                    </div>
                                                                    <div class="stats-value">
                                                                        <%= stats.getOrDefault("totalOrders", 0) %>
                                                                    </div>
                                                                    <div class="stats-label">Total Orders</div>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-3">
                                                                <div class="stats-mini">
                                                                    <div class="stats-mini-icon pending">
                                                                        <i class="fas fa-clock"></i>
                                                                    </div>
                                                                    <div class="stats-value">
                                                                        <%= stats.getOrDefault("pendingOrders", 0) %>
                                                                    </div>
                                                                    <div class="stats-label">Pending Orders</div>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-3">
                                                                <div class="stats-mini">
                                                                    <div class="stats-mini-icon paid">
                                                                        <i class="fas fa-check-circle"></i>
                                                                    </div>
                                                                    <div class="stats-value">
                                                                        <%= stats.getOrDefault("completedOrders", 0) %>
                                                                    </div>
                                                                    <div class="stats-label">Completed Orders</div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Tabs Navigation -->
                                                        <ul class="nav nav-tabs-custom" id="adminTabs" role="tablist">
                                                            <li class="nav-item" role="presentation">
                                                                <button class="nav-link active" id="users-tab"
                                                                    data-bs-toggle="tab" data-bs-target="#users"
                                                                    type="button" role="tab">
                                                                    <i class="fas fa-users me-2"></i>Manajemen User
                                                                </button>
                                                            </li>
                                                            <li class="nav-item" role="presentation">
                                                                <button class="nav-link" id="orders-tab"
                                                                    data-bs-toggle="tab" data-bs-target="#orders"
                                                                    type="button" role="tab">
                                                                    <i class="fas fa-shopping-cart me-2"></i>Manajemen
                                                                    Order
                                                                </button>
                                                            </li>
                                                        </ul>

                                                        <!-- Tab Content -->
                                                        <div class="tab-content">
                                                            <!-- Users Tab -->
                                                            <div class="tab-pane fade show active" id="users"
                                                                role="tabpanel">
                                                                <!-- Search Box -->
                                                                <div class="search-box">
                                                                    <div class="row g-3">
                                                                        <div class="col-md-7">
                                                                            <input type="text"
                                                                                class="form-control search-input"
                                                                                id="searchUser"
                                                                                placeholder="Cari username...">
                                                                        </div>
                                                                        <div class="col-md-3">
                                                                            <select class="form-select filter-select"
                                                                                id="filterRole">
                                                                                <option value="">Semua Role</option>
                                                                                <option value="admin">Admin</option>
                                                                                <option value="karyawan">Karyawan
                                                                                </option>
                                                                            </select>
                                                                        </div>

                                                                        <div class="col-md-2">
                                                                            <button
                                                                                class="btn btn-outline-secondary w-100"
                                                                                onclick="resetFilter()">
                                                                                <i class="fas fa-redo me-1"></i>Reset
                                                                            </button>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <!-- Users Table -->
                                                                <div class="custom-card">
                                                                    <div class="card-header-custom">
                                                                        <i class="fas fa-users me-2"></i>Daftar User &
                                                                        Role
                                                                    </div>
                                                                    <div class="card-body p-0">
                                                                        <div class="table-responsive">
                                                                            <table class="table table-custom mb-0">
                                                                                <thead>
                                                                                    <tr>
                                                                                        <th>ID</th>
                                                                                        <th>Username</th>
                                                                                        <th>Role</th>
                                                                                        <th>Tanggal Dibuat</th>
                                                                                        <th>Jumlah Order</th>
                                                                                        <th>Aksi</th>
                                                                                    </tr>
                                                                                </thead>
                                                                                <tbody id="userTableBody">
                                                                                    <% for(Map<String, Object> u :
                                                                                        userList) {
                                                                                        String uId =
                                                                                        String.valueOf(u.get("id"));
                                                                                        String uUsername =
                                                                                        (String)u.get("username");
                                                                                        String uRole =
                                                                                        (String)u.get("role");
                                                                                        %>
                                                                                        <tr class="user-row"
                                                                                            data-username="<%= uUsername.toLowerCase() %>"
                                                                                            data-role="<%= uRole.toLowerCase() %>">
                                                                                            <td><strong>#<%= uId %>
                                                                                                </strong></td>
                                                                                            <td>
                                                                                                <div
                                                                                                    class="d-flex align-items-center">
                                                                                                    <div
                                                                                                        class="user-avatar me-2">
                                                                                                        <%= uUsername.substring(0,1).toUpperCase()
                                                                                                            %>
                                                                                                    </div>
                                                                                                    <%= uUsername %>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td>
                                                                                                <span
                                                                                                    class="badge-role badge-<%= uRole %>">
                                                                                                    <%= uRole.substring(0,1).toUpperCase()
                                                                                                        +
                                                                                                        uRole.substring(1)
                                                                                                        %>
                                                                                                </span>
                                                                                            </td>
                                                                                            <td>-</td>
                                                                                            <td><span
                                                                                                    class="badge bg-secondary">
                                                                                                    <%= u.get("orderCount")
                                                                                                        %> orders
                                                                                                </span></td>
                                                                                            <td>
                                                                                                <button
                                                                                                    class="btn btn-action btn-status"
                                                                                                    data-bs-toggle="modal"
                                                                                                    data-bs-target="#changeRoleModal"
                                                                                                    onclick="setRoleData('<%= uId %>', '<%= uUsername %>', '<%= uRole %>')">
                                                                                                    <i
                                                                                                        class="fas fa-exchange-alt"></i>
                                                                                                    Ganti Role
                                                                                                </button>
                                                                                                <button
                                                                                                    class="btn btn-action btn-danger ms-1"
                                                                                                    data-bs-toggle="modal"
                                                                                                    data-bs-target="#resetPasswordModal"
                                                                                                    onclick="setResetPasswordData('<%= uId %>', '<%= uUsername %>')">
                                                                                                    <i
                                                                                                        class="fas fa-key"></i>
                                                                                                </button>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <% } %>
                                                                                </tbody>
                                                                            </table>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <!-- Orders Tab -->
                                                            <div class="tab-pane fade" id="orders" role="tabpanel">
                                                                <!-- Search & Filter Box -->
                                                                <div class="search-box">
                                                                    <div class="row g-3">
                                                                        <div class="col-md-4">
                                                                            <input type="text"
                                                                                class="form-control search-input"
                                                                                id="searchOrder"
                                                                                placeholder="Cari ID atau pelanggan...">
                                                                        </div>
                                                                        <div class="col-md-3">
                                                                            <select class="form-select filter-select"
                                                                                id="filterStatus">
                                                                                <option value="">Semua Status</option>
                                                                                <option value="pending">Pending</option>
                                                                                <option value="process">Proses</option>
                                                                                <option value="done">Selesai</option>
                                                                                <option value="paid">Dibayar</option>
                                                                            </select>
                                                                        </div>
                                                                        <div class="col-md-3">
                                                                            <input type="date"
                                                                                class="form-control filter-select"
                                                                                id="filterDate">
                                                                        </div>

                                                                        <div class="col-md-2">
                                                                            <button
                                                                                class="btn btn-outline-secondary w-100"
                                                                                onclick="resetOrderFilter()">
                                                                                <i class="fas fa-redo me-1"></i>Reset
                                                                            </button>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <!-- Orders Table -->
                                                                <div class="custom-card">
                                                                    <div
                                                                        class="card-header-custom d-flex justify-content-between align-items-center">
                                                                        <span><i
                                                                                class="fas fa-shopping-cart me-2"></i>Daftar
                                                                            Pesanan</span>
                                                                        <span class="badge bg-light text-dark">Total:
                                                                            <%= stats.getOrDefault("totalOrders", 0) %>
                                                                                pesanan
                                                                        </span>
                                                                    </div>
                                                                    <div class="card-body p-0">
                                                                        <div class="table-responsive">
                                                                            <table class="table table-custom mb-0">
                                                                                <thead>
                                                                                    <tr>
                                                                                        <th>ID</th>
                                                                                        <th>Pelanggan</th>
                                                                                        <th>Dibuat Oleh</th>
                                                                                        <th>Total</th>
                                                                                        <th>Status</th>
                                                                                        <th>Tanggal</th>
                                                                                        <th>Aksi</th>
                                                                                    </tr>
                                                                                </thead>
                                                                                <tbody>
                                                                                    <% for(Map<String, Object> o :
                                                                                        orderList) {

                                                                                        String oId =
                                                                                        String.valueOf(o.get("id"));
                                                                                        String oStatus =
                                                                                        (String)o.get("status");
                                                                                        String statusClass =
                                                                                        "badge-pending";
                                                                                        if("process".equals(oStatus))
                                                                                        statusClass = "badge-process";
                                                                                        else if("done".equals(oStatus))
                                                                                        statusClass = "badge-done";
                                                                                        else if("paid".equals(oStatus))
                                                                                        statusClass = "badge-paid";

                                                                                        String dataCustomer = "";
                                                                                        if(o.get("customerName") !=
                                                                                        null) {
                                                                                        dataCustomer =
                                                                                        o.get("customerName").toString().toLowerCase();
                                                                                        }

                                                                                        String dataDate = "";
                                                                                        if(o.get("date") != null) {
                                                                                        dataDate =
                                                                                        o.get("date").toString();
                                                                                        }
                                                                                        %>
                                                                                        <tr class="order-row"
                                                                                            data-id="<%= oId %>"
                                                                                            data-customer="<%= dataCustomer %>"
                                                                                            data-status="<%= oStatus %>"
                                                                                            data-date="<%= dataDate %>">
                                                                                            <td><strong>#<%= oId %>
                                                                                                </strong></td>
                                                                                            <td>
                                                                                                <div>
                                                                                                    <strong>
                                                                                                        <%= o.get("customerName")
                                                                                                            %>
                                                                                                    </strong>
                                                                                                    <br><small
                                                                                                        class="text-muted">
                                                                                                        <%= o.get("customerPhone")
                                                                                                            %>
                                                                                                    </small>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td>
                                                                                                <div
                                                                                                    class="d-flex align-items-center">
                                                                                                    <div class="user-avatar me-2"
                                                                                                        style="width:30px;height:30px;font-size:0.75rem;">
                                                                                                        <%= o.get("employeeName")
                                                                                                            !=null ?
                                                                                                            o.get("employeeName").toString().substring(0,1).toUpperCase()
                                                                                                            : "?" %>
                                                                                                    </div>
                                                                                                    <%= o.get("employeeName")
                                                                                                        %>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td><strong>Rp <%=
                                                                                                        String.format("%,.0f",
                                                                                                        (Double)o.get("totalAmount"))
                                                                                                        %>
                                                                                                </strong>
                                                                                            </td>
                                                                                            <td><span
                                                                                                    class="badge-status <%= statusClass %>">
                                                                                                    <%= oStatus.substring(0,1).toUpperCase()
                                                                                                        +
                                                                                                        oStatus.substring(1)
                                                                                                        %>
                                                                                                </span></td>
                                                                                            <td>
                                                                                                <%= o.get("date") %>
                                                                                            </td>
                                                                                            <td>
                                                                                                <div class="btn-group">
                                                                                                    <button
                                                                                                        class="btn btn-action btn-status"
                                                                                                        data-bs-toggle="modal"
                                                                                                        data-bs-target="#changeStatusModal"
                                                                                                        onclick="setStatusData('<%= oId %>', '<%= oStatus %>')">
                                                                                                        <i
                                                                                                            class="fas fa-sync-alt"></i>
                                                                                                    </button>
                                                                                                    <button
                                                                                                        class="btn btn-action btn-delete"
                                                                                                        data-bs-toggle="modal"
                                                                                                        data-bs-target="#deleteOrderModal"
                                                                                                        onclick="setDeleteData('<%= oId %>')">
                                                                                                        <i
                                                                                                            class="fas fa-trash"></i>
                                                                                                    </button>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <% } %>
                                                                                </tbody>
                                                                            </table>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Change Role Modal -->
                                                    <div class="modal fade" id="changeRoleModal" tabindex="-1">
                                                        <div class="modal-dialog modal-dialog-centered">
                                                            <div class="modal-content">
                                                                <div class="modal-header modal-header-custom">
                                                                    <h5 class="modal-title"><i
                                                                            class="fas fa-user-cog me-2"></i>Ganti Role
                                                                        User</h5>
                                                                    <button type="button"
                                                                        class="btn-close btn-close-white"
                                                                        data-bs-dismiss="modal"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <form id="changeRoleForm"
                                                                        action="${pageContext.request.contextPath}/admin-panel"
                                                                        method="POST">
                                                                        <input type="hidden" name="action"
                                                                            value="changeRole">
                                                                        <input type="hidden" id="roleUserId"
                                                                            name="userId">
                                                                        <div class="mb-4">
                                                                            <label
                                                                                class="form-label-custom">Username</label>
                                                                            <input type="text"
                                                                                class="form-control form-control-custom"
                                                                                id="roleUsername" readonly>
                                                                        </div>
                                                                        <div class="mb-4">
                                                                            <label class="form-label-custom">Role
                                                                                Baru</label>
                                                                            <select
                                                                                class="form-select form-control-custom"
                                                                                id="newRole" name="role">
                                                                                <option value="admin">Admin</option>
                                                                                <option value="karyawan">Karyawan
                                                                                </option>
                                                                            </select>
                                                                        </div>
                                                                        <div class="d-flex justify-content-end gap-2">
                                                                            <button type="button" class="btn btn-cancel"
                                                                                data-bs-dismiss="modal">Batal</button>
                                                                            <button type="submit" class="btn btn-save">
                                                                                <i class="fas fa-save me-1"></i>Simpan
                                                                                Perubahan
                                                                            </button>
                                                                        </div>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Reset Password Modal -->
                                                    <div class="modal fade" id="resetPasswordModal" tabindex="-1">
                                                        <div class="modal-dialog modal-dialog-centered">
                                                            <div class="modal-content">
                                                                <div
                                                                    class="modal-header modal-header-custom bg-danger text-white">
                                                                    <h5 class="modal-title"><i
                                                                            class="fas fa-key me-2"></i>Reset Password
                                                                    </h5>
                                                                    <button type="button"
                                                                        class="btn-close btn-close-white"
                                                                        data-bs-dismiss="modal"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <form id="resetPasswordForm"
                                                                        action="${pageContext.request.contextPath}/admin-panel"
                                                                        method="POST">
                                                                        <input type="hidden" name="action"
                                                                            value="resetPassword">
                                                                        <input type="hidden" id="resetUserId"
                                                                            name="userId">

                                                                        <div class="mb-4">
                                                                            <label
                                                                                class="form-label-custom">Username</label>
                                                                            <input type="text"
                                                                                class="form-control form-control-custom"
                                                                                id="resetUsername" readonly>
                                                                        </div>

                                                                        <div class="mb-4">
                                                                            <label class="form-label-custom">Password
                                                                                Baru</label>
                                                                            <input type="text"
                                                                                class="form-control form-control-custom"
                                                                                name="password" required
                                                                                placeholder="Masukkan password baru">
                                                                            <small class="text-muted">Masukkan password
                                                                                baru untuk user ini.</small>
                                                                        </div>

                                                                        <div class="d-flex justify-content-end gap-2">
                                                                            <button type="button" class="btn btn-cancel"
                                                                                data-bs-dismiss="modal">Batal</button>
                                                                            <button type="submit"
                                                                                class="btn btn-danger">
                                                                                <i class="fas fa-save me-1"></i>Simpan
                                                                                Password
                                                                            </button>
                                                                        </div>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Change Status Modal -->
                                                    <div class="modal fade" id="changeStatusModal" tabindex="-1">
                                                        <div class="modal-dialog modal-dialog-centered">
                                                            <div class="modal-content">
                                                                <div class="modal-header modal-header-custom">
                                                                    <h5 class="modal-title"><i
                                                                            class="fas fa-sync-alt me-2"></i>Ganti
                                                                        Status Order</h5>
                                                                    <button type="button"
                                                                        class="btn-close btn-close-white"
                                                                        data-bs-dismiss="modal"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <form id="changeStatusForm"
                                                                        action="${pageContext.request.contextPath}/admin-panel"
                                                                        method="POST">
                                                                        <input type="hidden" name="action"
                                                                            value="changeStatus">
                                                                        <input type="hidden" id="statusOrderId"
                                                                            name="orderId">
                                                                        <div class="mb-4">
                                                                            <label class="form-label-custom">Order
                                                                                ID</label>
                                                                            <input type="text"
                                                                                class="form-control form-control-custom"
                                                                                id="displayOrderId" readonly>
                                                                        </div>
                                                                        <div class="mb-4">
                                                                            <label class="form-label-custom">Status Saat
                                                                                Ini</label>
                                                                            <input type="text"
                                                                                class="form-control form-control-custom"
                                                                                id="currentStatus" readonly>
                                                                        </div>
                                                                        <div class="mb-4">
                                                                            <label class="form-label-custom">Status
                                                                                Baru</label>
                                                                            <select
                                                                                class="form-select form-control-custom"
                                                                                id="newStatus" name="status">
                                                                                <option value="pending">Pending</option>
                                                                                <option value="process">Proses</option>
                                                                                <option value="done">Selesai</option>
                                                                                <option value="paid">Dibayar</option>
                                                                            </select>
                                                                        </div>
                                                                        <div class="d-flex justify-content-end gap-2">
                                                                            <button type="button" class="btn btn-cancel"
                                                                                data-bs-dismiss="modal">Batal</button>
                                                                            <button type="submit" class="btn btn-save">
                                                                                <i class="fas fa-save me-1"></i>Update
                                                                                Status
                                                                            </button>
                                                                        </div>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Delete Order Modal -->
                                                    <div class="modal fade" id="deleteOrderModal" tabindex="-1">
                                                        <div class="modal-dialog modal-dialog-centered">
                                                            <div class="modal-content">
                                                                <div class="modal-header"
                                                                    style="background: linear-gradient(135deg, #ff9a9e, #fecfef); border: none;">
                                                                    <h5 class="modal-title text-danger"><i
                                                                            class="fas fa-exclamation-triangle me-2"></i>Hapus
                                                                        Order</h5>
                                                                    <button type="button" class="btn-close"
                                                                        data-bs-dismiss="modal"></button>
                                                                </div>
                                                                <div class="modal-body text-center py-4">
                                                                    <form id="deleteOrderForm"
                                                                        action="${pageContext.request.contextPath}/admin-panel"
                                                                        method="POST">
                                                                        <input type="hidden" name="action"
                                                                            value="deleteOrder">
                                                                        <input type="hidden" id="deleteOrderId"
                                                                            name="orderId">
                                                                        <i
                                                                            class="fas fa-trash-alt fa-3x text-danger mb-3"></i>
                                                                        <h5>Apakah Anda yakin?</h5>
                                                                        <p class="text-muted mb-0">Order <strong
                                                                                id="deleteOrderDisplay">#1001</strong>
                                                                            akan dihapus permanen.</p>
                                                                        <p class="text-muted small">Tindakan ini tidak
                                                                            dapat dibatalkan.</p>

                                                                        <div
                                                                            class="d-flex justify-content-center mt-4 gap-2">
                                                                            <button type="button" class="btn btn-cancel"
                                                                                data-bs-dismiss="modal">
                                                                                <i class="fas fa-times me-1"></i>Batal
                                                                            </button>
                                                                            <button type="submit"
                                                                                class="btn btn-danger">
                                                                                <i class="fas fa-trash me-1"></i>Ya,
                                                                                Hapus
                                                                            </button>
                                                                        </div>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <script
                                                        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                                    <script>
                                                        // Set Role Data for Modal
                                                        function setRoleData(userId, username, currentRole) {
                                                            document.getElementById('roleUserId').value = userId;
                                                            document.getElementById('roleUsername').value = username;
                                                            document.getElementById('newRole').value = currentRole;
                                                        }

                                                        // Set Reset Password Data
                                                        function setResetPasswordData(userId, username) {
                                                            document.getElementById('resetUserId').value = userId;
                                                            document.getElementById('resetUsername').value = username;
                                                        }

                                                        // Set Status Data for Modal
                                                        function setStatusData(orderId, currentStatus) {
                                                            document.getElementById('statusOrderId').value = orderId;
                                                            document.getElementById('displayOrderId').value = '#' + orderId;
                                                            document.getElementById('currentStatus').value = currentStatus.charAt(0).toUpperCase() + currentStatus.slice(1);
                                                            document.getElementById('newStatus').value = currentStatus;
                                                        }

                                                        // Set Delete Data for Modal
                                                        function setDeleteData(orderId) {
                                                            document.getElementById('deleteOrderId').value = orderId;
                                                            document.getElementById('deleteOrderDisplay').textContent = '#' + orderId;
                                                        }

                                                        // Reset Filter
                                                        function resetFilter() {
                                                            document.getElementById('searchUser').value = '';
                                                            document.getElementById('filterRole').value = '';
                                                            filterUsers();
                                                        }

                                                        // --- FILTERING LOGIC ---

                                                        function filterUsers() {
                                                            const searchQuery = document.getElementById('searchUser').value.toLowerCase();
                                                            const roleFilter = document.getElementById('filterRole').value.toLowerCase();
                                                            const rows = document.querySelectorAll('.user-row');

                                                            rows.forEach(row => {
                                                                const username = row.getAttribute('data-username');
                                                                const role = row.getAttribute('data-role');

                                                                const matchesSearch = username.includes(searchQuery);
                                                                const matchesRole = roleFilter === '' || role === roleFilter;

                                                                row.style.display = (matchesSearch && matchesRole) ? '' : 'none';
                                                            });
                                                        }

                                                        function filterOrders() {
                                                            const searchQuery = document.getElementById('searchOrder').value.toLowerCase();
                                                            const statusFilter = document.getElementById('filterStatus').value.toLowerCase();
                                                            const dateFilter = document.getElementById('filterDate').value;
                                                            const rows = document.querySelectorAll('.order-row');

                                                            rows.forEach(row => {
                                                                const orderId = row.getAttribute('data-id');
                                                                const customer = row.getAttribute('data-customer');
                                                                const status = row.getAttribute('data-status');
                                                                const date = row.getAttribute('data-date');

                                                                const matchesSearch = orderId.includes(searchQuery) || customer.includes(searchQuery);
                                                                const matchesStatus = statusFilter === '' || status === statusFilter;
                                                                const matchesDate = dateFilter === '' || date.startsWith(dateFilter);

                                                                row.style.display = (matchesSearch && matchesStatus && matchesDate) ? '' : 'none';
                                                            });
                                                        }

                                                        function resetOrderFilter() {
                                                            document.getElementById('searchOrder').value = '';
                                                            document.getElementById('filterStatus').value = '';
                                                            document.getElementById('filterDate').value = '';
                                                            filterOrders();
                                                        }

                                                        // Live Filtering Event Listeners
                                                        document.addEventListener('DOMContentLoaded', function () {
                                                            // User Filter Events
                                                            const searchUser = document.getElementById('searchUser');
                                                            const filterRole = document.getElementById('filterRole');
                                                            if (searchUser) searchUser.addEventListener('keyup', filterUsers);
                                                            if (filterRole) filterRole.addEventListener('change', filterUsers);

                                                            // Order Filter Events
                                                            const searchOrder = document.getElementById('searchOrder');
                                                            const filterStatus = document.getElementById('filterStatus');
                                                            const filterDate = document.getElementById('filterDate');
                                                            if (searchOrder) searchOrder.addEventListener('keyup', filterOrders);
                                                            if (filterStatus) filterStatus.addEventListener('change', filterOrders);
                                                            if (filterDate) filterDate.addEventListener('change', filterOrders);
                                                        });
                                                    </script>
                                                </body>

                                                </html>