<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.pharmacy.model.Medicine, com.pharmacy.model.Customer" %>
<%
  List<Medicine> meds = (List<Medicine>) request.getAttribute("medicines");
  if (meds == null) meds = List.of();
  Customer customer = (Customer)request.getAttribute("customer");
  if (customer == null) {
    // if somehow missing, redirect back to login
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }


  String errorMsg = (String) request.getAttribute("error");

  // Build JSON for meds
  StringBuilder medJson = new StringBuilder("[");
  for (int i = 0; i < meds.size(); i++) {
    Medicine m = meds.get(i);
    medJson.append("{")
            .append("\"id\":").append(m.getId()).append(",")
            .append("\"name\":\"").append(m.getName().replace("\"","\\\"")).append("\",")
            .append("\"sku\":\"").append(m.getSku().replace("\"","\\\"")).append("\",")
            .append("\"price\":").append(m.getPrice()).append(",")
            .append("\"stock\":").append(m.getStock())
            .append("}");
    if (i < meds.size()-1) medJson.append(",");
  }
  medJson.append("]");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Place Order &mdash; Online Pharmacy</title>
  <style>
    .pt-lg {
      padding-top: 2rem; /* Adjust as needed */  /* :contentReference[oaicite:0]{index=0} */
    }

    /* Adds 2rem of padding inside the element at its bottom edge */
    .pb-lg {
      padding-bottom: 2rem; /* Adjust as needed */  /* :contentReference[oaicite:1]{index=1} */
    }


    /* Margin Utilities */
    /* Adds 2rem of margin outside the element at its top edge */
    .mt-lg {
      margin-top: 2rem; /* Adjust as needed */  /* :contentReference[oaicite:2]{index=2} */
    }

    /* Adds 2rem of margin outside the element at its bottom edge */
    .mb-lg {
      margin-bottom: 2rem; /* Adjust as needed */  /* :contentReference[oaicite:3]{index=3} */
    }
    :root {
      --brand: #0077cc;
      --brand-light: #e6f7ff;
      --text: #333;
      --border: #ddd;
      --radius: 5px;
      --gap: 1rem;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0; font-family: 'Segoe UI', sans-serif;
      color: var(--text); background: var(--brand-light);
    }
    header {
      background: var(--brand); color: #fff;
      padding: var(--gap); text-align: center;
    }
    main {
      max-width: 900px; margin: 2rem auto; padding: 0 var(--gap);
      background: #fff; border-radius: var(--radius); box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    h1 { margin-top: 0; }
    .error {
      background: #ffe6e6; color: #b30000;
      padding: var(--gap); border-radius: var(--radius);
      margin: var(--gap) 0;
    }
    form.customer {
      display: flex; gap: var(--gap); flex-wrap: wrap;
      background: var(--brand-light); padding: var(--gap);
      border-radius: var(--radius);
    }
    form.customer input {
      flex: 1 1 200px; padding: .5rem; border: 1px solid var(--border);
      border-radius: var(--radius);
    }
    .search-add {
      display: flex; gap: var(--gap); margin: var(--gap) 0;
    }

    .search-add input,
    .search-add button {
      padding: .5rem; border: 1px solid var(--border);
      border-radius: var(--radius);
    }
    .search-add button {
      background: var(--brand); color: #fff; cursor: pointer;
      border: none;
    }
    table {
      width: 100%; border-collapse: collapse;
      margin: var(--gap) 0;
    }
    th, td {
      border: 1px solid var(--border); padding: .75rem;
      text-align: left;
    }
    th { background: var(--brand-light); }
    input.qty {
      width: 60px; padding: .3rem;
    }
    .total {
      text-align: right; font-size: 1.25rem; font-weight: bold;
      margin: var(--gap) 0;
    }
    button.place {
      display: block; width: 100%; padding: .75rem;
      background: var(--brand); color: #fff; border: none;
      font-size: 1rem; cursor: pointer; border-radius: var(--radius);
    }
    button.place:disabled {
      background: #ccc; cursor: not-allowed;
    }
  </style>
</head>
<body>
<header>
  <h1>Place Your Order</h1>
</header>
<main class="pt-lg pb-lg">
  <% if (errorMsg != null) { %>
  <div class="error"><%= errorMsg %></div>
  <% } %>

  <div class="search-add">
    <input id="medSearch" list="medList"
           placeholder="Type medicine name…" autocomplete="off" />
    <datalist id="medList"></datalist>
    <button type="button" onclick="addByName()">Add to Cart</button>
  </div>

  <form class="customer" id="orderForm" method="post" action="order">
    <label for="#@C">Contact</label>
    <input id="#@C" type="text" name="phone"
           value="<%= customer.getPrimaryContact() %>"
           placeholder="Phone Number" required />
    <label for="##@C">Delivery</label>
    <input id="##@C"  type="text" name="address"
           value="<%= customer.getAddress()!=null?customer.getAddress():"" %>"
           placeholder="Delivery Address" required />

    <table>
      <thead>
      <tr>
        <th>Name</th><th>SKU</th><th>Price</th>
        <th>Qty</th><th>Line Total</th><th>Remove</th>
      </tr>
      </thead>
      <tbody id="orderBody"></tbody>
    </table>

    <div class="total">
      Grand Total: PKR <span id="grandTotal">0.00</span>
    </div>

    <button type="submit" class="place">Place Order</button>
  </form>
</main>

<script>
  // Inline server data
  const meds = <%= medJson.toString() %>;
  // Populate datalist
  const dl = document.getElementById('medList');
  meds.forEach(m=>{
    let o=document.createElement('option');
    o.value=m.name; dl.append(o);
  });

  function addByName(){
    let name=document.getElementById('medSearch').value.trim();
    let m=meds.find(x=>x.name===name);
    if(m) addItem(m);
    document.getElementById('medSearch').value='';
  }

  function addItem(m){
    if(document.getElementById('row_'+m.id)) return;
    let tbody=document.getElementById('orderBody');
    let tr=document.createElement('tr'); tr.id='row_'+m.id;
    const id = m.id;
    const name = m.name;
    const sku = m.sku;
    const price = m.price.toFixed(2)
    const stock = m.stock;
    tr.innerHTML= '<td>'+name+'</td>'+
        '<td>'+sku+'</td>'+
        '<td>$ '+price+'</td>'+
        '<td><input class="qty" name="qty_'+id+'"'+
                   'type="number" min="1" max="'+stock+'" value="1"></td>'+
        '<td class="line">'+price+'</td>'+
       ' <td><button type="button" onclick="removeItem('+id+')">✕</button></td>';
    tbody.append(tr);

    let inp=tr.querySelector('.qty'),
            line=tr.querySelector('.line');
    inp.addEventListener('input',e=>{
      let q=Math.max(1,Math.min(+e.target.max, +e.target.value||1));
      e.target.value=q;
      line.textContent=(q*m.price).toFixed(2);
      updateTotals();
    });
    updateTotals();
  }

  function removeItem(id){
    document.getElementById('row_'+id)?.remove();
    updateTotals();
  }

  function updateTotals(){
    let sum=0;
    document.querySelectorAll('.line')
            .forEach(td=>sum+=parseFloat(td.textContent)||0);
    document.getElementById('grandTotal').textContent=sum.toFixed(2);
    document.querySelector('button.place').disabled = sum===0;
  }

  // Prevent submit when cart empty
  document.getElementById('orderForm')
          .addEventListener('submit',e=>{
            if(!document.getElementById('orderBody').children.length){
              alert('Your cart is empty!');
              e.preventDefault();
            }
          });
</script>
</body>
</html>
