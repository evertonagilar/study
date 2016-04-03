

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.Enumeration;

public class MeuServlet extends javax.servlet.http.HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response){
		processar(request, response);
	}


	public void doPost(HttpServletRequest request, HttpServletResponse response){
		processar(request, response);


	}


	public void processar(HttpServletRequest request, HttpServletResponse response){
		try {
			PrintWriter out = response.getWriter();
	  		response.setContentType("text/html");
			

			/*out.println("Ola Servlet");
			String itsName = request.getParameter("myname");
			out.println("</br><h3>Its name is "+ itsName + "</h3>");
			int idade = Integer.parseInt(request.getParameter("idade"));
			out.println("</br><h3>Its idade is "+ idade + "</h3>");
			*/

			Enumeration params = request.getParameterNames();
			while (params.hasMoreElements()){
				String p = (String) params.nextElement();
				out.print("</br>" + p + " - " + request.getParameter(p));

			}




			out.print("</br>Method: "+ request.getMethod());
			out.print("</br>Context Path: "+ request.getContextPath());
			out.print("</br>Query String: "+ request.getQueryString());
			out.print("</br>Remote User: "+ request.getRemoteUser());
			out.print("</br>Request URL: "+ request.getRequestURL());
			out.print("</br>Request URI: "+ request.getRequestURI());
			out.print("</br>Servlet Path: "+ request.getServletPath());

				
			


			out.close();

		}
		catch (IOException e){
			System.err.println("Erro Erro Erro");
		}
	
	}

}
