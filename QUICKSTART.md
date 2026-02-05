# Quick Start Guide

## 🚀 Get Started in 5 Minutes

### 1. Install Dependencies
```bash
cd electric-company-app
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 2. Configure Database
```bash
cp .env.example .env
nano .env  # Edit with your MySQL credentials
```

### 3. Run Application
```bash
python app.py
```

### 4. Open Browser
Visit: **http://localhost:5000/dashboard/**

## 📝 Sample .env Configuration

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=QuanLyDienLuc_Final
SECRET_KEY=my-secret-key-123
```

## ✅ Test the Application

### Without Data (Empty Database)
The app will show:
- Dashboard with 0 counts
- Empty tables
- All navigation works

### With Data (After loading dump)
```bash
# Load your database dump first
mysql -u root -p QuanLyDienLuc_Final < ../dump-QuanLyDienLuc_Final-202602031137.sql

# Then run the app
python app.py
```

## 🎯 Key URLs to Test

- Dashboard: http://localhost:5000/dashboard/
- Customers: http://localhost:5000/customers/
- Employees: http://localhost:5000/employees/
- Meters: http://localhost:5000/meters/
- Invoices: http://localhost:5000/invoices/
- Maintenance Alerts: http://localhost:5000/meters/maintenance-alerts
- Overdue Invoices: http://localhost:5000/invoices/overdue
- Abnormal Consumption: http://localhost:5000/meters/abnormal-consumption

## 🔧 Common Issues

### Port 5000 already in use?
Edit `app.py`, change:
```python
app.run(debug=True, host='0.0.0.0', port=8000)  # Use port 8000
```

### MySQL Connection Error?
1. Check MySQL is running: `sudo systemctl status mysql`
2. Verify credentials in `.env`
3. Test connection: `mysql -u root -p`

### Import Errors?
Make sure virtual environment is activated:
```bash
source venv/bin/activate
```

## 📚 Next Steps

1. **Add more templates** - Copy pattern from `customers/list.html`
2. **Add forms** - Create `customers/form.html` for add/edit
3. **Add more features** - Follow structure in `routes/customers.py`
4. **Customize UI** - Edit `templates/base.html` for branding

## 💡 Development Mode

The app runs in **debug mode** by default:
- Auto-reloads on code changes
- Shows detailed error pages
- SQL queries printed to console

For production, set in `app.py`:
```python
app.run(debug=False)
```

---

**Happy Coding! 🎉**
