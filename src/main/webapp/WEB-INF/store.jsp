<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList, com.pharmacy.model.Medicine" %>
<%
    List<Medicine> meds = (List<Medicine>) request.getAttribute("medicines");
    System.out.println("DEBUG: MEDICINE DATA = " + meds);
    if (meds == null) meds = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Medicine Catalog</title>

    <!-- Script definitions must come first -->
    <script>
        let cart = {};

        function addToCart(id, name, price, stock) {
            if (cart[id]) {
                alert(name + ' is already in your cart.');
                showCart();
                return;
            }
            cart[id] = { name: name, price: price, stock: stock, qty: 1 };
            updateCartDisplay();
            showCart();
        }

        function updateCartDisplay() {
            const count = Object.values(cart).reduce((sum, item) => sum + item.qty, 0);
            document.getElementById('cartCount').textContent = count;
        }

        function showCart() {
            const body = document.getElementById('cartBody');
            body.innerHTML = '';
            let total = 0;
            for (let id in cart) {
                const item = cart[id];
                total += item.price * item.qty;
                const tr = document.createElement('tr');
                console.log(item);
                tr.id = 'row_' + id;

                tr.innerHTML =
                    '<td>' + item.name + '</td>' +
                    '<td><input class="qty" type="number" min="1" max="' + item.stock + '" value="' + item.qty + '" style="width:60px"></td>' +
                    '<td class="line">₹' + (item.price * item.qty).toFixed(2) + '</td>' +
                    '<td><button type="button" onclick="removeItem(' + id + ')">✕</button></td>';
                body.appendChild(tr);
                // attach listener
                tr.querySelector('.qty').addEventListener('input', e => {
                    let q = parseInt(e.target.value, 10);
                    if (isNaN(q) || q < 1) q = 1;
                    if (q > item.stock) q = item.stock;
                    e.target.value = q;
                    item.qty = q;
                    tr.querySelector('.line').textContent = '₹' + (item.price * q).toFixed(2);
                    updateCartDisplay();
                    updateCartTotal();
                });
            }
            updateCartTotal();
            document.getElementById('cartModal').classList.add('active');
        }

        function updateCartTotal() {
            let total = 0;
            for (let id in cart) {
                const item = cart[id];
                total += item.price * item.qty;
            }
            document.getElementById('cartTotal').textContent = total.toFixed(2);
        }

        function hideCart() {
            document.getElementById('cartModal').classList.remove('active');
        }

        function removeItem(id) {
            delete cart[id];
            updateCartDisplay();
            showCart();
        }

        function placeOrder() {
            const form = document.createElement('form');
            form.method = 'post';
            for (let id in cart) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'qty_' + id;
                input.value = cart[id].qty;
                form.appendChild(input);
            }
            document.body.appendChild(form);
            form.submit();
        }

        function filter() {
            const q = document.getElementById('search').value.toLowerCase();
            document.querySelectorAll('.card').forEach(card => {
                card.style.display = card.dataset.name.includes(q) ? 'flex' : 'none';
            });
        }

        // Expose globally
        window.addToCart = addToCart;
        window.showCart = showCart;
        window.hideCart = hideCart;
        window.placeOrder = placeOrder;
        window.filter = filter;
    </script>

    <style>
        body { font-family: Arial, sans-serif; margin:0; padding:0; background:#f9f9f9; }
        .toolbar {
            display: flex; align-items: center; gap:1rem;
            padding:1rem; background:#fff; border-bottom:1px solid #ddd;
        }
        .toolbar input[type="search"] {
            flex:1; padding:0.5rem; border:1px solid #ccc; border-radius:4px;
        }
        .toolbar button {
            padding:0.5rem 1rem; border:none; border-radius:4px;
            background:#0077cc; color:#fff; cursor:pointer;
        }
        .toolbar button.place { background:#28a745; }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap:1rem;
            padding:1rem;
        }
        .card {
            background:#fff; border:1px solid #ddd; border-radius:8px;
            overflow:hidden; display:flex; flex-direction:column;
            box-shadow:0 2px 6px rgba(0,0,0,0.1);
        }
        .card img, .default-img {
            width:100%; height:140px; object-fit:cover;
            background:#ececec; display:flex; align-items:center;
            justify-content:center; color:#777; font-size:0.9rem;
        }
        .card-body { padding:0.75rem; flex:1; display:flex; flex-direction:column; }
        .card h3 { margin:0 0 0.5rem; font-size:1.1rem; color:#333; }
        .card p { margin:0 0 1rem; font-weight:bold; color:#0077cc; }
        .card button {
            margin-top:auto; padding:0.5rem; border:none; border-radius:4px;
            background:#ff6600; color:#fff; cursor:pointer;
        }

        /* Cart Modal */
        #cartModal {
            position: fixed; top:0; left:0; width:100%; height:100%;
            background: rgba(0,0,0,0.5); display:none; align-items:center; justify-content:center;
        }
        #cartModal.active { display:flex; }
        #cartModal .modal-content {
            background:#fff; padding:1rem; border-radius:8px; width:90%; max-width:400px;
        }
        #cartModal table {
            width:100%; border-collapse:collapse; margin-bottom:1rem;
        }
        #cartModal th, #cartModal td {
            border:1px solid #ddd; padding:0.5rem; text-align:left;
        }
        #cartModal button { padding:0.5rem 1rem; border:none; border-radius:4px; background:#0077cc; color:#fff; cursor:pointer; }
    </style>
</head>
<body>

<!-- Toolbar -->
<div class="toolbar">
    <input type="search" id="search" placeholder="Search medicines…" oninput="filter()"/>
    <button onclick="showCart()">View Cart (<span id="cartCount">0</span>)</button>
    <button class="place" onclick="placeOrder()">Place Order</button>
</div>

<!-- Medicine Grid -->
<div class="grid">
    <% for (Medicine m : meds) {
        String img = m.getImageUrl();
        String name = m.getName().replace("'","\\'");
        String price = m.getPrice().setScale(2).toString();
        int stock = m.getStock();
    %>
    <div class="card" data-name="<%= name.toLowerCase() %>">
        <% if (img != null && !img.isEmpty()) { %>
        <img src="<%= img %>" alt="<%= m.getName() %>"/>
        <% } else { %>
        <div class="default-img">No Image</div>
        <% } %>
        <div class="card-body">
            <h3><%= m.getName() %></h3>
            <p>Rs. <%= price %></p>
            <button onclick="addToCart(<%= m.getId() %>, '<%= name %>', <%= price %>,<%= stock %> )">
                Add to Cart
            </button>
        </div>
    </div>
    <% } %>
</div>

<!-- Cart Modal -->
<div id="cartModal">
    <div class="modal-content">
        <h2>Your Cart</h2>
        <table>
            <thead><tr><th>Medicine</th><th>Qty</th><th>Price</th><th></th></tr></thead>
            <tbody id="cartBody"></tbody>
        </table>
        <p>Total: ₹<span id="cartTotal">0.00</span></p>
        <button onclick="placeOrder()">Checkout</button>
        <button onclick="hideCart()" style="margin-left:1rem;background:#dc3545;">Close</button>
    </div>
</div>

</body>
</html>
