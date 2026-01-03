<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.sql.*, util.DatabaseConnection" %>
        <% /* V2.0 - Forced Update Check */ if (session.getAttribute("userId")==null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp" ); return; } String
            userIdVal=session.getAttribute("userId").toString(); %>
            <!DOCTYPE html>
            <html lang="id">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Buat Pesanan - PoS Laundry</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <style>
                    body {
                        background: #f8f9fa;
                    }

                    .container {
                        max-width: 800px;
                        margin-top: 50px;
                    }

                    .item-row {
                        margin-bottom: 10px;
                    }

                    .total-box {
                        background: #e9ecef;
                        padding: 20px;
                        border-radius: 10px;
                    }
                </style>
            </head>

            <body>
                <div class="container">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h4><i class="fas fa-plus me-2"></i>Buat Pesanan Baru</h4>
                        </div>
                        <div class="card-body">
                            <form id="orderForm" action="${pageContext.request.contextPath}/orders" method="post">
                                <input type="hidden" name="action" value="create">
                                <input type="hidden" name="employeeId" value="<%= userIdVal %>">

                                <!-- Data Pelanggan -->
                                <h5><i class="fas fa-user me-2"></i>Data Pelanggan</h5>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="customerName" class="form-label">Nama Pelanggan</label>
                                        <input type="text" class="form-control" id="customerName" name="customerName"
                                            required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="customerPhone" class="form-label">No. Telepon</label>
                                        <input type="text" class="form-control" id="customerPhone" name="customerPhone">
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="customerAddress" class="form-label">Alamat</label>
                                    <textarea class="form-control" id="customerAddress" name="customerAddress"
                                        rows="2"></textarea>
                                </div>

                                <!-- Pilih Layanan -->
                                <h5 class="mt-4"><i class="fas fa-list me-2"></i>Pilih Layanan</h5>
                                <div id="serviceItems">
                                    <div class="item-row row">
                                        <div class="col-md-5">
                                            <select class="form-select service-select" name="serviceId[]" required>
                                                <option value="">-- Pilih Layanan --</option>
                                                <% try (Connection conn=DatabaseConnection.getConnection()) { String
                                                    sql="SELECT * FROM services ORDER BY name" ; PreparedStatement
                                                    stmt=conn.prepareStatement(sql); ResultSet rs=stmt.executeQuery();
                                                    while (rs.next()) { int svcId=rs.getInt("id"); String
                                                    svcName=rs.getString("name"); double svcPrice=rs.getDouble("price");
                                                    String svcPriceFmt=String.format("%,.0f", svcPrice); %>
                                                    <option value="<%= svcId %>" data-price="<%= svcPrice %>">
                                                        <%= svcName %> (Rp <%= svcPriceFmt %>)
                                                    </option>
                                                    <% } } catch (Exception e) { e.printStackTrace(); } %>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <input type="number" class="form-control quantity" name="quantity[]"
                                                value="1" min="1" required>
                                        </div>
                                        <div class="col-md-3">
                                            <input type="text" class="form-control subtotal" name="subtotal[]" readonly>
                                        </div>
                                        <div class="col-md-1 d-flex align-items-center">
                                            <button type="button" class="btn btn-sm btn-outline-danger remove-item"><i
                                                    class="fas fa-minus"></i></button>
                                        </div>
                                    </div>
                                </div>

                                <div class="mt-2">
                                    <button type="button" id="addService" class="btn btn-sm btn-outline-primary"><i
                                            class="fas fa-plus me-2"></i>Tambah Layanan</button>
                                </div>

                                <!-- Total -->
                                <div class="total-box mt-4">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <h5>Total:</h5>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <h4 id="totalAmount">Rp 0</h4>
                                            <input type="hidden" name="totalAmount" id="hiddenTotal">
                                        </div>
                                    </div>
                                </div>

                                <!-- Tombol Simpan -->
                                <div class="mt-4 d-grid gap-2">
                                    <button type="submit" class="btn btn-primary"><i class="fas fa-save me-2"></i>Simpan
                                        Pesanan</button>
                                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-secondary"><i
                                            class="fas fa-arrow-left me-2"></i>Kembali</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const serviceItems = document.getElementById('serviceItems');
                        const addServiceBtn = document.getElementById('addService');
                        const totalAmountEl = document.getElementById('totalAmount');
                        const hiddenTotal = document.getElementById('hiddenTotal');

                        /* Generate options HTML once to reuse in JS */
                        const serviceOptions = `
                <option value="">-- Pilih Layanan --</option>
<%
    try (Connection conn = DatabaseConnection.getConnection()) {
        String sql = "SELECT * FROM services ORDER BY name";
        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            int svcId = rs.getInt("id");
            String svcName = rs.getString("name");
            double svcPrice = rs.getDouble("price");
            String svcPriceFmt = String.format("%,.0f", svcPrice);
%>
                <option value="<%= svcId %>" data-price="<%= svcPrice %>"><%= svcName %> (Rp <%= svcPriceFmt %>)</option>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
            `;

                        // Tambah item layanan
                        addServiceBtn.addEventListener('click', function () {
                            const newRow = document.createElement('div');
                            newRow.className = 'item-row row';
                            newRow.innerHTML = `
                    <div class="col-md-5">
                        <select class="form-select service-select" name="serviceId[]" required>
                            \${serviceOptions}
                        </select>
                    </div>
                    <div class="col-md-3">
                        <input type="number" class="form-control quantity" name="quantity[]" value="1" min="1" required>
                    </div>
                    <div class="col-md-3">
                        <input type="text" class="form-control subtotal" name="subtotal[]" readonly>
                    </div>
                    <div class="col-md-1 d-flex align-items-center">
                        <button type="button" class="btn btn-sm btn-outline-danger remove-item"><i class="fas fa-minus"></i></button>
                    </div>
                `;
                            serviceItems.appendChild(newRow);
                            attachEventListeners(newRow);
                        });

                        // Hapus item
                        serviceItems.addEventListener('click', function (e) {
                            if (e.target.classList.contains('remove-item') || e.target.closest('.remove-item')) {
                                if (serviceItems.children.length > 1) {
                                    e.target.closest('.item-row').remove();
                                    calculateTotal();
                                }
                            }
                        });

                        // Hitung subtotal dan total
                        function calculateTotal() {
                            let total = 0;
                            const rows = serviceItems.querySelectorAll('.item-row');
                            rows.forEach(row => {
                                const serviceSelect = row.querySelector('.service-select');
                                const quantityInput = row.querySelector('.quantity');
                                const subtotalInput = row.querySelector('.subtotal');

                                if (serviceSelect.value && quantityInput.value) {
                                    const price = parseFloat(serviceSelect.selectedOptions[0].dataset.price);
                                    const quantity = parseInt(quantityInput.value);
                                    const subtotal = price * quantity;
                                    subtotalInput.value = 'Rp ' + subtotal.toLocaleString('id-ID');
                                    total += subtotal;
                                }
                            });
                            totalAmountEl.textContent = 'Rp ' + total.toLocaleString('id-ID');
                            hiddenTotal.value = total;
                        }

                        function attachEventListeners(row) {
                            const serviceSelect = row.querySelector('.service-select');
                            const quantityInput = row.querySelector('.quantity');

                            serviceSelect.addEventListener('change', calculateTotal);
                            quantityInput.addEventListener('input', calculateTotal);
                        }

                        // Initial attach for first row
                        serviceItems.querySelectorAll('.item-row').forEach(row => {
                            attachEventListeners(row);
                        });
                    });
                </script>
            </body>

            </html>