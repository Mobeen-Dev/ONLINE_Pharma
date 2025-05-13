
let cart = {};

function addToCart(id, name, price) {
if (!cart[id]) cart[id]={name, price, qty:0};
cart[id].qty++;
updateCartDisplay();
}

function updateCartDisplay() {
const count_item = Object.values(cart).reduce((sum,i)=>sum+i.qty,0);
document.getElementById('cartCount').textContent = count_item;
}

function showCart() {
const body = document.getElementById('cartBody');
body.innerHTML = '';
let total = 0;
for (let id in cart) {
const item = cart[id];
total += item.price*item.qty;
body.innerHTML += `
      <tr>
        <td>${item.name}</td>
        <td>${item.qty}</td>
        <td>₹${(item.price*item.qty).toFixed(2)}</td>
        <td><button onclick="removeItem(${id})">✕</button></td>
      </tr>`;
}
document.getElementById('cartTotal').textContent = total.toFixed(2);
document.getElementById('cartModal').style.display = 'flex';
}

function hideCart() {
document.getElementById('cartModal').style.display = 'none';
}

function removeItem(id) {
delete cart[id];
updateCartDisplay();
showCart();
}

function placeOrder() {
// serialize cart into a form and POST to /order
const form = document.createElement('form');
form.method='post'; form.action='order';
// preserve customer info
const phoneEl=document.querySelector('input[name=phone]');
const addrEl=document.querySelector('input[name=address]');
if (phoneEl && addrEl) {
form.appendChild(phoneEl.cloneNode());
form.appendChild(addrEl.cloneNode());
}
for (let id in cart) {
const qtyInput = document.createElement('input');
qtyInput.type='hidden';
qtyInput.name=`qty_${id}`;
qtyInput.value=cart[id].qty;
form.appendChild(qtyInput);
}
document.body.appendChild(form);
form.submit();
}

    function filter() {
    const q = document.getElementById('search').value.toLowerCase();
    document.querySelectorAll('.card').forEach(card=>{
    card.style.display = card.dataset.name.includes(q)?'flex':'none';
});
}
