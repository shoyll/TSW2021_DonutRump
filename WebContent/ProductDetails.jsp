                          <!-- Questa pagina gestisce i dettagli di ProdottoGenerico -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*, com.donutrump.model.bean.GeneralProductBean, com.donutrump.model.bean.UserBean, 
    com.donutrump.model.bean.CategoryBean, com.donutrump.model.dao.CategoryDAO" %>
 
 <%
	GeneralProductBean product = (GeneralProductBean) request.getAttribute("product");
 	UserBean user = (UserBean) request.getSession().getAttribute("current_user");
 	
 	CategoryDAO categoryModel = new CategoryDAO(); 
 	ArrayList<CategoryBean> categories = categoryModel.doRetrieveAll(null); 
 	
 	CategoryBean category = product.getCategoria(); 
 	if (category == null ){ 
 	   category.setNome("generico"); 
 	} 
%>
 
<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="styles/formStyle.css" type="text/css">
		<link rel="stylesheet" href="styles/ProductDetails.css">
		<meta charset=UTF-8>
		<meta content="width=device-width, initial-scale=1" name="viewport" />
		<title>Dettagli</title>
		<%@ include file="header.jsp" %>
	</head>
	
	<body style="background-image: url('images/wallpaper.jpg'); background-size: cover;">
		<%
			if (product != null && user!=null && user.getEmail().equals("admin@donut.rump.com") && user.getPswd().equals("root")) {
		%>
		
		                       <!-- vista e modifica di un prodotto generico lato amministratore -->
		                       
	 <div class="wrapper fadeInDown">
		  <div id="formContent">
			 <!-- Tabs Titles -->
			<h2 class="active" style="cursor:default;"> MODIFICA PRODOTTO </h2>
	
			<!-- Icon -->
      		<div class="fadeIn first">
        		<img src="images/package.png" id="icon" alt="User Icon"/>
      		</div>
 
		<form action="Admin" method="post">
		<input type="hidden" name="action" value="mod_product"> 
		<input type="hidden" name="id" value="<%=product.getId()%>"> <!-- ho bisogno di questo parametro perchè quanto c'è il disabled non viene inviata correttamente la coppia nome-valore al server, usiamo il disabled perchè neanche l'admin può modificare l'id di un prodotto -->
		
		<label for="id_locked">Id:</label><br> 
		<input type="number" name="id_locked"  class="fadeIn second" min="0" value="<%=product.getId()%>" disabled required> <br>
			
		<label for="name">Nome:</label><br> 
		<input name="name" type="text" class="fadeIn second" maxlength="20" value="<%=product.getNome()%>" required><br> 
			
		<label for="description">Descrizione:</label><br>
		<textarea name="description" class="fadeIn second" maxlength="300" required><%=product.getDescrizione()%></textarea><br>
			
		<label for="price">Prezzo:</label><br> 
		<input type="number" name="price" step="0.1" class="fadeIn second" min="0" value="<%=product.getPrezzo()%>" required><br>
	
		<label for="quantity">Quantità:</label><br> 
		<input name="quantity" type="number" min="1" class="fadeIn third" value="<%=product.getQuantitaDisponibile()%>" required ><br>
			
		<label for="iva">Iva:</label><br> 
		<input name="iva" type="number" min="1" class="fadeIn third" value="<%=product.getIva()%>" required><br><br>
		
		<label for="category">Categoria:</label>
		<select name= "category" class="fadeIn third">
		<% 
		if (categories!=null && categories.size()!=0){
		%>
		<option value="<%=category.getNome()%>" selected><%=category.getNome()%></option>
		<%	for (CategoryBean categoria : categories){	
				if (categoria.equals(category)==false) {
		%>
		<option value="<%=categoria.getNome()%>"><%=categoria.getNome()%></option>
		<% 
				}
			}
		}
		else { //altrimenti mostra selezionabile solo la categoria a cui già appartiene
		%>
		 <option value="<%=category.getNome()%>" selected><%=category.getNome()%></option>
		<% 
		}
		%>
		</select>
		<br/>
		<br/>
		<label for="image">Immagine:</label><br> 
		<input type="file" class="fadeIn third" name="image"><br><br><br>
	
		<div id="formFooter"style="padding: 3px 3px 3px 3px; margin-top:10%;">
			<input type="submit" class="fadeIn fourth" value="Modifica">  
			<input type="reset" class="fadeIn fourth" value="Annulla">
		</div>
		
	</form>
   </div>
  </div>
		
		<!-- ********************************************** vista di un prodotto generico lato normal user ****************************** -->
		<%}
		  else if (product != null) {
			  if (user==null || !user.isAdmin()){
		%>
		
		<h1>DETTAGLI</h1>
		
		<div class="small-container single-product">
			<div class="row">
				<div class="col-2">
					<img src="<%=product.getImmagine()%>" width="80%" id="photo">
				</div>
				<div class="col-2">
					<p>Home / <%=product.getCategoria().getNome()%></p>
					<h1><%=product.getNome()%></h1>
					<h4>€ <%=product.getPrezzo()%></h4>
					<div class="cont-1">		
						<input type="number" value="1" min="1" max="<%=product.getQuantitaDisponibile()%>"id="quantity">
						<a href="Product?action=addcart&id=<%=product.getId()%>" id="put-in-cart">Aggiungi al Carrello</a>
					</div>
				</div>	
			</div>
			<div class="row-2">
				<h1>Descrizione</h1>
				<br>
				<p><%=product.getDescrizione()%></p>
			</div>
		</div>
		
		<% 
			}
		  }
		%>
		
		<%@ include file="Footer.html"%>
		
	</body>
</html>