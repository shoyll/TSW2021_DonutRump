package com.donutrump.control;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;

import com.donutrump.model.bean.GeneralProductBean;
import com.donutrump.model.dao.GeneralProductDAO;


public class GeneralProductServlet extends HttpServlet{
	
	private static final long serialVersionUID = 1L;
	
	static GeneralProductDAO model = new GeneralProductDAO();

	public GeneralProductServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		try {
			
			if (action != null) {
				if (action.equalsIgnoreCase("read")){
					int id = Integer.parseInt(request.getParameter("id"));
					request.removeAttribute("product");
					request.setAttribute("product", model.doRetrieveByKey(id));
				} 
				
				else if (action.equalsIgnoreCase("delete")){
					int id = Integer.parseInt(request.getParameter("id"));
					model.doDelete(id);
				} 
				else if (action.equalsIgnoreCase("insert")){
					
					String name = request.getParameter("name");
					String description = request.getParameter("description");
					int price = Integer.parseInt(request.getParameter("price"));
					int quantity = Integer.parseInt(request.getParameter("quantity"));
					double iva = Double.parseDouble(request.getParameter("iva"));

					GeneralProductBean bean = new GeneralProductBean();
					
					bean.setNome(name);
					bean.setDescrizione(description);
					bean.setPrezzo(price);
					bean.setQuantitaDisponibile(quantity);
					bean.setIva(iva);
					
					if(quantity > 0){
						bean.setDisponibilita(true);
					}
					else{
						bean.setDisponibilita(false);
					}
						
					model.doSave(bean);
				}
			}
		} catch (SQLException e) {
			System.out.println("Error:" + e.getMessage());
		}

		String sort = request.getParameter("sort");
		
		
		try {
			request.removeAttribute("products");
			request.setAttribute("products", model.doRetrieveAll(sort));
		} catch (SQLException e) {
			System.out.println("Error:" + e.getMessage());
		}

		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/ProductView.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		doGet(request, response);
	}

	
}
