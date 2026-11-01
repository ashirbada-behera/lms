<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Add Book | Library Management System</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/book-management.css">

    <style>
        .app-shell {
            min-height: 100vh;
        }

        .main-content {
            width: 100%;
            max-width: 1600px;
            margin: 0 auto;
            padding: 34px 42px;
        }

        .cover-upload-section {
            margin-top: 26px;
            padding-top: 22px;
            border-top: 1px solid var(--ref-border);
        }

        .cover-upload-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 150px;
            gap: 24px;
            align-items: center;
        }

        .cover-preview {
            width: 150px;
            height: 190px;
            border: 1px dashed var(--ref-border);
            border-radius: 12px;
            background: var(--ref-cream);
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            color: var(--ref-muted);
            text-align: center;
            padding: 10px;
        }

        .cover-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: none;
        }

        .cover-preview span {
            font-size: 13px;
        }

        .cover-input {
            margin-top: 10px;
        }

        .upload-hint {
            display: block;
            margin-top: 8px;
            color: var(--ref-muted);
            font-size: 12px;
        }

        @media (max-width: 760px) {
            .main-content {
                padding: 24px 16px;
            }

            .cover-upload-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
<div class="app-shell">

    <main class="main-content">

        <header class="topbar">
            <div>
                <p class="eyebrow">LIBRARY MANAGEMENT / BOOKS</p>
                <h1>Add Book</h1>
                <p>Add a new title to the library catalogue.</p>
            </div>

            <a class="btn btn-quiet"
               href="${pageContext.request.contextPath}/books">
                Back to Catalogue
            </a>
        </header>

        <c:if test="${not empty error}">
            <div class="alert alert-error" role="alert">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <section class="panel">

            <div class="panel-heading">
                <div>
                    <p class="eyebrow">BOOK DETAILS</p>
                    <h2>New Catalogue Entry</h2>
                </div>
            </div>

            <form method="post"
                  action="${pageContext.request.contextPath}/books"
                  enctype="multipart/form-data"
                  class="book-form">

                <input type="hidden" name="action" value="create">

                <div class="form-grid">

                    <div class="form-field">
                        <label for="isbn">ISBN *</label>
                        <input class="form-control"
                               id="isbn"
                               name="isbn"
                               type="text"
                               maxlength="20"
                               required
                               placeholder="e.g. 9780132350884">
                    </div>

                    <div class="form-field">
                        <label for="title">Book Title *</label>
                        <input class="form-control"
                               id="title"
                               name="title"
                               type="text"
                               maxlength="200"
                               required
                               placeholder="Enter book title">
                    </div>

                    <div class="form-field">
                        <label for="author">Author *</label>
                        <input class="form-control"
                               id="author"
                               name="author"
                               type="text"
                               maxlength="150"
                               required
                               placeholder="Enter author name">
                    </div>

                    <div class="form-field">
                        <label for="category">Category *</label>
                        <input class="form-control"
                               id="category"
                               name="category"
                               type="text"
                               maxlength="100"
                               required
                               placeholder="e.g. Computer Science">
                    </div>

                    <div class="form-field">
                        <label for="totalCopies">Total Copies *</label>
                        <input class="form-control"
                               id="totalCopies"
                               name="totalCopies"
                               type="number"
                               min="1"
                               max="100000"
                               value="1"
                               required>

                        <small>
                            Available copies will initially equal total copies.
                        </small>
                    </div>

                </div>

                <!-- Book Cover Upload -->
                <div class="cover-upload-section">

                    <p class="eyebrow">BOOK APPEARANCE</p>
                    <h3>Book Cover Image</h3>

                    <div class="cover-upload-grid">

                        <div class="form-field">
                            <label for="coverImage">
                                Select Cover Image
                            </label>

                            <input class="form-control cover-input"
                                   id="coverImage"
                                   name="coverImage"
                                   type="file"
                                   accept=".jpg,.jpeg,.png,.webp,image/jpeg,image/png,image/webp">

                            <small class="upload-hint">
                                Supported formats: JPG, JPEG, PNG and WEBP.
                                Maximum size: 2 MB.
                            </small>
                        </div>

                        <div class="cover-preview">
                            <span id="previewPlaceholder">
                                Cover preview
                            </span>

                            <img id="coverPreview"
                                 src=""
                                 alt="Selected book cover preview">
                        </div>

                    </div>
                </div>

                <div class="form-actions">

                    <a class="btn btn-quiet"
                       href="${pageContext.request.contextPath}/books">
                        Cancel
                    </a>

                    <button class="btn btn-primary" type="submit">
                        Save Book
                    </button>

                </div>

            </form>

        </section>

        <footer class="page-footer">
            <span>Library Management System</span>
            <span>New Book Entry</span>
        </footer>

    </main>

</div>

<script>
    const coverInput = document.getElementById("coverImage");
    const coverPreview = document.getElementById("coverPreview");
    const placeholder = document.getElementById("previewPlaceholder");

    coverInput.addEventListener("change", function () {

        const file = this.files[0];

        if (!file) {
            coverPreview.style.display = "none";
            placeholder.style.display = "block";
            coverPreview.src = "";
            return;
        }

        const allowedTypes = [
            "image/jpeg",
            "image/png",
            "image/webp"
        ];

        if (!allowedTypes.includes(file.type)) {
            alert("Please select a JPG, PNG or WEBP image.");
            this.value = "";
            return;
        }

        if (file.size > 2 * 1024 * 1024) {
            alert("Image size must not exceed 2 MB.");
            this.value = "";
            return;
        }

        const reader = new FileReader();

        reader.onload = function (event) {
            coverPreview.src = event.target.result;
            coverPreview.style.display = "block";
            placeholder.style.display = "none";
        };

        reader.readAsDataURL(file);
    });
</script>

</body>
</html>
