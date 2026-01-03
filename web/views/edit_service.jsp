<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, util.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Layanan - PoS Laundry</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f8f9fa; }
        .container { max-width: 600px; margin-top: 50px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="card-header bg-warning text-dark">
                <h4><i class="fas fa-edit me-2"></i>Edit Layanan</h4>
            </div>
            <div class="card-body">
                <%
                    int id = Integer.parseInt(request.getParameter("id"));
                    String name = "", description = "";
                    double price = 0;
                    
                    try (Connection conn = DatabaseConnection.getConnection()) {
                        String sql = "SELECT * FROM services WHERE id = ?";
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        stmt.setInt(1, id);
                        ResultSet rs = stmt.executeQuery();
                        if (rs.next()) {
                            name = rs.getString("name");
                            price = rs.getDouble("price");
                            description = rs.getString("description");
                        }
                    } catch (Exception e) { e.printStackTrace(); }
                %>
                
                <form action="ServiceServlet" method="post">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" value="<%= id %>">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Nama Layanan</label>
                        <input type="text" class="form-control" id="name" name="name" value="<%= name %>" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="price" class="form-label">Harga (Rp)</label>
                        <input type="number" class="form-control" id="price" name="price" value="<%= price %>" min="0" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="description" class="form-label">Deskripsi</label>
                        <textarea class="form-control" id="description" name="description" rows="3"><%= description %></textarea>
                    </div>
                    
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-warning"><i class="fas fa-save me-2"></i>Update Layanan</button>
                        <a href="services.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left me-2"></i>Kembali</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>