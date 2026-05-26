Spotify ETL Pipeline & Relational Database Project
This project implements a full ETL (Extract, Transform, Load) pipeline on the Spotify Tracks dataset using Python (Pandas) and loads the data into a PostgreSQL relational database.
📊 Database Schema
The database is designed using a relational model (3NF), efficiently handling the Many-to-Many relationship between tracks and artists.

genres: genre_id (PK), genre_name (Unique)
albums: album_id (PK), album_name
artists: artist_id (PK, MD5 Hash), artist_name
tracks: track_id (PK), track_name, album_id (FK), genre_id (FK), and audio metrics (danceability, energy, loudness, popularity)
track_artists: track_id (FK), artist_id (FK) — Junction table for the Many-to-Many relationship

🛠️ Pipeline Description
The pipeline is split into separate modules for clean, modular architecture:

extract.py — Reads the raw dataset.csv file using Pandas
transform.py — Cleans missing values, removes duplicate track IDs, and clips values to match database CHECK constraints
load.py — Inserts data into PostgreSQL using INSERT ... ON CONFLICT DO NOTHING via SQLAlchemy
main.py — Entry point that orchestrates the full ETL pipeline

📈 Analytical Results Summary
Key insights from sql/queries.sql:

Summary Stats: Average track popularity is ~33, with a maximum of 100
Explicit vs Clean: Explicit tracks have higher average popularity and loudness than clean tracks
Top Genres: Pop, Dance, and Rock lead in both track count and average popularity
Top Artists: Artists with 5+ tracks were ranked by average popularity using multi-table JOINs
Window Function: Tracks ranked within each album by popularity using RANK() OVER (PARTITION BY album_id)

🚀 How to Run
1. Create the database in PostgreSQL
sqlCREATE DATABASE spotify_db;
2. Run the schema script to create tables
Open sql/schema.sql in your SQL client and execute it.
3. Install dependencies
bashpip install -r requirements.txt
4. Create a .env file in the project root
CSV_FILE_PATH=data/dataset.csv
DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/postgres
5. Run the pipeline
bashpython3 app/main.py
📁 Project Structure
spotify_project/
├── app/
│   ├── extract.py
│   ├── transform.py
│   ├── load.py
│   └── main.py
├── sql/
│   ├── schema.sql
│   └── queries.sql
├── data/
│   └── dataset.csv
├── .env
├── .gitignore
├── requirements.txt
└── README.md
🗃️ Dataset

Source: Kaggle — Spotify Tracks Dataset
Size: 114,000 tracks, 114 genres, 31,000+ artists
After cleaning: 89,740 unique tracks