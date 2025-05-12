package com.pharmacy.servlet;

import com.pharmacy.dao.MedicineDAO;
import com.pharmacy.model.Medicine;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class MedicineServlet extends HttpServlet {
    private MedicineDAO dao;

    @Override
    public void init() {
        dao = new MedicineDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        List<Medicine> meds = dao.getAllMedicines();
        req.setAttribute("medicines", meds);

        RequestDispatcher rd = req.getRequestDispatcher("/WEB-INF/list.jsp");
        rd.forward(req, res);
    }
}
