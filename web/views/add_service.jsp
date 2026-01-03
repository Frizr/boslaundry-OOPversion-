<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="id">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tambah Layanan - PoS Laundry</title>
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
        </style>
    </head>

    <body>
        <div class="container">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h4><i class="fas fa-plus me-2"></i>Tambah Layanan Baru</h4>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/services" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="mb-3">
                            <label for="name" class="form-label">Nama Layanan</label>
                            <input type="text" class="form-control" id="name" name="name" required>
                        </div>

                        <div class="mb-3">
                            <label for="price" class="form-label">Harga (Rp)</label>
                            <input type="number" class="form-control" id="price" name="price" min="0" required>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">Deskripsi</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save me-2"></i>Simpan
                                Layanan</button>
                            <a href="${pageContext.request.contextPath}/services" class="btn btn-secondary"><i
                                    class="fas fa-arrow-left me-2"></i>Kembali</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>