from flask import Flask, request, jsonify, send_file
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt  # Import Bcrypt for password hashing
from sqlalchemy.orm import class_mapper, ColumnProperty
from sqlalchemy.orm.attributes import InstrumentedAttribute
from sqlalchemy import func
from sqlalchemy import text
from sqlalchemy import Integer
import os
from werkzeug.utils import secure_filename
from transformers import pipeline, AutoModelForSequenceClassification, AutoTokenizer

import smtplib
import random
import base64
import os
import uuid
from flask_restful import Api
from datetime import datetime, timedelta
from textblob import TextBlob

import pymysql
pymysql.install_as_MySQLdb()

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://saipavantm:8595@192.168.121.210/sentibites'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'saipavan'
bcrypt = Bcrypt(app)

db = SQLAlchemy(app)

UPLOAD_FOLDER = "C:/Users/saipa/Downloads/sentibites_images"
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


#----------------------------------------api calls here---------------------------------------------------------------
class userdetails(db.Model):
    email = db.Column(db.String(255), primary_key=True)  # Use email as the primary key
    name = db.Column(db.String(100), nullable=False)
    password = db.Column(db.String(255), nullable=False)  # Changed to match the table def  ion
    mobilenumber = db.Column(db.String(15), nullable=False)
    dob = db.Column(db.Date, nullable=False)

# Route for user signup
@app.route('/signup', methods=['POST'])
def signup():
    try:
        data = request.json
        name = data.get('name')
        email = data.get('email')
        password = data.get('password')
        mobilenumber = data.get('mobilenumber')
        dob = data.get('dob')

        # Check if all fields are provided
        if not all([name, email, password, mobilenumber, dob]):
            return jsonify({'message': 'All fields are required'}), 400

        # Check if the user already exists
        if userdetails.query.filter_by(email=email).first():
            return jsonify({'message': 'User already exists'}), 409

        # Hash the password
        password_hash = bcrypt.generate_password_hash(password).decode('utf-8')

        # Create a new user instance
        new_user = userdetails(
            name=name,
            email=email,
            password=password_hash,  # Use password field from the SQL table definition
            mobilenumber=mobilenumber,
            dob=dob
        )

        # Add the user to the database
        db.session.add(new_user)
        db.session.commit()

        return jsonify({'message': 'User registered successfully'}), 201

    except Exception as e:
        print(f"Error in signup endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

# Route for user login
@app.route('/login', methods=['POST'])
def login():
    try:
        data = request.json
        email = data.get('email')
        password = data.get('password')

        # Check if email and password are provided
        if not email or not password:
            return jsonify({'message': 'Email and password are required'}), 400

        # Find the user by email
        user = userdetails.query.filter_by(email=email).first()

        if not user:    
            return jsonify({'message': 'User not found'}), 404  # User does not exist

        # Check the password
        if bcrypt.check_password_hash(user.password, password):  # Use password field
            return jsonify({'message': 'Login successful'}), 200  # Successful login
        else:
            return jsonify({'message': 'Incorrect password'}), 401  # Password mismatch

    except Exception as e:
        print(f"Error in login endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

class ownerlogin(db.Model):
    email = db.Column(db.String(255), primary_key=True)  # Use email as the primary key
    password = db.Column(db.String(255), nullable=False)  # Store the hashed password
    name = db.Column(db.String(100), nullable=True)  # New column for owner's name
    contact = db.Column(db.String(15), nullable=True)  # New column for contact number
    dob = db.Column(db.String, nullable=True)

@app.route('/ownerlogin', methods=['POST'])
def ownerlogin_route():
    try:
        data = request.json
        email = data.get('email')
        password = data.get('password')
        name = data.get('name')  # New field
        contact = data.get('contact')  # New field
        dob = data.get('dob')  # New field

        if not email or not password:
            return jsonify({'message': 'Email and password are required'}), 400

        # Find the owner by email
        owner = ownerlogin.query.filter_by(email=email).first()

        if not owner:
            # If owner does not exist, create a new owner
            password_hash = bcrypt.generate_password_hash(password).decode('utf-8')  # Hash the password

            # Create a new owner instance with new columns
            new_owner = ownerlogin(
                email=email,
                password=password_hash,
                name=name,  # Store the name
                contact=contact,  # Store the contact number
                dob=dob  # Store the date of birth
            )

            # Add the new owner to the database
            db.session.add(new_owner)
            db.session.commit()

            return jsonify({'message': 'Owner created and login successful'}), 201  # Return success for creation

        # Check if the password hash is valid
        if bcrypt.check_password_hash(owner.password, password):  # Correct bcrypt check
            return jsonify({'message': 'Owner login successful'}), 200  # Successful login

        return jsonify({'message': 'Incorrect password'}), 401  # Incorrect password

    except Exception as e:
        print(f"Error in owner login endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500



@app.route('/owner/forgot-password', methods=['POST'])
def forgot_password():
    try:
        data = request.json
        email = data.get('email')
        old_password = data.get('old_password')
        new_password = data.get('new_password')
        confirm_new_password = data.get('confirm_new_password')

        # Check if all fields are provided
        if not all([email, old_password, new_password, confirm_new_password]):
            return jsonify({'message': 'All fields are required'}), 400

        # Check if the new password and confirmation password match
        if new_password != confirm_new_password:
            return jsonify({'message': 'New password and confirmation do not match'}), 400

        # Find the owner by email
        owner = ownerlogin.query.filter_by(email=email).first()

        if not owner:
            return jsonify({'message': 'Owner not found'}), 404  # Owner does not exist

        # Check if the old password is correct
        if bcrypt.check_password_hash(owner.password, old_password):
            # Hash the new password
            new_password_hash = bcrypt.generate_password_hash(new_password).decode('utf-8')

            # Update the password in the database
            owner.password = new_password_hash
            db.session.commit()

            return jsonify({'message': 'Password updated successfully'}), 200  # Password updated
        else:
            return jsonify({'message': 'Incorrect old password'}), 401  # Incorrect old password

    except Exception as e:
        print(f"Error in forgot password endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

class OwnerAddItems(db.Model):
    id = db.Column(db.Integer, primary_key=True)  # Auto-incrementing primary key
    name = db.Column(db.String(255), nullable=False)
    price = db.Column(db.Float, nullable=False)
    category = db.Column(db.String(100), nullable=False)
    image = db.Column(db.String(255), nullable=True)  # Path or URL to the image
    description = db.Column(db.Text, nullable=True)

@app.route('/owner/items', methods=['POST'])
def add_item():
    try:
        # Check if image is in the request
        if 'image' not in request.files:
            return jsonify({'message': 'Image file is required'}), 400

        file = request.files['image']

        # Validate file
        if file.filename == '':
            return jsonify({'message': 'No selected file'}), 400
        if not allowed_file(file.filename):
            return jsonify({'message': 'Invalid file type'}), 400

        # Secure and save the file
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)

        # Retrieve other data from JSON
        data = request.form
        name = data.get('name')
        price = data.get('price')
        category = data.get('category')
        description = data.get('description')

        # Check required fields
        if not all([name, price, category]):
            return jsonify({'message': 'Name, price, and category are required'}), 400

        # Create a new item instance
        new_item = OwnerAddItems(
            name=name,
            price=float(price),
            category=category,
            image=filepath,  # Save the file path in the database
            description=description
        )

        # Add to the database
        db.session.add(new_item)
        db.session.commit()

        return jsonify({'message': 'Item added successfully'}), 201

    except Exception as e:
        print(f"Error in add_item endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/owner/change-price', methods=['POST'])
def change_price():
    try:
        data = request.json
        name = data.get('name')
        category = data.get('category')
        new_price = data.get('new_price')

        # Check if all fields are provided
        if not all([name, category, new_price]):
            return jsonify({'message': 'Name, category, and new price are required'}), 400

        # Query the item to be updated by name and category
        item = OwnerAddItems.query.filter_by(name=name, category=category).first()

        if not item:
            return jsonify({'message': 'Item not found'}), 404  # If item doesn't exist

        # Update the price
        item.price = float(new_price)
        db.session.commit()

        return jsonify({'message': 'Price updated successfully'}), 200

    except Exception as e:
        print(f"Error in change_price endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

class OwnerAcceptOrder(db.Model):
    __tablename__ = 'owner_accept_order'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    order_no = db.Column(db.String, unique=True, nullable=False)
    status = db.Column(db.String, default='pending')  # Default status if not provided
    reverted = db.Column(db.Integer, default=0)  # Default reverted value if not provided


@app.route('/owner/accept-order', methods=['POST'])
def accept_order():
    try:
        data = request.json
        order_no = data.get('order_no')
        status = data.get('status')

        if not order_no or not status:
            return jsonify({'message': 'Order number and status are required'}), 400

        # Find the order by its order_no
        order = OwnerAcceptOrder.query.filter_by(order_no=order_no).first()

        if not order:
            return jsonify({'message': 'Order not found'}), 404  # Order does not exist

        print(f"Updating order {order_no} with status {status}")  # Add logging

        # Check if the status is 'Accepted' and update it
        if status == 'Accepted':
            order.status = 'Accepted'
        elif status == 'Rejected':
            order.status = 'Rejected'
        else:
            return jsonify({'message': 'Invalid status provided'}), 400

        # Commit the changes to the database
        db.session.commit()

        return jsonify({'message': 'Order updated successfully', 'order_no': order_no}), 200
    except Exception as e:
        print(f"Error occurred: {e}")  # Add error logging
        return jsonify({'message': 'Error occurred while processing the request', 'error': str(e)}), 500

class AdminLogin(db.Model):
    email = db.Column(db.String(255), primary_key=True)  # Use email as the primary key
    password = db.Column(db.String(255), nullable=False)  # Store the hashed password

@app.route('/admin/login', methods=['POST'])
def admin_login():
    try:
        data = request.json
        email = data.get('email')
        password = data.get('password')

        if not email or not password:
            return jsonify({'message': 'Email and password are required'}), 400

        admin = AdminLogin.query.filter_by(email=email).first()

        if not admin:
            return jsonify({'message': 'Admin not found'}), 404

        try:
            if bcrypt.check_password_hash(admin.password, password):
                return jsonify({'message': 'Admin login successful'}), 200
        except ValueError:
            password_hash = bcrypt.generate_password_hash(password).decode('utf-8')
            admin.password = password_hash
            db.session.commit()
            return jsonify({'message': 'Password rehashed and login successful'}), 200

        return jsonify({'message': 'Incorrect password'}), 401

    except Exception as e:
        print(f"Error in admin login endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/admin/forgot-password', methods=['POST'])
def admin_forgot_password():
    try:
        data = request.json
        email = data.get('email')
        old_password = data.get('old_password')
        new_password = data.get('new_password')
        confirm_new_password = data.get('confirm_new_password')

        # Check if all fields are provided
        if not all([email, old_password, new_password, confirm_new_password]):
            return jsonify({'message': 'All fields are required'}), 400

        # Check if the new password and confirmation password match
        if new_password != confirm_new_password:
            return jsonify({'message': 'New password and confirmation do not match'}), 400

        # Find the admin by email
        admin = AdminLogin.query.filter_by(email=email).first()

        if not admin:
            return jsonify({'message': 'Admin not found'}), 404  # Admin does not exist

        # Check if the old password is correct
        if bcrypt.check_password_hash(admin.password, old_password):
            # Hash the new password
            new_password_hash = bcrypt.generate_password_hash(new_password).decode('utf-8')

            # Update the password in the database
            admin.password = new_password_hash
            db.session.commit()

            return jsonify({'message': 'Password updated successfully'}), 200  # Password updated
        else:
            return jsonify({'message': 'Incorrect old password'}), 401  # Incorrect old password

    except Exception as e:
        print(f"Error in admin forgot password endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

class admin_users(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)  # Auto-incrementing primary key
    name = db.Column(db.String(255), nullable=False)  # User's name
    email = db.Column(db.String(255), unique=True, nullable=False)  # Email (unique identifier)
    contact = db.Column(db.String(15), nullable=False)  # Contact number
    dob = db.Column(db.String(15), nullable=False)  # Date of Birth
    status = db.Column(db.String(50), nullable=False, default='active')

@app.route('/admin/users_post', methods=['POST'])
def signups():
    data = request.get_json()  # Get data from the request body
    print(request.json)
    name = data.get('name')
    email = data.get('email')
    contact = data.get('contact')
    dob = data.get('dob')

    # Check if all required fields are provided
    if not name or not email or not contact or not dob:
        return jsonify({'message': 'Missing required fields'}), 400

    # Check if the email is already registered
    existing_user = admin_users.query.filter_by(email=email).first()
    if existing_user:
        return jsonify({'message': 'Email already registered'}), 400

    # Add the new user to the database
    new_user = admin_users(
        name=name,
        email=email,
        contact=contact,
        dob=dob
    )

    try:
        db.session.add(new_user)
        db.session.commit()
        return jsonify({'message': 'User successfully registered'}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'message': f'Error: {str(e)}'}), 500
    
@app.route('/admin/users', methods=['POST'])
def update_status():
    try:
        # Get email and status from the request body
        data = request.json
        email = data.get('email')
        status = data.get('status')

        if not email or not status:
            return jsonify({'error': 'Email and status are required.'}), 400

        # Find the user by email
        user = admin_users.query.filter_by(email=email).first()

        if not user:
            return jsonify({'error': 'User not found.'}), 404

        # Update the status
        user.status = status
        db.session.commit()

        return jsonify({'message': f"User {email}'s status updated to {status}."}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
class admin_owners(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)  # Auto-incrementing primary key
    name = db.Column(db.String(255), nullable=False)  # User's name
    email = db.Column(db.String(255), unique=True, nullable=False)  # Email (unique identifier)
    contact = db.Column(db.String(15), nullable=False)  # Contact number
    dob = db.Column(db.Date, nullable=False)  # Date of Birth
    status = db.Column(db.String(50), nullable=False, default='active')

@app.route('/admin/owners', methods=['POST'])
def update_owner_status():
    try:
        # Get email and status from the request body
        data = request.json
        email = data.get('email')
        status = data.get('status')

        if not email or not status:
            return jsonify({'error': 'Email and status are required.'}), 400

        # Find the owner by email
        owner = admin_owners.query.filter_by(email=email).first()

        if not owner:
            return jsonify({'error': 'Owner not found.'}), 404

        # Update the status
        owner.status = status
        db.session.commit()

        return jsonify({'message': f"Owner {email}'s status updated to {status}."}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

MODEL = AutoModelForSequenceClassification.from_pretrained("C:/Users/saipa/Downloads/sentiment_analysis")
TOKENIZER = AutoTokenizer.from_pretrained("C:/Users/saipa/Downloads/sentiment_analysis")
PIPELINE = pipeline("sentiment-analysis", model=MODEL, tokenizer=TOKENIZER)

def analysis(input_text):
    result = PIPELINE(input_text)
    label = result[0]['label']
    return label.capitalize()


class owner_mexican(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    reviews = db.Column(db.Text, nullable=False)

@app.route('/owner/mexican', methods=['GET'])
def analyze_reviews():
    try:
        # Fetch all reviews from the database
        reviews = owner_mexican.query.all()

        if not reviews:
            return jsonify({'message': 'No reviews found'}), 404

        # Initialize sentiment counters
        pos, neu, neg = 0, 0, 0

        # Analyze each review
        for review in reviews:
            sentiment = analysis(review.reviews)
            if sentiment == "Positive":
                pos += 1
            elif sentiment == "Negative":
                neg += 1
            else:
                neu += 1

        # Return the sentiment counts
        return jsonify({
            'positive': pos,
            'neutral': neu,
            'negative': neg
        }), 200

    except Exception as e:
        print(f"Error in analyze_reviews endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/get_add_details', methods=['GET'])
def get_add_details():
    try:
        # Query all items from the OwnerAddItems table
        items = OwnerAddItems.query.all()

        # Convert the items to a list of dictionaries for JSON response
        items_list = [
            {
                'name': item.name,
                'price': item.price,
                'category': item.category,
                'image': item.image,
                'description': item.description,
            }
            for item in items
        ]

        return jsonify({'items': items_list}), 200

    except Exception as e:
        print(f"Error in /add_details endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/add_mexican_review', methods=['POST'])
def add_mexican_review():
    try:
        # Get the review from the request
        data = request.json
        reviews = data.get('reviews')

        # Check if the review is provided
        if not reviews:
            return jsonify({'message': 'Review is required'}), 400

        # Create a new review entry in the `owner_mexican` table
        new_review = owner_mexican(reviews=reviews)

        # Add the review to the database
        db.session.add(new_review)
        db.session.commit()

        return jsonify({'message': 'Review added successfully'}), 201

    except Exception as e:
        print(f"Error in add_mexican_review endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/fetch_user_mexican', methods=['GET'])
def get_reviews():
    try:
        # Query all reviews f   rom the owner_mexican table
        reviews = owner_mexican.query.all()
        
        # Create a list to store the reviews in dictionary format
        reviews_list = [{"review": reviews.reviews} for reviews in reviews]
        
        # Return the reviews as JSON
        return jsonify({"reviews": reviews_list}), 200
    except Exception as e:
        # In case of error, return a JSON error message
        return jsonify({"error": str(e)}), 500

@app.route('/ownerlogin', methods=['GET'])
def add_owner():
    try:
        # Get query parameters
        email = request.args.get('email')
        password = request.args.get('password')

        # Ensure both email and password are provided
        if not email or not password:
            return jsonify({'message': 'Email and password are required'}), 400

        # Find the owner by email
        owner = ownerlogin.query.filter_by(email=email).first()

        if not owner:
            return jsonify({'message': 'Owner not found'}), 404

        # Return the owner's email and a success message
        return jsonify({
            'email': owner.email,
            'password': owner.password,  # Optional: Include hashed password for verification purposes
            'message': 'Owner details retrieved successfully'
        }), 200

    except Exception as e:
        return jsonify({'message': 'An error occurred', 'error': str(e)}), 500

@app.route('/addownerlogin', methods=['POST'])
def add_owner_login():
    try:
        # Get the data from the request body (as JSON)
        data = request.json
        email = data.get('email')
        password = data.get('password')
        name = data.get('name')
        contact = data.get('contact')
        dob = data.get('dob')

        # Ensure that all required fields are provided
        if not email or not password or not name or not contact or not dob:
            return jsonify({'message': 'Email, password, name, contact, and date of birth are required'}), 400

        # Check if the email already exists
        existing_owner = ownerlogin.query.filter_by(email=email).first()

        if existing_owner:
            return jsonify({'message': 'Owner with this email already exists'}), 409  # Conflict, email exists

        # Hash the password before storing
        hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')

        # Create a new owner and add to the database
        new_owner = ownerlogin(
            email=email,
            password=hashed_password,  # Store the hashed password
            name=name,
            contact=contact,
            dob=dob  # Keep dob as text
        )

        # Add the new owner to the database
        db.session.add(new_owner)
        db.session.commit()

        return jsonify({'message': 'Owner added successfully'}), 201  # Success

    except Exception as e:
        return jsonify({'message': 'An error occurred', 'error': str(e)}), 500




@app.route('/fetch/admin/users', methods=['GET'])
def fetch_admin_users():
    try:
        # Fetch all user details from the database
        users = userdetails.query.all()

        # Create a list of user details
        users_data = []
        for user in users:
            users_data.append({
                'name': user.name,
                'email': user.email,
                'mobilenumber': user.mobilenumber,
                'dob': user.dob
            })

        return jsonify({'users': users_data}), 200  # Success

    except Exception as e:
        return jsonify({'message': 'An error occurred', 'error': str(e)}), 500

@app.route('/post/admin/users', methods=['POST'])
def post_admin_users():
    try:
        # Extract data from the request body
        data = request.json
        
        # Get details from the JSON payload
        name = data.get('name')
        email = data.get('email')
        contact = data.get('contact')
        dob = data.get('dob')
        status = data.get('status', 'active')  # Default status if not provided
        
        # Validate required fields
        if not all([name, email, contact, dob]):
            return jsonify({'message': 'All fields (name, email, contact, dob) are required'}), 400

        # Insert into admin_users table
        new_admin_user = admin_users(
            name=name,
            email=email,
            contact=contact,
            dob=dob,
            status=status
        )
        db.session.add(new_admin_user)
        db.session.commit()

        return jsonify({'message': 'Admin user added successfully'}), 201

    except Exception as e:
        return jsonify({'message': 'An error occurred', 'error': str(e)}), 500

@app.route('/get/admin/users/status', methods=['GET'])
def get_admin_users_status():
    try:
        # Query to fetch email and status fields from the admin_users table
        users_status = admin_users.query.with_entities(admin_users.email, admin_users.status).all()

        # If no users are found
        if not users_status:
            return jsonify({'message': 'No users found'}), 404

        # Format the response as a list of dictionaries
        status_list = [{'email': user.email, 'status': user.status} for user in users_status]

        return jsonify({'users_status': status_list}), 200

    except Exception as e:
        return jsonify({'message': 'An error occurred', 'error': str(e)}), 500

@app.route('/check_credentials', methods=['POST'])
def check_credentials():
    try:
        data = request.json
        email = data.get('email')
        password = data.get('password')

        print(f"Received email: {email}, password: {password}")  # Debug line

        if not email or not password:
            return jsonify({'message': 'Email and password are required'}), 400

        # Find the owner by email
        owner = ownerlogin.query.filter_by(email=email).first()

        if not owner:
            return jsonify({'message': 'Owner not found'}), 404

        if bcrypt.check_password_hash(owner.password, password):
            return jsonify({'message': 'Credentials are correct'}), 200
        else:
            return jsonify({'message': 'Incorrect password'}), 401

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/fetch_all_owners', methods=['GET'])
def fetch_all_owners():
    # Fetch all owners from the database
    owners = ownerlogin.query.all()

    if owners:
        # Prepare a list of owner data to return
        owner_data = [{
            'name': owner.name,
            'email': owner.email,
            'contact': owner.contact,
            'dob': owner.dob
        } for owner in owners]

        return jsonify(owner_data), 200
    else:
        return jsonify({'message': 'No owners found'}), 404
    

@app.route('/add_owner_new', methods=['POST'])
def add_owners():
    data = request.get_json()

    # Extract the details from the request data
    name = data.get('name')
    email = data.get('email')
    contact = data.get('contact')
    dob = data.get('dob')
    
    if not name or not email or not contact or not dob:
        return jsonify({"error": "All fields are required"}), 400

    # Create a new owner instance
    new_owner = admin_owners(name=name, email=email, contact=contact, dob=dob)

    # Add the owner to the database
    db.session.add(new_owner)
    db.session.commit()

    return jsonify({"message": "Owner added successfully!"}), 201

@app.route('/admin/owner-status', methods=['GET'])
def fetch_all_owner_statuses():
    try:
        owners = admin_owners.query.all()  # Fetch all records from the database
        result = [
            {'email': owner.email, 'status': owner.status}
            for owner in owners
        ]
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

class Cart(db.Model):
    __tablename__ = 'cart'
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(255), nullable=False)
    category = db.Column(db.String(255), nullable=False)
    price = db.Column(db.Float, nullable=False)
    description = db.Column(db.Text, nullable=True)
    quantity = db.Column(db.Integer, default=1)
    status = db.Column(db.String(50), default='active')

@app.route('/cart/add', methods=['POST'])
def create_or_update_cart_item():
    try:
        data = request.get_json()  # Get data from the request body

        # Validate required fields
        if not all(key in data for key in ['name', 'category', 'price', 'quantity']):
            return jsonify({'error': 'Missing required fields'}), 400

        # Check if item already exists in the cart based on 'name'
        existing_cart_item = Cart.query.filter_by(name=data['name']).first()
        
        if existing_cart_item:
            # If it exists, reset the quantity to the newly selected value
            existing_cart_item.quantity = data['quantity']
            existing_cart_item.status = 'active'  # Ensure status is active
            db.session.commit()
            return jsonify({'message': 'Cart item updated successfully'}), 200
        else:
            # If it doesn't exist, create a new cart item
            new_cart_item = Cart(
                name=data['name'],
                category=data['category'],
                price=data['price'],
                description=data.get('description', ''),
                quantity=data['quantity'],
                status='active'
            )
            db.session.add(new_cart_item)
            db.session.commit()
            return jsonify({'message': 'Cart item added successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/cart/fetch', methods=['GET'])
def get_cart_items():
    try:
        # Fetch all active cart items
        cart_items = Cart.query.filter_by(status='active').all()

        # Create a list of dictionaries to send as JSON response
        cart_items_list = []
        for item in cart_items:
            cart_items_list.append({
                'id': item.id,
                'name': item.name,
                'category': item.category,
                'price': item.price,
                'description': item.description,
                'quantity': item.quantity,
                'status': item.status
            })

        # Return the cart items as JSON
        return jsonify({'cart_items': cart_items_list}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

class CartPrice(db.Model):
    __tablename__ = 'cart_price'
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    total = db.Column(db.Float, nullable=False)

@app.route('/cart/total_price/post', methods=['POST'])
def post_total_price():
    try:
        # Get the total price from the request
        data = request.get_json()
        total_price = data.get('total_price')

        if total_price is None:
            return jsonify({"error": "Total price not provided"}), 400

        # Insert the total price into the CartPrice table
        new_cart_price = CartPrice(total=total_price)
        db.session.add(new_cart_price)
        db.session.commit()

        # Send a success response
        return jsonify({"message": "Total price saved successfully", "total_price": total_price}), 200

    except Exception as e:
        db.session.rollback()  # Rollback any transaction in case of an error
        return jsonify({"error": str(e)}), 500

@app.route('/cart/total_price/fetch', methods=['GET'])
def get_last_cart_price():
    # Fetch the last entry (the one with the highest ID)
    last_price = CartPrice.query.order_by(CartPrice.id.desc()).first()
    
    if last_price:
        return jsonify({'id': last_price.id, 'price': last_price.total})
    else:
        return jsonify({'message': 'No data available'}), 404

@app.route('/cart/update_status', methods=['POST'])
def update_cart_status():
    try:
        cart_names = request.json.get('cart_names', [])
        
        if not cart_names:
            return jsonify({"error": "No cart items provided"}), 400

        print(f"Received cart names: {cart_names}")  # Debugging statement
        
        # Log all cart names from the database
        all_cart_items = Cart.query.all()
        print("All cart items in database:")
        for item in all_cart_items:
            print(item.name)

        cart_items = Cart.query.filter(Cart.name.in_(cart_names)).all()

        if not cart_items:
            print("No matching cart items found")  # Debugging statement
            return jsonify({"error": "No matching cart items found"}), 404

        for item in cart_items:
            item.status = 'completed'

        db.session.commit()
        return jsonify({"message": "Cart status updated to completed"}), 200
    except Exception as e:
        db.session.rollback()
        print(f"Error: {e}")  # Debugging statement
        return jsonify({"error": str(e)}), 500

@app.route('/cart/fetch2', methods=['GET'])
def get_cart_items2():
    try:
        # Fetch all active cart items
        cart_items = Cart.query.filter_by(status='active').all()

        # Create a list of cart names (if only names are needed)
        cart_names_list = [item.name for item in cart_items]

        # Return the cart names as JSON
        return jsonify({'cart_names': cart_names_list}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/cart/fetch/completed', methods=['GET'])
def get_cart_items_completed():
    try:
        # Fetch all active cart items
        cart_items = Cart.query.filter_by(status='completed').all()

        # Create a list of dictionaries to send as JSON response
        cart_items_list = []
        for item in cart_items:
            cart_items_list.append({
                'id': item.id,
                'name': item.name,
                'category': item.category,
                'price': item.price,
                'description': item.description,
                'quantity': item.quantity,
                'status': item.status
            })

        # Return the cart items as JSON
        return jsonify({'cart_items': cart_items_list}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/add_order', methods=['POST'])
def add_order():
    data = request.get_json()  # Get the data from the request
    
    if 'order_no' not in data:
        return jsonify({'message': 'order_no is required'}), 400

    order_no = data['order_no']
    status = 'pending'  
    reverted = 0  

    try:
        # Create a new order with the provided order_no and default values for status and reverted
        new_order = OwnerAcceptOrder(order_no=order_no, status=status, reverted=reverted)
        
        # Add the new order to the session and commit
        db.session.add(new_order)
        db.session.commit()
        
        return jsonify({'message': f'Order {order_no} added successfully'}), 201
    except Exception as e:
        db.session.rollback()  # Rollback if there's an error
        return jsonify({'message': 'Failed to add order'}), 500

@app.route('/fetch_all_orders', methods=['GET'])
def fetch_all_orders():
    # Query all orders from the database
    orders = OwnerAcceptOrder.query.all()

    if orders:
        # If orders are found, return the list of order_no and status
        order_list = []
        for order in orders:
            order_list.append({
                'order_no': order.order_no,
                'status': order.status
            })
        return jsonify(order_list)
    else:
        # If no orders are found, return a message indicating no orders are available
        return jsonify({'message': 'No orders found'}), 404

class burger(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    reviews = db.Column(db.String(500), nullable=False)

@app.route('/fetch_burger_reviews', methods=['GET'])
def fetch_burger_reviews():
    # Query all burger reviews from the database
    reviews = burger.query.all()

    if reviews:
        # If reviews are found, return the list of review texts
        review_list = []
        for review in reviews:
            review_list.append({
                'id': review.id,
                'review': review.reviews  # Updated attribute name
            })
        return jsonify({'reviews': review_list}), 200
    else:
        # If no reviews are found, return a message indicating no reviews are available
        return jsonify({'message': 'No burger reviews found'}), 404

class pizza(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    reviews = db.Column(db.String(500), nullable=False)

@app.route('/fetch_pizza_reviews', methods=['GET'])
def fetch_pizza_reviews():
    # Query all burger reviews from the database
    reviews = pizza.query.all()

    if reviews:
        # If reviews are found, return the list of review texts
        review_list = []
        for review in reviews:
            review_list.append({
                'id': review.id,
                'review': review.reviews  # Updated attribute name
            })
        return jsonify({'reviews': review_list}), 200
    else:
        # If no reviews are found, return a message indicating no reviews are available
        return jsonify({'message': 'No burger reviews found'}), 404

class samosa(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    reviews = db.Column(db.String(500), nullable=False)

@app.route('/fetch_samosa_reviews', methods=['GET'])
def fetch_samosa_reviews():
    # Query all burger reviews from the database
    reviews = samosa.query.all()

    if reviews:
        # If reviews are found, return the list of review texts
        review_list = []
        for review in reviews:
            review_list.append({
                'id': review.id,
                'review': review.reviews  # Updated attribute name
            })
        return jsonify({'reviews': review_list}), 200
    else:
        # If no reviews are found, return a message indicating no reviews are available
        return jsonify({'message': 'No burger reviews found'}), 404

class pongal(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    reviews = db.Column(db.String(500), nullable=False)

@app.route('/fetch_pongal_reviews', methods=['GET'])
def fetch_pongal_reviews():
    # Query all burger reviews from the database
    reviews = pongal.query.all()

    if reviews:
        # If reviews are found, return the list of review texts
        review_list = []
        for review in reviews:
            review_list.append({
                'id': review.id,
                'review': review.reviews  # Updated attribute name
            })
        return jsonify({'reviews': review_list}), 200
    else:
        # If no reviews are found, return a message indicating no reviews are available
        return jsonify({'message': 'No burger reviews found'}), 404

class vada(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    reviews = db.Column(db.String(500), nullable=False)

@app.route('/fetch_vada_reviews', methods=['GET'])
def fetch_vada_reviews():
    # Query all burger reviews from the database
    reviews = vada.query.all()

    if reviews:
        # If reviews are found, return the list of review texts
        review_list = []
        for review in reviews:
            review_list.append({
                'id': review.id,
                'review': review.reviews  # Updated attribute name
            })
        return jsonify({'reviews': review_list}), 200
    else:
        # If no reviews are found, return a message indicating no reviews are available
        return jsonify({'message': 'No burger reviews found'}), 404

class dosa(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    reviews = db.Column(db.String(500), nullable=False)

@app.route('/fetch_dosa_reviews', methods=['GET'])
def fetch_dosa_reviews():
    # Query all burger reviews from the database
    reviews = dosa.query.all()

    if reviews:
        # If reviews are found, return the list of review texts
        review_list = []
        for review in reviews:
            review_list.append({
                'id': review.id,
                'review': review.reviews  # Updated attribute name
            })
        return jsonify({'reviews': review_list}), 200
    else:
        # If no reviews are found, return a message indicating no reviews are available
        return jsonify({'message': 'No burger reviews found'}), 404

@app.route('/owner/burger', methods=['GET'])
def analyze_burger_reviews():
    try:
        # Fetch all reviews for burgers from the database
        reviews = burger.query.all()

        if not reviews:
            return jsonify({'message': 'No reviews found'}), 404

        # Initialize sentiment counters
        pos, neu, neg = 0, 0, 0

        # Analyze each review
        for review in reviews:
            sentiment = analysis(review.reviews)
            if sentiment == "Positive":
                pos += 1
            elif sentiment == "Negative":
                neg += 1
            else:
                neu += 1

        # Return the sentiment counts
        return jsonify({
            'positive': pos,
            'neutral': neu,
            'negative': neg
        }), 200

    except Exception as e:
        print(f"Error in analyze_burger_reviews endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/owner/pizza', methods=['GET'])
def analyze_pizza_reviews():
    try:
        # Fetch all reviews for burgers from the database
        reviews = pizza.query.all()

        if not reviews:
            return jsonify({'message': 'No reviews found'}), 404

        # Initialize sentiment counters
        pos, neu, neg = 0, 0, 0

        # Analyze each review
        for review in reviews:
            sentiment = analysis(review.reviews)
            if sentiment == "Positive":
                pos += 1
            elif sentiment == "Negative":
                neg += 1
            else:
                neu += 1

        # Return the sentiment counts
        return jsonify({
            'positive': pos,
            'neutral': neu,
            'negative': neg
        }), 200

    except Exception as e:
        print(f"Error in analyze_burger_reviews endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/owner/samosa', methods=['GET'])
def analyze_samosa_reviews():
    try:
        # Fetch all reviews for burgers from the database
        reviews = samosa.query.all()

        if not reviews:
            return jsonify({'message': 'No reviews found'}), 404

        # Initialize sentiment counters
        pos, neu, neg = 0, 0, 0

        # Analyze each review
        for review in reviews:
            sentiment = analysis(review.reviews)
            if sentiment == "Positive":
                pos += 1
            elif sentiment == "Negative":
                neg += 1
            else:
                neu += 1

        # Return the sentiment counts
        return jsonify({
            'positive': pos,
            'neutral': neu,
            'negative': neg
        }), 200

    except Exception as e:
        print(f"Error in analyze_burger_reviews endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/owner/pongal', methods=['GET'])
def analyze_pongal_reviews():
    try:
        # Fetch all reviews for burgers from the database
        reviews = pongal.query.all()

        if not reviews:
            return jsonify({'message': 'No reviews found'}), 404

        # Initialize sentiment counters
        pos, neu, neg = 0, 0, 0

        # Analyze each review
        for review in reviews:
            sentiment = analysis(review.reviews)
            if sentiment == "Positive":
                pos += 1
            elif sentiment == "Negative":
                neg += 1
            else:
                neu += 1

        # Return the sentiment counts
        return jsonify({
            'positive': pos,
            'neutral': neu,
            'negative': neg
        }), 200

    except Exception as e:
        print(f"Error in analyze_burger_reviews endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/owner/dosa', methods=['GET'])
def analyze_dosa_reviews():
    try:
        # Fetch all reviews for burgers from the database
        reviews = dosa.query.all()

        if not reviews:
            return jsonify({'message': 'No reviews found'}), 404

        # Initialize sentiment counters
        pos, neu, neg = 0, 0, 0

        # Analyze each review
        for review in reviews:
            sentiment = analysis(review.reviews)
            if sentiment == "Positive":
                pos += 1
            elif sentiment == "Negative":
                neg += 1
            else:
                neu += 1

        # Return the sentiment counts
        return jsonify({
            'positive': pos,
            'neutral': neu,
            'negative': neg
        }), 200

    except Exception as e:
        print(f"Error in analyze_burger_reviews endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/owner/vada', methods=['GET'])
def analyze_vada_reviews():
    try:
        # Fetch all reviews for burgers from the database
        reviews = vada.query.all()

        if not reviews:
            return jsonify({'message': 'No reviews found'}), 404

        # Initialize sentiment counters
        pos, neu, neg = 0, 0, 0

        # Analyze each review
        for review in reviews:
            sentiment = analysis(review.reviews)
            if sentiment == "Positive":
                pos += 1
            elif sentiment == "Negative":
                neg += 1
            else:
                neu += 1

        # Return the sentiment counts
        return jsonify({
            'positive': pos,
            'neutral': neu,
            'negative': neg
        }), 200

    except Exception as e:
        print(f"Error in analyze_burger_reviews endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/add_pizza_review', methods=['POST'])
def add_pizza_review():
    try:
        # Get the review from the request
        data = request.json
        reviews = data.get('reviews')

        # Check if the review is provided
        if not reviews:
            return jsonify({'message': 'Review is required'}), 400

        # Create a new review entry in the `owner_mexican` table
        new_review = pizza(reviews=reviews)

        # Add the review to the database
        db.session.add(new_review)
        db.session.commit()

        return jsonify({'message': 'Review added successfully'}), 201

    except Exception as e:
        print(f"Error in add_pizza_review endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/add_burger_review', methods=['POST'])
def add_burger_review():
    try:
        # Get the review from the request
        data = request.json
        reviews = data.get('reviews')

        # Check if the review is provided
        if not reviews:
            return jsonify({'message': 'Review is required'}), 400

        # Create a new review entry in the `owner_mexican` table
        new_review = burger(reviews=reviews)

        # Add the review to the database
        db.session.add(new_review)
        db.session.commit()

        return jsonify({'message': 'Review added successfully'}), 201

    except Exception as e:
        print(f"Error in add_burger_review endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/add_samosa_review', methods=['POST'])
def add_samosa_review():
    try:
        # Get the review from the request
        data = request.json
        reviews = data.get('reviews')

        # Check if the review is provided
        if not reviews:
            return jsonify({'message': 'Review is required'}), 400

        # Create a new review entry in the `owner_mexican` table
        new_review = samosa(reviews=reviews)

        # Add the review to the database
        db.session.add(new_review)
        db.session.commit()

        return jsonify({'message': 'Review added successfully'}), 201

    except Exception as e:
        print(f"Error in add_samosa_review endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/add_pongal_review', methods=['POST'])
def add_pongal_review():
    try:
        # Get the review from the request
        data = request.json
        reviews = data.get('reviews')

        # Check if the review is provided
        if not reviews:
            return jsonify({'message': 'Review is required'}), 400

        # Create a new review entry in the `owner_mexican` table
        new_review = pongal(reviews=reviews)

        # Add the review to the database
        db.session.add(new_review)
        db.session.commit()

        return jsonify({'message': 'Review added successfully'}), 201

    except Exception as e:
        print(f"Error in add_pongal_review endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/add_dosa_review', methods=['POST'])
def add_dosa_review():
    try:
        # Get the review from the request
        data = request.json
        reviews = data.get('reviews')

        # Check if the review is provided
        if not reviews:
            return jsonify({'message': 'Review is required'}), 400

        # Create a new review entry in the `owner_mexican` table
        new_review = dosa(reviews=reviews)

        # Add the review to the database
        db.session.add(new_review)
        db.session.commit()

        return jsonify({'message': 'Review added successfully'}), 201

    except Exception as e:
        print(f"Error in add_dosa_review endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/add_vada_review', methods=['POST'])
def add_vada_review():
    try:
        # Get the review from the request
        data = request.json
        reviews = data.get('reviews')

        # Check if the review is provided
        if not reviews:
            return jsonify({'message': 'Review is required'}), 400

        # Create a new review entry in the `owner_mexican` table
        new_review = vada(reviews=reviews)

        # Add the review to the database
        db.session.add(new_review)
        db.session.commit()

        return jsonify({'message': 'Review added successfully'}), 201

    except Exception as e:
        print(f"Error in add_vada_review endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

class status(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False)

@app.route('/add_email', methods=['POST'])
def add_email():
    try:
        # Get the email from the request
        data = request.json
        email = data.get('email')

        # Check if the email is provided
        if not email:
            return jsonify({'message': 'Email is required'}), 400

        # Create a new entry in the `status` table
        new_email = status(email=email)

        # Add the email to the database
        db.session.add(new_email)
        db.session.commit()

        return jsonify({'message': 'Email added successfully'}), 201

    except Exception as e:
        print(f"Error in add_email endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/get_last_email', methods=['GET'])
def get_last_email():
    # Get the last email from the status table
    last_email = status.query.order_by(status.id.desc()).first()

    if last_email:
        # Fetch the user's name associated with the email from the userdetails table
        user = userdetails.query.filter_by(email=last_email.email).first()

        if user:
            return jsonify({ "name": user.name}), 200
        else:
            return jsonify({"email": last_email.email, "message": "User details not found."}), 404
    else:
        return jsonify({"message": "No email found"}), 404

@app.route('/get_last_user', methods=['GET'])
def get_last_user():
    # Get the last email from the status table
    last_email = status.query.order_by(status.id.desc()).first()

    if last_email:
        # Fetch the user's details associated with the email from the userdetails table
        user = userdetails.query.filter_by(email=last_email.email).first()

        if user:
            return jsonify({
                "name": user.name,
                "dob": user.dob,
                "email": user.email,
                "mobile_number": user.mobilenumber
            }), 200
        else:
            return jsonify({
                "email": last_email.email,
                "message": "User details not found."
            }), 404
    else:
        return jsonify({"message": "No email found"}), 404

@app.route('/update_user', methods=['POST'])
def update_user():
    try:
        data = request.get_json()  # Get the JSON data sent from Flutter
        
        email = data.get('email')
        name = data.get('name')
        dob = data.get('dob')
        mobile_number = data.get('mobile_number')

        if not email:
            return jsonify({"message": "Email is required"}), 400
        
        # Find the user by email
        user = userdetails.query.filter_by(email=email).first()

        if not user:
            return jsonify({"message": "User not found"}), 404
        
        # Update user details
        user.name = name
        user.dob = dob
        user.mobilenumber = mobile_number
        
        # Commit changes to the database
        db.session.commit()

        return jsonify({"message": "User details updated successfully"}), 200
    except Exception as e:
        return jsonify({"message": str(e)}), 500

import random
import smtplib
import os

# Store OTPs temporarily (Replace with a database in production)
otp_storage = {}

# Email configuration
EMAIL_ADDRESS = "tmsaipavan@gmail.com"
# Replace with your generated App Password
EMAIL_PASSWORD = "vpqv vtui orbn gzlv"  

# SMTP Configuration
SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587

def generate_otp():
    """Generate a 6-digit OTP"""
    return str(random.randint(100000, 999999))

def send_email(to_email, otp):
    """Send an OTP to the given email address"""
    subject = "Your One-Time OTP Code for Verification"
    email_body = f"""
        Hi there,
        
        Thank you for choosing to verify your account with us. Below is your one-time password (OTP) to complete the verification process:
        
        Your OTP code: {otp}
        
        This code is valid for the next 10 minutes, so please enter it soon to complete your registration.
        
        If you didn't request this OTP or need any assistance, feel free to contact us at tmsaipavan@gmail.com.
        
        Thank you for your trust, and welcome to SENTIBITES!
        
        Best regards,
        SENTIBITES
        tmsaipavan@gmail.com | 9962355558
        """
    message = f"Subject: {subject}\n\n{email_body}"

    try:
        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()
        server.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
        server.sendmail(EMAIL_ADDRESS, to_email, email_body.encode('utf-8'))
        server.quit()
        return True
    except Exception as e:
        print("Error sending email:", str(e))
        return False

@app.route("/send_otp", methods=["POST"])
def send_otp():
    try:
        data = request.get_json()
        email = data.get("email")

        if not email:
            return jsonify({"status": "error", "message": "Email is required"}), 400

        otp = generate_otp()
        otp_storage[email] = otp

        if send_email(email, otp):
            return jsonify({
                "status": "success",
                "message": "OTP sent successfully"
            }), 200
        else:
            return jsonify({
                "status": "error",
                "message": "Failed to send OTP"
            }), 500
    except Exception as e:
        print("Error in send_otp:", str(e))
        return jsonify({
            "status": "error",
            "message": "Internal server error"
        }), 500

@app.route("/verify_otp", methods=["POST"])
def verify_otp():
    try:
        data = request.get_json()
        email = data.get("email")
        user_otp = data.get("otp")

        if not email or not user_otp:
            return jsonify({
                "status": "error",
                "message": "Email and OTP are required"
            }), 400

        stored_otp = otp_storage.get(email)
        if stored_otp and stored_otp == user_otp:
            del otp_storage[email]  # Remove OTP after verification
            return jsonify({
                "status": "success",
                "message": "OTP verified successfully"
            }), 200
        else:
            return jsonify({
                "status": "error",
                "message": "Invalid OTP"
            }), 401
    except Exception as e:
        print("Error in verify_otp:", str(e))
        return jsonify({
            "status": "error",
            "message": "Internal server error"
        }), 500

@app.route('/get_items_image', methods=['GET'])
def get_items_image():
    # Querying the database to get only the name and image
    items = OwnerAddItems.query.with_entities(OwnerAddItems.name, OwnerAddItems.image).all()
    
    # Creating a list of dictionaries with only name and image
    items_list = [{"name": item.name, "image": item.image} for item in items]
    
    # Returning the items as JSON
    return jsonify(items_list)

class item_reviews(db.Model):
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    review = db.Column(db.String(255), nullable=False)
    item = db.Column(db.String(100), nullable=False)

@app.route('/get_reviews_item', methods=['POST'])
def get_reviewss():
    # Parse JSON input from the request
    data = request.get_json()

    # Extract item name from the JSON input
    item_name = data.get('item')  # Example input: {"item": "Pizza"}

    # If no item name is provided, return an error
    if not item_name:
        return jsonify({"error": "Item name is required"}), 400

    # Query the reviews for the specific item
    reviews = item_reviews.query.filter_by(item=item_name).all()

    # If no reviews are found, return an error
    if not reviews:
        return jsonify({"error": "No reviews found for this item"}), 404

    # Format the response in the desired structure
    reviews_list = [{"id": review.id, "review": review.review} for review in reviews]

    # Return only the reviews
    return jsonify({
        "reviews": reviews_list
    })

@app.route('/get_reviews_item_sentiment', methods=['POST'])
def get_reviews_sentiment():
    # Parse JSON input from the request
    data = request.get_json()

    # Extract item name from the JSON input
    item_name = data.get('item')  # Example input: {"item": "Pizza"}

    # If no item name is provided, return an error
    if not item_name:
        return jsonify({"error": "Item name is required"}), 400

    # Query the reviews for the specific item
    reviews = item_reviews.query.filter_by(item=item_name).all()

    # If no reviews are found, return an error
    if not reviews:
        return jsonify({"error": "No reviews found for this item"}), 404

    # Initialize sentiment counters
    pos, neu, neg = 0, 0, 0

    # Analyze each review sentiment
    for review in reviews:
        sentiment = analysis(review.review)
        if sentiment == "Positive":
            pos += 1
        elif sentiment == "Negative":
            neg += 1
        else:
            neu += 1

    # Return only the sentiment counts
    return jsonify({
        'positive': pos,
        'neutral': neu,
        'negative': neg
    }), 200

@app.route('/post_review', methods=['POST'])
def post_review():
    data = request.get_json()  # Get the JSON data sent in the request
    
    # Extract review and item from the request data
    review_text = data.get('review')
    item_name = data.get('item')
    
    if not review_text or not item_name:
        return jsonify({'message': 'Review and item are required'}), 400
    
    # Create a new ItemReview object
    new_review = item_reviews(review=review_text, item=item_name)
    
    try:
        # Add the new review to the database
        db.session.add(new_review)
        db.session.commit()
        return jsonify({'message': 'Review added successfully'}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'message': f'Error: {str(e)}'}), 500

@app.route('/get_item_image', methods=['POST'])
def get_item_image():
    data = request.get_json()  # Get JSON data from the request
    item_name = data.get('name')  # Extract 'name' from the input JSON
    
    if item_name:
        item = OwnerAddItems.query.filter_by(name=item_name).first()
        if item:
            return jsonify({"image": item.image}), 200
        else:
            return jsonify({"error": "Item not found"}), 404
    else:
        return jsonify({"error": "No name provided"}), 400

@app.route('/reset_password', methods=['POST'])
def reset_password():
    try:
        data = request.json
        email = data.get('email')
        new_password = data.get('new_password')

        if not email or not new_password:
            return jsonify({'message': 'Email and new password are required'}), 400

        # Find the user
        user = userdetails.query.filter_by(email=email).first()
        if not user:
            return jsonify({'message': 'User not found'}), 404

        # Hash the new password
        hashed_password = bcrypt.generate_password_hash(new_password).decode('utf-8')
        
        # Update the password
        user.password = hashed_password
        db.session.commit()

        return jsonify({
            'status': 'success',
            'message': 'Password updated successfully'
        }), 200

    except Exception as e:
        print(f"Error in reset_password endpoint: {str(e)}")  # Add this for debugging
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
    
if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')
