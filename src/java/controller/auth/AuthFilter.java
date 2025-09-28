package controller.auth;

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
import model.entity.User;

/**
 *
 * @author tn150
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/admin/*", "/doctor/*", "/patient/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI();
        HttpSession session = req.getSession(false);

        // 1. Các trang/public resource không cần filter
       if (path.endsWith("login.jsp") || path.endsWith("register.jsp") 
    || path.endsWith("login") || path.endsWith("logout") || path.endsWith("register")
    || path.endsWith("index.jsp") || path.endsWith("/") 
    || path.contains("about.jsp") || path.contains("contact.jsp")
    || path.contains("/css/") || path.contains("/js/") || path.contains("/images/")) {
    chain.doFilter(request, response);
    return;
}

        // 2. Kiểm tra login
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 3. Kiểm tra role
        User user = (User) session.getAttribute("user");
        String role = user.getRole();

        if (path.contains("/admin/") && !"admin".equals(role)) {
            req.getRequestDispatcher("/views/error/403.jsp").forward(req, res);
            return;
        }
        if (path.contains("/doctor/") && !"doctor".equals(role)) {
            req.getRequestDispatcher("/views/error/403.jsp").forward(req, res);
            return;
        }
        if (path.contains("/patient/") && !"patient".equals(role)) {
            req.getRequestDispatcher("/views/error/403.jsp").forward(req, res);
            return;
        }


        // 4. Cho phép đi tiếp
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) {}
    @Override
    public void destroy() {}
}