CREATE TABLE IF NOT EXISTS genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS artists (
    artist_id VARCHAR(50) PRIMARY KEY,
    artist_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS albums (
    album_id SERIAL PRIMARY KEY,
    album_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS tracks (
    track_id VARCHAR(50) PRIMARY KEY,
    track_name TEXT NOT NULL,
    album_id INT REFERENCES albums(album_id) ON DELETE CASCADE,
    genre_id INT REFERENCES genres(genre_id) ON DELETE CASCADE,
    popularity INT CHECK (popularity BETWEEN 0 AND 100),
    duration_ms INT CHECK (duration_ms > 0),
    explicit BOOLEAN NOT NULL,
    danceability FLOAT CHECK (danceability BETWEEN 0 AND 1),
    energy FLOAT CHECK (energy BETWEEN 0 AND 1),
    key INT,
    loudness FLOAT,
    mode INT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    time_signature INT
);

CREATE TABLE IF NOT EXISTS track_artists (
    track_id VARCHAR(50) REFERENCES tracks(track_id) ON DELETE CASCADE,
    artist_id VARCHAR(50) REFERENCES artists(artist_id) ON DELETE CASCADE,
    PRIMARY KEY (track_id, artist_id)
);