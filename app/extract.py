import pandas as pd

def extract_data(file_path):
    print("dataset.csv reading")
    return pd.read_csv(file_path)