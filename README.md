# Bloom Coffee Shop - Data Warehouse Project

## 🌟 Project Overview

The **Bloom Coffee Shop Data Warehouse** project is designed to organize, store, and analyze all operational and transactional data of a coffee shop in a structured and efficient way.  

This project allows the team to:  

- Track sales and revenue over time  
- Manage inventory and ingredients usage  
- Monitor staff schedules and performance  
- Analyze product popularity, promotions, and holiday effects  

By building a **star schema**, we ensure that reporting and analytics are easy, fast, and reliable.  

---

## 🏗️ Database Organization

The database `BloomCoffeeShop` contains **4 schemas**, each serving a specific purpose:

1. **Dim** – Contains all reference data:  
   - Items, staff, dates, holidays, promotions, shifts  

2. **Fact** – Contains transactional data:  
   - Fact_Orders table storing all order information  

3. **Inventory** – Contains stock levels:  
   - Inventory table tracking ingredient quantities  

4. **Mapping** – Contains relational/mapping tables:  
   - Recipe (links ingredients to items)  
   - Rota (links staff to shifts)  

---

## 🎯 Project Importance

- **Centralized data**: All information is stored in one place for easy access.  
- **Better decision-making**: Management can analyze sales, promotions, and employee performance.  
- **Operational efficiency**: Helps track stock usage, plan staff shifts, and prepare recipes accurately.  
- **Analytics-ready**: The star schema allows creating dashboards, reports, and trend analysis.  

---

## 📂 Additional Files

- `CuteCafe.drawio` – Visual diagram of the star schema  
- `promotions.py` – Python example to simulate promotions (optional for analysis)  

---

**Result:** A clean, organized, and maintainable data warehouse for **Bloom Coffee Shop**, ready for analytics, reporting, and operational insights.
