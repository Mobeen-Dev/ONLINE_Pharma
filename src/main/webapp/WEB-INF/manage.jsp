<%@ page import="java.util.List, com.pharmacy.model.Medicine" %>
<%
    List<Medicine> meds = (List<Medicine>)request.getAttribute("medicines");
    String msg = (String)request.getAttribute("message");
%>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Manage Medicines</title>
    <style>
        :root {
            --primary: #0066cc;
            --primary-light: #e6f2ff;
            --accent: #005bb5;
            --border: #ddd;
            --bg: #f9f9f9;
            --text: #333;
            --radius: 6px;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0; font-family: 'Segoe UI', sans-serif;
            color: var(--text); background: var(--bg);
        }
        header {
            background: var(--primary); color: #fff;
            padding: 1rem; text-align: center;
        }
        main { max-width: 960px; margin: 2rem auto; padding: 0 1rem; }
        .tabs { display: flex; border-bottom: 2px solid var(--border); }
        .tab {
            flex: 1; padding: 0.75rem; text-align: center;
            cursor: pointer; background: var(--primary-light);
            border: 1px solid var(--border); border-bottom: none;
            border-radius: var(--radius) var(--radius) 0 0;
            transition: background 0.3s;
        }
        .tab.active { background: #fff; font-weight: bold; }
        .panel { display: none; padding: 1rem; background: #fff; border: 1px solid var(--border); border-top: none; border-radius: 0 0 var(--radius) var(--radius); }
        .panel.active { display: block; }

        form { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 2rem; }
        form > * { margin: 0.5rem 0; }
        form label { display: block; font-weight: bold; margin-bottom: 0.25rem; }
        form input, form select, form button {
            width: 100%; padding: 0.5rem; border: 1px solid var(--border);
            border-radius: var(--radius);
        }
        form button {
            grid-column: span 2; background: var(--primary); color: #fff;
            border: none; cursor: pointer; transition: background 0.3s;
        }
        form button:hover { background: var(--accent); }

        .table-container { overflow-x: auto; }
        table {
            width: 100%; border-collapse: collapse;
            margin-top: 1rem;
        }
        th, td {
            border: 1px solid var(--border);
            padding: 0.75rem; text-align: left;
        }
        th { background: var(--primary-light); }
        tbody tr:nth-child(even) { background: #f1faff; }

        .message { padding: 0.75rem; margin-bottom: 1rem; border-radius: var(--radius); }
        .message.info { background: #e7f4ff; color: var(--primary); border: 1px solid var(--primary); }
        .message.error { background: #ffe7e7; color: #b30000; border: 1px solid #b30000; }

        @media (max-width: 600px) {
            form { grid-template-columns: 1fr; }
            form button { grid-column: span 1; }
        }
    </style>
</head>
<body>

<header>
    <h1>Online Pharmacy &ndash; Manage Medicines</h1>
</header>

<main>
    <!-- Toast message area -->
    <div id="message" class="message info" style="display:none;"></div>

    <!-- Tabs -->
    <div class="tabs">
        <div class="tab active" data-target="add">Add New</div>
        <div class="tab" data-target="edit">Edit</div>
        <div class="tab" data-target="delete">Delete</div>
        <div class="tab" data-target="inventory">Inventory</div>
    </div>

    <!-- Panels -->
    <section id="add" class="panel active">
        <form id="addForm" method="post" action="manage">
            <input type="hidden" name="action" value="add"/>
            <label for="name">Name</label><input id="name" name="name" required/>
            <label for="manufacturer">Manufacturer</label><input id="manufacturer" name="manufacturer"/>
            <label for="sku">SKU</label><input id="sku" name="sku" required/>
            <label for="price">Price (Rs.)</label><input id="price" name="price" type="number" min="0" step=".01" required/>
            <label for="stock">Stock</label><input id="stock" name="stock" type="number" min="0" required/>
            <button type="submit">Add Medicine</button>
        </form>
    </section>

    <section id="edit" class="panel">
        <form id="editForm" method="post" action="manage">
            <input type="hidden" name="action" value="edit"/>
            <label for="lookupType">Lookup by</label>
            <select id="lookupType" name="lookupType">
                <option value="sku">SKU</option>
                <option value="name">Name</option>
            </select>
            <label for="lookupValue">Value</label><input id="lookupValue" name="lookupValue" placeholder="Enter SKU or Name" required/>
            <label for="newSku">New SKU</label><input id="newSku" name="newSku"/>
            <label for="newPrice">New Price (Rs.)</label><input id="newPrice" name="newPrice" type="number" min="0" step=".01"/>
            <label for="newStock">New Stock</label><input id="newStock" name="newStock" type="number" min="0"/>
            <button type="submit">Update Medicine</button>
        </form>
    </section>

    <section id="delete" class="panel">
        <form id="deleteSkuForm" method="post" action="manage">
            <input type="hidden" name="action" value="deleteSku"/>
            <label for="skuDel">SKU</label><input id="skuDel" name="skuDel" required/>
            <button type="submit">Delete by SKU</button>
        </form>
        <form id="deleteNameForm" method="post" action="manage">
            <input type="hidden" name="action" value="deleteName"/>
            <label for="nameDel">Name</label><input id="nameDel" name="nameDel" required/>
            <button type="submit">Delete by Name</button>
        </form>
    </section>

    <section id="inventory" class="panel">
        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>ID</th><th>Name</th><th>Manufacturer</th><th>SKU</th><th>Price (Rs.)</th><th>Stock</th>
                </tr>
                </thead>
                <tbody id="inventoryBody">
                <!-- Rows populated by JS -->
                <% for (Medicine m : meds) { %>
                <tr>
                    <td><%= m.getId() %></td>
                    <td><%= m.getName() %></td>
                    <td><%= m.getManufacturer() %></td>
                    <td><%= m.getSku() %></td>
                    <td>PKR <%= m.getPrice() %></td>
                    <td><%= m.getStock() %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</main>

<script>
    // Tab switching
    document.querySelectorAll('.tab').forEach(tab => {
        tab.addEventListener('click', () => {
            document.querySelectorAll('.tab, .panel').forEach(el => {
                el.classList.toggle('active', el.dataset.target === tab.dataset.target);
            });
            document.getElementById(tab.dataset.target).classList.add('active');
            document.querySelectorAll('.panel').forEach(p => p.style.display = p.classList.contains('active') ? 'block' : 'none');
            document.querySelectorAll('.tab').forEach(t => t.classList.toggle('active', t === tab));
        });
    });

    // Populate inventory table from server-provided JSON in a <script> block or AJAX
    // For demo, we assume a global `medicines` array:
    const medicines = [];
    const tbody = document.getElementById('inventoryBody');
    medicines.forEach(m => {
        console.log(m)
        const tr = document.createElement('tr');
        tr.innerHTML = `
        <td>${m.id}</td>
        <td>${m.name}</td>
        <td>${m.manufacturer}</td>
        <td>${m.sku}</td>
        <td>${m.price.toFixed(2)}</td>
        <td>${m.stock}</td>
      `;
        tbody.appendChild(tr);
    });

    // Optional: read a `message` from server and display
    const serverMsg = '<%= msg != null ? msg.replace("'", "\\'") : "" %>';
    if (serverMsg) {
        const box = document.getElementById('message');
        box.textContent = serverMsg;
        box.style.display = 'block';
    }
</script>

</body>
</html>

