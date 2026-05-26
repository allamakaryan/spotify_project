import os
from dotenv import load_dotenv
from extract import extract_data
from transform import transform_data
from load import load_data

if __name__ == "__main__":
    current_dir = os.path.dirname(__file__)
    dotenv_path = os.path.join(current_dir, '..', '.env')
    load_dotenv(dotenv_path=dotenv_path, override=True)
    
    CSV_FILE_PATH = os.getenv("CSV_FILE_PATH")
    DATABASE_URL = os.getenv("DATABASE_URL")
    
    if not CSV_FILE_PATH:
        CSV_FILE_PATH = "/Users/allamakaryan/Desktop/spotify_project/data/dataset.csv"
    if not DATABASE_URL:
        DATABASE_URL = "postgresql://postgres:YOUR_PASSWORD@localhost:5432/postgres"
        
    print("ETL Pipeline start")
    # 1. EXTRACT
    raw_data = extract_data(CSV_FILE_PATH)
    # 2. TRANSFORM
    cleaned_data = transform_data(raw_data)
    # 3. LOAD
    load_data(cleaned_data, DATABASE_URL)