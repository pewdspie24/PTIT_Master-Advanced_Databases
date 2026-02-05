# Electric Company Management System (Hệ thống Quản lý Điện lực)

A Flask-based web application for managing electric company operations including customers, employees, electric meters, and billing.

## 🎓 Academic Demo Project

This is a simplified demo application built for academic purposes using the recommended Python/Flask stack.

## 🛠️ Technology Stack

- **Backend**: Python 3.x + Flask 3.0
- **Database**: MySQL 8.4
- **ORM**: SQLAlchemy
- **Frontend**: Bootstrap 5 + Jinja2 Templates
- **Icons**: Bootstrap Icons

## 📋 Features

### Core Functionality
- ✅ **Customer Management** - Add, view, search, and edit customers
- ✅ **Employee Management** - List employees by role and branch
- ✅ **Electric Meter Management** - Track meters and consumption history
- ✅ **Invoice Management** - View invoices, payment status updates
- ✅ **Dashboard** - Overview statistics and quick actions

### Advanced Features (Based on app_query.sql)
- ✅ **Search customers** by ID, name, or phone number
- ✅ **Maintenance alerts** - Using stored procedure `sp_CanhBaoBaoTri()`
- ✅ **Overdue invoices** - Invoices >30 days unpaid
- ✅ **Abnormal consumption** detection - Meters with doubled usage
- ✅ **Bill calculation** - Using stored procedure `sp_TinhTienDien()`
- ✅ **Employee listing** by role (Manager, Accountant, Technician, Support)

## 📁 Project Structure

```
electric-company-app/
├── app.py                      # Main Flask application
├── config.py                   # Configuration settings
├── requirements.txt            # Python dependencies
├── .env.example                # Environment variables template
│
├── models/                     # Database models (SQLAlchemy)
│   ├── __init__.py
│   ├── customer.py             # KhachHang, SDT_KhachHang
│   ├── employee.py             # NhanVien and role models
│   ├── meter.py                # CongToDien, ChiSoDienHangThang
│   ├── invoice.py              # HoaDon
│   ├── contract.py             # HopDong
│   ├── branch.py               # ChiNhanh, KhuVuc
│   └── pricing.py              # BangGiaDien, BacGiaDien
│
├── routes/                     # Route handlers (Controllers)
│   ├── __init__.py
│   ├── dashboard.py            # Dashboard with statistics
│   ├── customers.py            # Customer CRUD operations
│   ├── employees.py            # Employee listing
│   ├── meters.py               # Meter management
│   └── invoices.py             # Invoice management
│
└── templates/                  # HTML templates (Jinja2)
    ├── base.html               # Base layout with navbar
    ├── dashboard/
    │   └── index.html          # Dashboard page
    └── customers/
        ├── list.html           # Customer list with search
        └── detail.html         # Customer details
```

## 🚀 Installation & Setup

### Prerequisites
- Python 3.8 or higher
- MySQL 8.4 (with your existing database dump loaded)
- pip (Python package manager)

### Step 1: Clone or Navigate to Project
```bash
cd /home/quang/Quang/Master/AdvancedDatabases/electric-company-app
```

### Step 2: Create Virtual Environment
```bash
python3 -m venv venv
source venv/bin/activate  # On Linux/Mac
# OR
venv\Scripts\activate  # On Windows
```

### Step 3: Install Dependencies
```bash
pip install -r requirements.txt
```

### Step 4: Configure Database
1. Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

2. Edit `.env` file with your MySQL credentials:
```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=QuanLyDienLuc_Final
SECRET_KEY=your-secret-key-for-sessions
```

### Step 5: Import Database (if not already done)
```bash
mysql -u root -p QuanLyDienLuc_Final < ../dump-QuanLyDienLuc_Final-202602031137.sql
```

### Step 6: Run the Application
```bash
python app.py
```

The application will start at: **http://localhost:5000**

## 📱 Usage

### Navigation
- **Dashboard** - `/dashboard/` - Overview and statistics
- **Customers** - `/customers/` - Customer management
- **Employees** - `/employees/` - Employee listing
- **Meters** - `/meters/` - Electric meter management
- **Invoices** - `/invoices/` - Invoice management

### Key Features Demonstration

#### 1. Search Customers
- Go to **Customers** page
- Enter customer ID, name, or phone in search box
- Implements the GROUP_CONCAT query from `app_query.sql`

#### 2. View Maintenance Alerts
- Dashboard → "Cảnh báo bảo trì" button
- Calls stored procedure: `sp_CanhBaoBaoTri()`
- Shows meters that need maintenance

#### 3. Check Overdue Invoices
- Dashboard → "Hóa đơn quá hạn" button
- Lists invoices unpaid for >30 days
- Shows customer contact information

#### 4. Detect Abnormal Consumption
- Dashboard → "Tiêu thụ bất thường" button
- Shows meters with doubled usage from previous month
- Helps detect potential meter issues

## 🗄️ Database Schema

The application uses the existing MySQL schema with **20+ tables**:

### Main Entities
- **KhachHang** (Customers)
- **NhanVien** (Employees) with specialized roles:
  - NhanVienQuanLy (Managers)
  - NhanVienLapDat (Technicians)
  - NhanVienHoTro (Support Staff)
  - KeToan (Accountants)
- **CongToDien** (Electric Meters)
- **ChiSoDienHangThang** (Monthly Readings)
- **HoaDon** (Invoices)
- **HopDong** (Contracts)
- **BangGiaDien / BacGiaDien** (Pricing Tiers)

### Stored Procedures Used
1. `sp_TinhTienDien` - Calculate electricity bill
2. `sp_CanhBaoBaoTri` - Maintenance alert system
3. `sp_BaoCaoTaiChinh` - Financial reporting

## 🎨 UI/UX Features

- **Responsive Design** - Works on desktop, tablet, and mobile
- **Bootstrap 5** - Professional, modern UI
- **Bootstrap Icons** - Visual feedback
- **Flash Messages** - Operation feedback (success/error)
- **Pagination** - For large datasets
- **Search Functionality** - Quick data lookup

## 🔧 Development Tips

### To add new features:

1. **Create a model** in `models/` directory
2. **Create routes** in `routes/` directory
3. **Create templates** in `templates/` directory
4. **Register blueprint** in `app.py`

### Example: Add a new page
```python
# routes/example.py
from flask import Blueprint, render_template

bp = Blueprint('example', __name__, url_prefix='/example')

@bp.route('/')
def index():
    return render_template('example/index.html')
```

## 🐛 Troubleshooting

### Database Connection Error
- Check `.env` file credentials
- Ensure MySQL server is running
- Verify database name exists

### Import Error
- Activate virtual environment: `source venv/bin/activate`
- Reinstall dependencies: `pip install -r requirements.txt`

### Template Not Found
- Check file path matches route render_template call
- Ensure templates are in `templates/` directory

## 📚 Learning Resources

- [Flask Documentation](https://flask.palletsprojects.com/)
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/)
- [Bootstrap 5 Documentation](https://getbootstrap.com/docs/5.3/)
- [Jinja2 Templates](https://jinja.palletsprojects.com/)

## 📝 License

This is an academic demo project. Free to use for educational purposes.

## 👨‍💻 Author

Created for Advanced Databases course demonstration.

---

**Note**: This is a simplified boilerplate. Additional templates (form.html, employees/list.html, etc.) can be created following the same pattern as the provided examples.
