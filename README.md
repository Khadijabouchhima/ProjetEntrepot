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

## 🏗️ Database Architecture

The database `BloomCoffeeShop` is organized into **4 schemas**, each serving a specific purpose:

### 1. **Dim (Dimensions)** – Reference Data
- **Ingredients** - All coffee shop ingredients with pricing and measurements
- **Items** - Menu items (SKU, name, category, size, price)
- **Staff** - Employee information and hourly salary
- **Shift** - Work shift schedules (day, start time, end time)

### 2. **Fact** – Transactional Data
- **Orders** - All customer orders with timestamps, quantities, and customer details

### 3. **Inventory** – Stock Management
- **Inventory** - Current stock levels for all ingredients

### 4. **Mapping** – Relationships
- **Recipe** - Links ingredients to menu items with required quantities
- **Rota** - Links staff to their assigned shifts by date

---

## 📊 Database Structure

### Star Schema Design
```
                    Dim.Items
                         |
                         |
    Dim.Staff ----  Fact.Orders  ---- Dim.Ingredients
         |               |                    |
         |               |                    |
    Dim.Shift      Dim.Date           Inventory.Inventory
         |
         |
    Mapping.Rota ---- Mapping.Recipe
```

---

## 🎯 Project Importance

- **Centralized data**: All information is stored in one place for easy access  
- **Better decision-making**: Management can analyze sales, promotions, and employee performance  
- **Operational efficiency**: Helps track stock usage, plan staff shifts, and prepare recipes accurately  
- **Analytics-ready**: The star schema allows creating dashboards, reports, and trend analysis  

---

## 🚀 Getting Started

### Prerequisites
- SQL Server (tested on SQL Server 2019+)
- CSV files with proper encoding (Unix line endings: LF)

### Installation Steps

1. **Clone the repository**
```bash
git clone https://github.com/Khadijabouchhima/ProjetEntrepot.git
cd ProjetEntrepot
```

2. **Execute the main script**
   - Open `BloomCoffeeShop_Complete.sql` in SQL Server Management Studio (SSMS)
   - Update the file paths in the BULK INSERT sections to match your local directory
   - Execute the entire script

3. **Verify data import**
   - Each table includes a `SELECT *` statement to verify successful data import
   - Check that all 7 tables are populated with data

---

## 📁 Project Structure
```
ProjetEntrepot/
├── DataSet/                    # CSV source files
│   ├── ingredients.csv
│   ├── items.csv
│   ├── staff.csv
│   ├── shift.csv
│   ├── inventory.csv
│   ├── recipe.csv
│   ├── rota.csv
│   └── orders.csv
├── scripts/                    # Individual SQL scripts (archived)
├── CuteCafe.drawio            # Visual diagram of the star schema
├── promotions.py              # Python example for promotion simulation
├── BloomCoffeeShop_Complete.sql  # Main database creation script
└── README.md                  # This file
```

---

## 💾 Data Import Notes

### Important: CSV File Format
All CSV files use **Unix line endings (LF)** instead of Windows line endings (CRLF).  
This is why the BULK INSERT commands use:
```sql
ROWTERMINATOR = '0x0a'  -- Unix/Mac format
```

### Data Loading Process
The script follows this order to respect foreign key constraints:

1. **Dimensions first** (no dependencies):
   - Dim.Ingredients
   - Dim.Items
   - Dim.Staff
   - Dim.Shift

2. **Inventory** (depends on Ingredients):
   - Inventory.Inventory

3. **Mapping tables** (depend on Dimensions):
   - Mapping.Recipe
   - Mapping.Rota

4. **Fact table last** (depends on Items):
   - Fact.Orders

### Safe Re-import
Before each BULK INSERT, tables are cleared using:
- `DELETE FROM` - for tables with foreign key references
- `TRUNCATE TABLE` - for tables without dependencies (faster)

---

## 📈 Sample Queries

### Sales Analysis
```sql
-- Top selling items
SELECT 
    i.item_name,
    SUM(o.quantity) as total_sold,
    SUM(o.quantity * i.item_price) as revenue
FROM Fact.Orders o
JOIN Dim.Items i ON o.item_id = i.item_id
GROUP BY i.item_name
ORDER BY revenue DESC;
```

### Inventory Status
```sql
-- Low stock ingredients
SELECT 
    ing.ing_name,
    inv.quantity,
    ing.ing_meas
FROM Inventory.Inventory inv
JOIN Dim.Ingredients ing ON inv.ing_id = ing.ing_id
WHERE inv.quantity < 500
ORDER BY inv.quantity;
```

### Staff Schedule
```sql
-- Weekly staff schedule
SELECT 
    s.first_name + ' ' + s.last_name as staff_name,
    sh.day_of_week,
    sh.start_time,
    sh.end_time,
    r.date
FROM Mapping.Rota r
JOIN Dim.Staff s ON r.staff_id = s.staff_id
JOIN Dim.Shift sh ON r.shift_id = sh.shift_id
ORDER BY r.date, sh.start_time;
```

---

## 🛠️ Technical Details

### Database: `BloomCoffeeShop`
### Schemas: `Dim`, `Fact`, `Inventory`, `Mapping`
### Tables: 7 main tables + 2 mapping tables

### Key Features:
- ✅ Proper foreign key constraints
- ✅ Star schema design for analytics
- ✅ Automated data import via BULK INSERT
- ✅ Data validation with SELECT statements
- ✅ Safe re-import capabilities

---

## 📊 Additional Resources

- **Visual Schema**: Open `CuteCafe.drawio` with [draw.io](https://app.diagrams.net/) to view the complete database diagram
- **Promotions Script**: `promotions.py` demonstrates how to simulate promotional campaigns

---

## 👥 Contributors

- **Khadija Bouchhima** - *Initial work* - [GitHub Profile](https://github.com/Khadijabouchhima)

---

## 📝 License

This project is created for educational purposes.

---

## 🎓 Learning Outcomes

This project demonstrates:
- Data warehouse design principles
- Star schema implementation
- SQL Server database management
- ETL processes with BULK INSERT
- Foreign key constraint management
- Data integrity and validation

---

**Result:** A clean, organized, and maintainable data warehouse for **Bloom Coffee Shop**, ready for analytics, reporting, and operational insights. ☕📊
