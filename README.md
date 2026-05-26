# Spotify ETL Pipeline & Relational Database Project

This project implements a robust **ETL (Extract, Transform, Load)** pipeline that processes a Spotify tracks dataset using **Python (Pandas)** and populates a structured **PostgreSQL** relational database.

## Database Schema

The database is designed following relational modeling principles (aiming for 3NF) to effectively resolve the **Many-to-Many** relationship between tracks and artists.

* **`genres`:** Stores unique music genres (`genre_id` [PK], `genre_name` [Unique]).
* **`albums`:** Stores album titles (`album_id` [PK], `album_name`).
* **`artists`:** Stores artist details (`artist_id` [PK, generated via MD5 hashing], `artist_name`).
* **`tracks`:** The main **Fact Table** containing song names, foreign keys (`album_id` [FK], `genre_id` [FK]), and audio metrics (such as `danceability`, `energy`, `loudness`, and `popularity`).
* **`track_artists`:** A **Junction Table** managing the Many-to-Many mapping between tracks and artists (`track_id` [FK], `artist_id` [FK]).

## Pipeline Architecture (Modular Design)

To ensure high maintainability and adhere to industry standards, the ETL pipeline is decoupled into distinct modules:

1. **`extract.py` (Extract):** Responsible for ingesting the raw source data from `dataset.csv` utilizing Pandas.
2. **`transform.py` (Transform):** Handles data cleaning and business logic:
   * Drops rows with critical missing values (`track_id`, `track_name`).
   * Eliminates duplicate records based on unique `track_id` constraints.
   * Utilizes `.clip()` functions to sanitize technical metrics, ensuring alignment with the database `CHECK` constraints (e.g., keeping popularity within `[0, 100]`).
3. **`load.py` (Load):** Connects to the database via SQLAlchemy and executes batch transactions using `INSERT ... ON CONFLICT DO NOTHING` to prevent redundancy.
4. **`main.py` (Orchestrator):** Serves as the central entry point managing the execution flow of the extraction, transformation, and loading phases.

## Analytical Results Summary

An analysis conducted via custom SQL queries in `sql/queries.sql` yielded the following insights:
* **Summary Statistics:** The global average popularity of tracks in the dataset hovers around ~30-40, with top-tier hits successfully reaching a peak score of 100.
* **Explicit vs. Clean Trends:** Tracks flagged as "Explicit" demonstrate a higher average popularity and increased loudness compared to their "Clean" counterparts.
* **Top Genres:** When breaking data down by track density and audience engagement, Pop, Rock, and Dance consistently emerge as the dominant genres.

## Getting Started

### 1. Database Setup
1. Create a fresh, empty database instance within your PostgreSQL environment (e.g., via pgAdmin).
2. Execute the DDL queries located in `sql/schema.sql` to instantiate the tables and constraints.

### 2. Environment Configurations
Install the required Python packages from the root directory:
```bash
pip install -r requirements.txt