<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Edit Book | Library Management System</title>

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
        }

        .cover-preview img.hidden {
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
                <h1>Edit Book</h1>
                <p>Update the selected book's catalogue information.</p>
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
                    <h2>Update Catalogue Entry</h2>
                </div>
            </div>

            <form method="post"
                  action="${pageContext.request.contextPath}/books"
                  enctype="multipart/form-data"
                  class="book-form">

                <input type="hidden" name="action" value="update">

                <input type="hidden" name="id"
                       value="<c:out value='${book.id}'/>">

                <div class="form-grid">

                    <div class="form-field">
                        <label for="isbn">ISBN *</label>
                        <input class="form-control"
                               id="isbn"
                               name="isbn"
                               type="text"
                               maxlength="20"
                               required
                               value="<c:out value='${book.isbn}'/>">
                    </div>

                    <div class="form-field">
                        <label for="title">Book Title *</label>
                        <input class="form-control"
                               id="title"
                               name="title"
                               type="text"
                               maxlength="200"
                               required
                               value="<c:out value='${book.title}'/>">
                    </div>

                    <div class="form-field">
                        <label for="author">Author *</label>
                        <input class="form-control"
                               id="author"
                               name="author"
                               type="text"
                               maxlength="150"
                               required
                               value="<c:out value='${book.author}'/>">
                    </div>

                    <div class="form-field">
                        <label for="category">Category *</label>
                        <input class="form-control"
                               id="category"
                               name="category"
                               type="text"
                               maxlength="100"
                               required
                               value="<c:out value='${book.category}'/>">
                    </div>

                    <div class="form-field">
                        <label for="totalCopies">Total Copies *</label>
                        <input class="form-control"
                               id="totalCopies"
                               name="totalCopies"
                               type="number"
                               min="1"
                               max="100000"
                               required
                               value="<c:out value='${book.totalCopies}'/>">

                        <small>
                            Available copies cannot exceed total copies.
                        </small>
                    </div>

                    <div class="form-field">
                        <label for="availableCopies">
                            Currently Available
                        </label>

                        <input class="form-control"
                               id="availableCopies"
                               type="number"
                               readonly
                               value="<c:out value='${book.availableCopies}'/>">

                        <small>
                            Managed by issue and return transactions.
                        </small>
                    </div>

                </div>

                <!-- Book Cover Upload -->
                <div class="cover-upload-section">

                    <p class="eyebrow">BOOK APPEARANCE</p>
                    <h3>Update Book Cover</h3>

                    <div class="cover-upload-grid">

                        <div class="form-field">
                            <label for="coverImage">
                                Choose New Cover Image
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

                            <small class="upload-hint">
                                Leave empty to keep the existing book cover.
                            </small>
                        </div>

                        <div class="cover-preview">

                            <span id="previewPlaceholder"
                                    <c:if test="${not empty book.coverImagePath}">
                                        style="display:none;"
                                    </c:if>>
                                No cover available
                            </span>

                            <img id="coverPreview"
                                 class="${empty book.coverImagePath ? 'hidden' : ''}"
                                 src="<c:if test='${not empty book.coverImagePath}'><c:out value='${pageContext.request.contextPath}${book.coverImagePath}'/></c:if>"
                                 alt="Book cover preview">

                        </div>

                    </div>
                </div>

                <div class="form-actions">

                    <a class="btn btn-quiet"
                       href="${pageContext.request.contextPath}/books">
                        Cancel
                    </a>

                    <button class="btn btn-primary" type="submit">
                        Save Changes
                    </button>

                </div>

            </form>

        </section>

        <footer class="page-footer">
            <span>Library Management System</span>
            <span>Edit Book</span>
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
            coverPreview.classList.remove("hidden");
            placeholder.style.display = "none";
        };

        reader.readAsDataURL(file);
    });
</script>

</body>
</html>
