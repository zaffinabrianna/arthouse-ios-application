#################################################
# Assists in running queries on the SQL database
#################################################

from flask import Flask, request, jsonify
import os, mysql.connector
from dotenv import load_dotenv, dotenv_values


#deal with login credentials
load_dotenv("db.env")


def get_connection():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS"),
        database=os.getenv("DB_NAME"),
        port=os.getenv("DB_PORT")
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
