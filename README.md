# Spotify ETL Pipeline & Relational Database Project

This project implements a production-ready **ETL (Extract, Transform, Load)** pipeline that processes a Spotify tracks dataset using **Python (Pandas)** and populates a modular, well-structured **PostgreSQL** relational database.

---

## 📊 Dataset Description
* **Source:** [Spotify Tracks Dataset – Kaggle](https://www.kaggle.com/datasets/maharshipandya/-spotify-tracks-dataset)
* **Overview:** The dataset contains over 114,000 Spotify tracks with detailed audio features (such as `danceability`, `energy`, `acousticness`) and metadata (artists, albums, popularity, and explicit content flags).
* **Setup Note:** Due to GitHub's file size limitations, the raw `dataset.csv` is not tracked in this repository. To run the project, download the dataset from the Kaggle link above and place it into the `data/` directory.

---

## 🗄️ Database Schema & Architecture

The database follows relational modeling principles (aiming for 3NF) to systematically handle data integrity and eliminate redundancies, particularly resolving the **Many-to-Many** mapping between tracks and artists.

* **`genres`:** Stores unique music genres (`genre_id` [PK], `genre_name` [Unique]).
* **`albums`:** Stores unique album configurations (`album_id` [PK], `album_name`).
* **`artists`:** Stores artist details (`artist_id` [PK, generated via MD5 hashing], `artist_name`).
* **`tracks`:** The core **Fact Table** containing individual songs, foreign keys (`album_id` [FK], `genre_id` [FK]), and all critical audio performance metrics.
* **`track_artists`:** A **Junction Table** (Bridge) managing the Many-to-Many relationships between tracks and artists (`track_id` [FK], `artist_id` [FK]).

---

## 🛠️ Data Cleaning & Transformation Pipeline Documentation

To adhere to enterprise-level software engineering principles, the pipeline is entirely modularized into isolated operational script files (`extract.py`, `transform.py`, `load.py`) under the control of a central orchestrator (`main.py`).

### Detailed Processing Steps:
1. **Extraction (`extract.py`):** Ingests raw structured data directly from `data/dataset.csv` into an in-memory Pandas DataFrame.
2. **Transformation & Cleaning (`transform.py`):**
   * **Missing Value Resolution:** Drops any records missing critical identifier keys or text tags (`track_id`, `track_name`, `artists`, `album_name`) using `.dropna()` to guarantee relational database constraints.
   * **Deduplication:** Removes absolute redundant data injections by purging duplicated `track_id` entries via `.drop_duplicates()`.
   * **Constraint Boundary Enforcement:** Applies technical out-of-bounds sanitation using `.clip()` functions to ensure values align exactly with SQL domain rules (e.g., locking track popularity inside `[0, 100]`, and forcing decimal scales like danceability and energy strictly within `[0.0, 1.0]`).
   * **Data Correction:** Checks and normalizes anomalous time signatures, resetting any zero or negative track durations (`duration_ms`) safely up to `1`.
3. **Loading (`load.py`):** Initializes batch processing connection streams via SQLAlchemy and pushes structured dimensions safely using standard `INSERT ... ON CONFLICT DO NOTHING` statements to guarantee execution idempotency.

---

## 📈 SQL Analytical Queries & Results Summary

To fully validate the transactional database schema, comprehensive analytical evaluations were conducted via the relational engine. Below are the precise queries executed and documented in `sql/queries.sql`:

### 1. Summary Statistics
```sql
SELECT 
    COUNT(*) as total_tracks,
    ROUND(AVG(popularity), 2) as avg_popularity,
    ROUND(AVG(danceability)::numeric, 2) as avg_danceability,
    ROUND(AVG(energy)::numeric, 2) as avg_energy,
    MAX(popularity) as max_popularity
FROM tracks;