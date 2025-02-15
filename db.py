import os
import psycopg2
from psycopg2 import pool
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

class Database:
    def __init__(self, minconn=1, maxconn=10):
        self.host = os.environ.get("PGHOST")
        self.database = os.environ.get("PGDATABASE")
        self.user = os.environ.get("PGUSER")
        self.password = os.environ.get("PGPASSWORD")
        self.conn_pool = None
        self.init_connection_pool(minconn, maxconn)

    def init_connection_pool(self, minconn, maxconn):
        try:
            self.conn_pool = psycopg2.pool.SimpleConnectionPool(
                minconn,
                maxconn,
                host=self.host,
                database=self.database,
                user=self.user,
                password=self.password
            )
            if self.conn_pool:
                print("Connection pool created successfully")
        except Exception as error:
            print("Error while creating the connection pool:", error)
            raise

    def get_connection(self):
        if self.conn_pool:
            return self.conn_pool.getconn()
        else:
            raise Exception("Connection pool not available")

    def return_connection(self, connection):
        if self.conn_pool:
            self.conn_pool.putconn(connection)

    def close_all_connections(self):
        if self.conn_pool:
            self.conn_pool.closeall()
