package com.pharmacy.servlet;

import com.pharmacy.dao.MedicineDAO;
import com.pharmacy.model.Medicine;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class ManageMedicineServlet extends HttpServlet {
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
        RequestDispatcher rd = req.getRequestDispatcher("/WEB-INF/manage.jsp");
        rd.forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        String message;

        try {
            if ("add".equals(action)) {
                Medicine m = new Medicine(
                        0,
                        req.getParameter("name").trim(),
                        req.getParameter("manufacturer").trim(),
                        req.getParameter("sku").trim(),
                        new BigDecimal(req.getParameter("price").trim()),
                        Integer.parseInt(req.getParameter("stock").trim())
                );
                // Prevent duplicates by SKU
                if (dao.existsBySku(m.getSku())) {
                    message = "A medicine with SKU “" + m.getSku()
                            + "” already exists. Please use Edit.";
                } else {
                    boolean ok = dao.addMedicine(m);
                    message = ok ? "Added successfully." : "Failed to add.";
                }
            }
            else if ("deleteSku".equals(action)) {
                String sku = req.getParameter("skuDel").trim();
                boolean ok = dao.deleteBySku(sku);
                message = ok ? "Deleted SKU “" + sku + "”."
                        : "No medicine found with SKU “" + sku + "”.";
            }
            else if ("deleteName".equals(action)) {
                String name = req.getParameter("nameDel").trim();
                boolean ok = dao.deleteByName(name);
                message = ok ? "Deleted name “" + name + "”."
                        : "No medicine found named “" + name + "”.";
            }
            else if ("edit".equals(action)) {
                String lookupType  = req.getParameter("lookupType");
                String lookupValue = req.getParameter("lookupValue").trim();
                String newSku      = req.getParameter("newSku").trim();
                BigDecimal newPrice = new BigDecimal(req.getParameter("newPrice").trim());
                int newStock       = Integer.parseInt(req.getParameter("newStock").trim());

                boolean ok;
                if ("sku".equals(lookupType)) {
                    if (!dao.existsBySku(lookupValue)) {
                        message = "No medicine found with SKU “" + lookupValue + "”.";
                    } else {
                        ok = dao.updateMedicineBySku(lookupValue, newSku, newPrice, newStock);
                        message = ok ? "Updated successfully." : "Update failed.";
                    }
                } else {
                    if (!dao.existsByName(lookupValue)) {
                        message = "No medicine found named “" + lookupValue + "”.";
                    } else {
                        ok = dao.updateMedicineByName(lookupValue, newSku, newPrice, newStock);
                        message = ok ? "Updated successfully." : "Update failed.";
                    }
                }
            }
            else {
                message = "Unknown action.";
            }
        } catch (SQLException | NumberFormatException e) {
            message = "Error: " + e.getMessage();
        }

        req.setAttribute("message", message);
        doGet(req, res);
    }
}
