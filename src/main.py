import os
import pyodbc
from dotenv import load_dotenv
from azure.storage.blob import BlobServiceClient

from image_raw import ingest_raw_images
from image_processed import process_images

# Load env & shared variables
load_dotenv()

server = os.getenv("DB_SERVER")
database = os.getenv("DB_DATABASE")
username = os.getenv("DB_USERNAME")
password = os.getenv("DB_PASSWORD")
storage_connection_string = os.getenv("AZURE_STORAGE_CONNECTION_STRING")
container_name = os.getenv("AZURE_CONTAINER_NAME")
input_folder = r"C:\Users\Geber.Cruz\OneDrive - Inchcape\Desktop\My Work\Image Processing\Caltex Images"
created_by = "PulseApp"

# Blob base url
base_url = f"https://{storage_connection_string.split(';')[0].split('=')[1]}.blob.core.windows.net/{container_name}/"

# DB & Blob connections
def get_db_connection():
    return pyodbc.connect(
        f"DRIVER={{ODBC Driver 17 for SQL Server}};"
        f"SERVER=tcp:{server};DATABASE={database};UID={username};PWD={password};"
        f"Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
    )

blob_service_client = BlobServiceClient.from_connection_string(storage_connection_string)
container_client = blob_service_client.get_container_client(container_name)

# Execute
if __name__ == "__main__":
    conn = get_db_connection()

    print("Step 1: Ingesting RAW Images")
    ingest_raw_images(conn, container_client, base_url, input_folder, created_by)

    print("Step 2: Processing Raw Images")
    process_images(conn, container_client, market_id=21) # Change to suitable market_id

    conn.close()
