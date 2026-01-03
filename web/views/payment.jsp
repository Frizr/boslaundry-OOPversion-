<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.sql.*, util.DatabaseConnection" %>
        <!DOCTYPE html>
        <html lang="id">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Pembayaran - PoS Laundry</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <style>
                body {
                    background: #f8f9fa;
                }

                .container {
                    max-width: 600px;
                    margin-top: 50px;
                }

                .payment-box {
                    background: #fff;
                    border: 2px solid #dee2e6;
                    border-radius: 10px;
                    padding: 20px;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h4><i class="fas fa-money-bill-wave me-2"></i>Proses Pembayaran</h4>
                    </div>
                    <div class="card-body">
                        <% int orderId=Integer.parseInt(request.getParameter("orderId")); String customerName="" ;
                            double totalAmount=0; String status="" ; try (Connection
                            conn=DatabaseConnection.getConnection()) { String
                            sql="SELECT o.total_amount, o.status, c.name as customer_name "
                            + "FROM orders o JOIN customers c ON o.customer_id = c.id " + "WHERE o.id = ?" ;
                            PreparedStatement stmt=conn.prepareStatement(sql); stmt.setInt(1, orderId); ResultSet
                            rs=stmt.executeQuery(); if (rs.next()) { customerName=rs.getString("customer_name");
                            totalAmount=rs.getDouble("total_amount"); status=rs.getString("status"); } } catch
                            (Exception e) { e.printStackTrace(); } pageContext.setAttribute("totalAmountValue",
                            totalAmount); %>

                            <div class="payment-box">
                                <h5><i class="fas fa-user me-2"></i>Pelanggan: <%= customerName %>
                                </h5>
                                <h5><i class="fas fa-tag me-2"></i>Total: Rp <%= String.format("%,.0f", totalAmount) %>
                                </h5>
                                <% String badgeClass="paid" .equals(status) ? "success" : "warning" ; %>
                                    <h5><i class="fas fa-clock me-2"></i>Status: <span
                                            class="badge bg-<%= badgeClass %>">
                                            <%= status %>
                                        </span></h5>
                            </div>

                            <form action="${pageContext.request.contextPath}/payment" method="post" class="mt-4">
                                <input type="hidden" name="action" value="pay">
                                <input type="hidden" name="orderId" value="<%= orderId %>">
                                <input type="hidden" name="amount" value="<%= totalAmount %>">

                                <div class="mb-3">
                                    <label for="paymentMethod" class="form-label">Metode Pembayaran</label>
                                    <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                                        <option value="">-- Pilih Metode --</option>
                                        <option value="cash">Uang Tunai</option>
                                        <option value="transfer">Transfer Bank</option>
                                        <option value="ewallet">E-Wallet</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="receivedAmount" class="form-label">Jumlah Diterima (Rp)</label>
                                    <input type="number" class="form-control" id="receivedAmount" name="receivedAmount"
                                        min="<%= totalAmount %>" step="1000" required>
                                </div>

                                <div class="mb-3">
                                    <label for="change" class="form-label">Kembalian (Rp)</label>
                                    <input type="text" class="form-control" id="change" readonly>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-success"><i class="fas fa-check me-2"></i>Bayar
                                        Sekarang</button>
                                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-secondary"><i
                                            class="fas fa-arrow-left me-2"></i>Kembali</a>
                                </div>
                            </form>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                document.getElementById('receivedAmount').addEventListener('input', function () {
                    const total = ${ totalAmountValue };
                    const received = parseFloat(this.value) || 0;
                    const change = received - total;
                    document.getElementById('change').value = change >= 0 ? 'Rp ' + change.toLocaleString('id-ID') : 'Rp 0';
                });
            </script>
        </body>

        </html>