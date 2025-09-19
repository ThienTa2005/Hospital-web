/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */

import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author tn150
 */
@WebFilter(filterName = "RoleFilter", urlPatterns = {"/*"})
public class RoleFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response,FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest req=(HttpServletRequest) request;
        HttpServletResponse res=(HttpServletResponse) response;
        
       String path=req.getRequestURI();
       HttpSession session=req.getSession(false);
       
       if(path.endsWith("Login.jsp") || path.endsWith("Register.jsp") || path.endsWith("login") || path.endsWith("logout")
              || path.contains("/css/") || path.contains("/js/") || path.contains("/images/")){
          chain.doFilter(request,response);
          return;
       }
       
       if(session==null || session.getAttribute("user")==null){
           session=req.getSession();
           session.setAttribute("message","ban phai dang nhap de vao trang nay");
           res.sendRedirect(req.getContextPath()+"/Login.jsp");
           return;
       }
       
       String role=(String)session.getAttribute("role");
       
       if(path.contains("/admin/") && !"admin".equals(role)){
           req.setAttribute("message", "Trang nay la cua Admin");
           res.sendRedirect(req.getContextPath()+"/Login.jsp");
           return;
       }
       
       if(path.contains("/doctor/") && !"doctor".equals(role)){
           req.setAttribute("message", "Trang nay la cua Bac si");
           res.sendRedirect(req.getContextPath()+"/Login.jsp");
           return;
       }
       
       if(path.contains("/patient/") && !"patient".equals(role)){
           req.setAttribute("message", "Trang nay la cua Benh nhan");
           res.sendRedirect(req.getContextPath()+"/Login.jsp");  
           return;
       }
       
       chain.doFilter(request, response);
       
    }


 
    @Override
    public void destroy() {        
    }

    @Override
    public void init(FilterConfig filterConfig) {        
      
    }



    
}
