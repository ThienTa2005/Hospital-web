package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginServlet extends HttpServlet
{
    public void service(HttpServletRequest req, HttpServletResponse res) throws IOException
    {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        
        PrintWriter out = res.getWriter();
        out.println(username);
        out.println(password);
    }
}
