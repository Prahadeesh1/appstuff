
import os

class Config:
    SECRET_KEY = os.urandom(24)
    MYSQL_HOST = 'localhost'
    MYSQL_USER = 'root'
    MYSQL_PASSWORD = 'Prahaop1234567$'
    MYSQL_DB = 'sensor_data_db'
