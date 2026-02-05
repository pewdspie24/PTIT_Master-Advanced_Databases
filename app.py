from flask import Flask, render_template
from config import Config
from models import db

# Initialize Flask app
app = Flask(__name__)
app.config.from_object(Config)

# Initialize database with app
db.init_app(app)

# Import routes after db initialization to avoid circular imports
from routes import customers, employees, meters, invoices, dashboard, contracts, salaries, pricing

# Register blueprints
app.register_blueprint(dashboard.bp)
app.register_blueprint(customers.bp)
app.register_blueprint(employees.bp)
app.register_blueprint(meters.bp)
app.register_blueprint(invoices.bp)
app.register_blueprint(contracts.bp)
app.register_blueprint(salaries.bp)
app.register_blueprint(pricing.bp)

@app.route('/')
def index():
    """Redirect to dashboard"""
    return dashboard.index()

@app.errorhandler(404)
def page_not_found(e):
    return render_template('errors/404.html'), 404

@app.errorhandler(500)
def internal_server_error(e):
    return render_template('errors/500.html'), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
