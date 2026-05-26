-- 1. TOP 5 most popular genres
SELECT g.genre_name, COUNT(t.track_id) as total_songs, ROUND(AVG(t.popularity), 2) as avg_popularity
FROM tracks t
JOIN genres g ON t.genre_id = g.genre_id
GROUP BY g.genre_name
HAVING COUNT(t.track_id) > 100
ORDER BY avg_popularity DESC
LIMIT 5;

-- 2. TOP 3 most energetic songs of each genre (Window Function)
WITH RankedTracks AS (
    SELECT t.track_name, g.genre_name, t.energy,
           DENSE_RANK() OVER (PARTITION BY t.genre_id ORDER BY t.energy DESC) as rank
    FROM tracks t
    JOIN genres g ON t.genre_id = g.genre_id
)
SELECT genre_name, track_name, energy, rank
FROM RankedTracks
WHERE rank <= 3;