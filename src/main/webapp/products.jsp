<%@ page import="java.util.List" %>
<%@ page import="com.ecommerce.model.Product" %>

<%
List<Product> products = (List<Product>) request.getAttribute("products");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Products</title>
</head>
<body>

<h1>All Products</h1>

<div style="display:flex;flex-wrap:wrap;gap:20px;">

<%
for(Product p : products){
%>

<div style="width:250px;border:1px solid #ccc;padding:15px;">

    <img src="<%=p.getImage1()%>" width="100%" height="200px">

    <h3><%=p.getName()%></h3>

    <p><%=p.getDescription()%></p>

    <h2>$<%=p.getPrice()%></h2>

    <p>Status: <%=p.getStatus()%></p>

    <button>Add To Cart</button>

    <button>Add To Wishlist</button>

</div>

<%
}
%>

</div>

</body>
</html>