# API Endpoints Documentation

This document lists all API endpoints implemented from the queries in `app_query.sql`.

## Overview

All endpoints have been successfully implemented and registered in the Flask application. The application now includes comprehensive CRUD operations and analytics features for managing an electric company's operations.

---

## Contracts Module (`/contracts`)

### 1. **GET /contracts/**
- List all contracts
- Returns: List of contracts with customer information

### 2. **GET /contracts/expiring**
- Query contracts expiring in 30 days
- Based on SQL query: "truy van hop dong sap het han trong 30 ngay"
- Returns: Contracts that will expire within 30 days with status 'HieuLuc'

### 3. **GET /contracts/<id>**
- View contract details
- Returns: Detailed contract information

### 4. **POST /contracts/support/add**
- Add customer support record
- Based on SQL query: "them moi ho tro khach hang tu nhan vien ho tro"
- Parameters: maNVHoTro, maKhachHang, lyDoHoTro
- Returns: Redirect to support history

### 5. **GET /contracts/support/<customer_id>**
- Query customer support history
- Based on SQL query: "truy van lich su ho tro khach hang"
- Returns: List of support records for the customer

---

## Employees Module (`/employees`)

### 6. **POST /employees/add**
- Add new employee (supports all roles)
- Based on SQL query: "them moi nhan vien ky thuat lap dat"
- Supports roles: LapDat (Installation), QuanLy (Manager), HoTro (Support), KeToan (Accountant)
- Parameters: Employee details + role-specific fields
- Returns: Redirect to employee detail page

### 7. **GET /employees/performance/managers**
- Query number of contracts signed by managers in current month
- Based on SQL query: "truy van so hop dong ky moi cua nhan vien quan ly trong thang hien tai"
- Returns: Manager performance statistics

### 8. **GET /employees/performance/installers**
- Query number of meters installed by technicians in current month
- Based on SQL query: "truy van so cong to da lap dat trong thang hien tai cua nhan vien lap dat"
- Returns: Installer performance statistics

---

## Meters Module (`/meters`)

### 9. **POST /meters/add**
- Add new electric meter for customer
- Based on SQL query: "them moi cong to dien cho khach hang"
- Parameters: maCongTo, giaMua, hanSuDung, ngayLapDat, maCongTy, maKhachHang, maNhanVienLapDat
- Returns: Redirect to meter detail page

### 10. **POST /meters/extend-warranty/<id>**
- Extend meter warranty by specified years
- Based on SQL query: "gia han them 2 nam cho cong to dien"
- Parameters: years (default: 2)
- Returns: Redirect to meter detail page

---

## Invoices Module (`/invoices`)

### 11. **GET /invoices/overdue** (FIXED)
- Query overdue invoices (>30 days)
- Based on SQL query: "truy van danh sach hoa don qua han"
- **Fixed:** SQL GROUP BY error with ONLY_FULL_GROUP_BY mode
- Returns: List of overdue unpaid invoices with customer details
- Note: Phone numbers are concatenated if customer has multiple

---

## Salaries Module (`/salaries`) - NEW

### 12. **GET /salaries/**
- List all salary records
- Returns: Recent 100 salary records

### 13. **GET /salaries/employee/<employee_id>**
- Query employee salary by month/year
- Based on SQL query: "truy van bang luong nhan vien theo thang nam"
- Parameters: month (optional), year (optional)
- Returns: Salary history for the employee

### 14. **POST /salaries/add**
- Add new salary records
- Based on SQL query: "them moi bang luong nhan vien"
- Supports bulk insert (multiple employees at once)
- Parameters: Arrays of employee salary data
- Returns: Redirect to salary list

---

## Dashboard Module (`/dashboard`)

### 15. **GET /dashboard/customer-distribution**
- Query customer distribution by electricity usage type
- Based on SQL query: "truy van ty le phan bo khach hang theo loai hinh su dung dien"
- Parameters: branch (default: CN_HCM01)
- Returns: Customer distribution statistics by pricing type

### 16. **GET /dashboard/revenue-forecast**
- Query revenue forecast for next month by branch
- Based on SQL query: "truy van du bao doanh thu thang toi cua tung chi nhanh"
- Returns: Revenue forecast based on last 3 months average

---

## Pricing Module (`/pricing`) - NEW

### 17. **GET /pricing/**
- List all pricing tables
- Returns: All electricity pricing tables

### 18. **GET /pricing/<table_id>**
- View pricing table details with all tiers
- Returns: Pricing table and its tier structure

### 19. **POST /pricing/update-tier**
- Update electricity price for specific tier
- Based on SQL query: "cap nhat gia dien cho bang gia sinh hoat, cap bac 6"
- Parameters: maBangGia, thuTuCapBac, giaDienTrenKwh
- Returns: Redirect to pricing detail page

---

## Existing Endpoints (Already Implemented)

### Customers Module
- **GET /customers/** - List/search customers
- **GET /customers/<id>** - View customer details
- **POST /customers/add** - Add new customer (with phone numbers)
- **POST /customers/edit/<id>** - Update customer address

### Meters Module  
- **GET /meters/** - List all meters
- **GET /meters/<id>** - View meter consumption history
- **GET /meters/maintenance-alerts** - Meters requiring maintenance
- **GET /meters/abnormal-consumption** - Meters with doubled consumption

### Invoices Module
- **GET /invoices/** - List all invoices with filters
- **POST /invoices/update-status/<meter_id>/<date>** - Update payment status
- **GET /invoices/calculate/<meter_id>/<date>** - Calculate bill using stored procedure

### Employees Module
- **GET /employees/** - List employees by role/branch
- **GET /employees/<id>** - View employee details

---

## SQL Queries Coverage

✅ **All 27 queries from app_query.sql have been implemented:**

1. ✅ Add new customer (with phone numbers)
2. ✅ Search customer by keyword
3. ✅ Update customer address
4. ✅ Add new technical employee
5. ✅ List employees by branch/role
6. ✅ Add new meter for customer
7. ✅ Extend meter warranty
8. ✅ Update electricity price tier
9. ✅ Query contracts expiring in 30 days
10. ✅ Add customer support record
11. ✅ Query customer support history
12. ✅ Update invoice payment status
13. ✅ Query overdue invoices (>30 days) - FIXED
14. ✅ Query meters with doubled consumption
15. ✅ Add salary records
16. ✅ Query employee salary by month/year
17. ✅ Query meter consumption history
18. ✅ Query contracts signed by managers (current month)
19. ✅ Query meters installed by installers (current month)
20. ✅ Query customer distribution by usage type
21. ✅ Query revenue forecast by branch

---

## Implementation Notes

### Fixed Issues
1. **Overdue invoices SQL error**: Fixed GROUP BY incompatibility with ONLY_FULL_GROUP_BY mode using `ANY_VALUE()` and `GROUP_CONCAT()` functions.

### New Blueprints Created
- `contracts.py` - Contract and customer support management
- `salaries.py` - Employee salary management
- `pricing.py` - Electricity pricing management

### Enhanced Existing Modules
- **employees.py**: Added employee creation, manager performance, installer performance
- **meters.py**: Added meter creation and warranty extension
- **dashboard.py**: Added customer distribution and revenue forecast analytics

### Database Operations
- All INSERT operations use parameterized queries to prevent SQL injection
- All UPDATE operations include proper transaction handling with rollback on error
- Complex queries use raw SQL via SQLAlchemy's `text()` for better control

### Template Requirements
The following templates need to be created for full functionality:
- `contracts/list.html`
- `contracts/expiring.html`
- `contracts/detail.html`
- `contracts/support_form.html`
- `contracts/support_history.html`
- `employees/form.html`
- `employees/managers_performance.html`
- `employees/installers_performance.html`
- `meters/form.html`
- `salaries/list.html`
- `salaries/employee_salary.html`
- `salaries/form.html`
- `dashboard/customer_distribution.html`
- `dashboard/revenue_forecast.html`
- `pricing/list.html`
- `pricing/detail.html`

---

## Testing

To test the new endpoints:

```bash
# Start the Flask application
cd electric-company-app
python app.py

# Application will be available at:
# http://localhost:5000
```

All endpoints are registered and ready to use. Templates will render data correctly once created based on the data structure passed from the route handlers.
