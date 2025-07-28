# test_connection.py
# Simple test to check if database connection works

import os
from dotenv import load_dotenv

print("🔍 Testing Database Connection Setup...")
print("-" * 50)

# Try to load environment variables
load_dotenv("db.env")

# Check if environment variables exist
db_host = os.getenv("DB_HOST")
db_user = os.getenv("DB_USER") 
db_pass = os.getenv("DB_PASS")
db_name = os.getenv("DB_NAME")
db_port = os.getenv("DB_PORT")

print("📋 Environment Variables Check:")
print(f"DB_HOST: {db_host}")
print(f"DB_USER: {db_user}")
print(f"DB_PASS: {'*' * len(db_pass) if db_pass else None}")
print(f"DB_NAME: {db_name}")
print(f"DB_PORT: {db_port}")
print()

if not all([db_host, db_user, db_pass, db_name, db_port]):
    print("❌ PROBLEM FOUND: Missing database credentials!")
    print("   The db.env file doesn't exist or is missing values.")
else:
    print("✅ Environment variables found! Testing connection...")
    try:
        import mysql.connector
        conn = mysql.connector.connect(
            host=db_host,
            user=db_user,
            password=db_pass,
            database=db_name,
            port=db_port
        )
        print("✅ DATABASE CONNECTION SUCCESSFUL!")
        print("   Your database is ready to use!")
        conn.close()
    except Exception as e:
        print("❌ DATABASE CONNECTION FAILED!")
        print(f"   Error: {e}")
