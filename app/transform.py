import pandas as pd

def transform_data(df):
    print("data cleaning")
    # remove rows where important fields are empty.
    df = df.dropna(subset=['track_id', 'track_name', 'artists', 'album_name'])
    
    # remove repeated songs (track_id)
    df = df.drop_duplicates(subset=['track_id'])
    
    # restrict values according to the database's CHECK constraints.
    df['popularity'] = df['popularity'].clip(0, 100)
    df['danceability'] = df['danceability'].clip(0.0, 1.0)
    df['energy'] = df['energy'].clip(0.0, 1.0)
    df['duration_ms'] = df['duration_ms'].apply(lambda x: x if x > 0 else 1)
    
    return df