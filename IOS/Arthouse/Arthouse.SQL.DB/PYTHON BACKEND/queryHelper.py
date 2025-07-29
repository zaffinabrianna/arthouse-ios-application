#################################################
# Assists in running queries on the SQL database
#################################################

from flask import Flask, request, jsonify
import os, mysql.connector
from dotenv import load_dotenv, dotenv_values


#deal with login credentials
#load_dotenv("db.env")      #old test sql database
load_dotenv("googleCloudSQLDB.env")


def get_connection():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS"),
        database=os.getenv("DB_NAME"),
        port=os.getenv("DB_PORT"),
        ssl_ca=os.getenv("ssl_ca"),
        ssl_cert=os.getenv("ssl_cert"),
        ssl_key=os.getenv("ssl_key")
)

#runs queries for creation, updating, and deleting operations.

def run_cud_query(query, attributesTuple):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(query, attributesTuple)
    conn.commit()
    last_id = cursor.lastrowid
    cursor.close()
    conn.close()
    return last_id

# runs queries to read singular items
def run_read_single(query, attributesTuple=None):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(query, attributesTuple)
    result = cursor.fetchone()
    cursor.close()
    conn.close()
    return result

# runs queries to read multiple items
def run_read_multiple(query, attributesTuple=None):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(query, attributesTuple)
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    return result



#TEST CONNECTION
from mysql.connector import Error

try:
    conn = get_connection()
    if conn.is_connected():
        print("✅ Connected successfully to Google Cloud SQL!")
        cursor = conn.cursor()
        cursor.execute("SELECT 1;")
        print("Test query result:", cursor.fetchone())
        cursor.close()
except Error as e:
    print("❌ Connection failed:", e)
finally:
    if 'conn' in locals() and conn.is_connected():
        conn.close()
