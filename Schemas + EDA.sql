-- schema  
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

select * from spotify
limit 10;

--EDA

select count(*) from spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT MAX(duration_min) FROM spotify;

SELECT MIN(duration_min) FROM spotify;

SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_played_on FROM spotify;

-- inconsistent data

SELECT * FROM spotify
WHERE duration_min = 0

DELETE FROM spotify
WHERE duration_min = 0;

--optimized null count
SELECT *
FROM spotify
WHERE to_jsonb(spotify)::text LIKE '%null%';

-- Distribution of album types
SELECT album_type, COUNT(*) AS total_tracks
FROM spotify
GROUP BY album_type
ORDER BY total_tracks DESC;

-- Artists with most songs in dataset
SELECT artist, COUNT(*) AS total_tracks
FROM spotify
GROUP BY artist
ORDER BY total_tracks DESC
LIMIT 10;

-- Check if singles are shorter than albums
SELECT album_type, ROUND(AVG(duration_min), 2) AS avg_duration
FROM spotify
GROUP BY album_type;

-- Top 10 songs by views
SELECT track, artist, views
FROM spotify
ORDER BY views DESC
LIMIT 10;

-- Top 10 songs by likes
SELECT track, artist, likes
FROM spotify
ORDER BY likes DESC
LIMIT 10;

-- Find highly engaging songs
SELECT
    track,
    artist,
    views,
    likes,
    ROUND(likes / views, 4) AS like_view_ratio
FROM spotify
WHERE views > 0
ORDER BY like_view_ratio DESC
LIMIT 10;

-- Where songs are most played
SELECT most_played_on, COUNT(*) AS total_tracks
FROM spotify
GROUP BY most_played_on;

-- Understand overall musical characteristics
SELECT
    ROUND(AVG(danceability),2) AS avg_danceability,
    ROUND(AVG(energy),2) AS avg_energy,
    ROUND(AVG(acousticness),2) AS avg_acousticness,
    ROUND(AVG(valence),2) AS avg_valence,
    ROUND(AVG(tempo),2) AS avg_tempo
FROM spotify;

-- Compare energy and loudness trends
SELECT
    ROUND(energy,1) AS energy_bucket,
    ROUND(AVG(loudness),2) AS avg_loudness
FROM spotify
GROUP BY energy_bucket
ORDER BY energy_bucket;

-- Do official videos get more views?
SELECT
    official_video,
    ROUND(AVG(views),2) AS avg_views,
    ROUND(AVG(likes),2) AS avg_likes
FROM spotify
GROUP BY official_video;

-- Best performing channels
SELECT channel, SUM(views) AS total_views
FROM spotify
GROUP BY channel
ORDER BY total_views DESC
LIMIT 10;

-- Bucket songs by length
SELECT
    CASE
        WHEN duration_min < 3 THEN 'Short'
        WHEN duration_min BETWEEN 3 AND 5 THEN 'Medium'
        ELSE 'Long'
    END AS duration_category,
    COUNT(*) AS total_tracks
FROM spotify
GROUP BY duration_category;

-- Possible duplicate records
SELECT artist, track, COUNT(*)
FROM spotify
GROUP BY artist, track
HAVING COUNT(*) > 1;

-- Artists with highest total streams
SELECT artist, SUM(stream) AS total_streams
FROM spotify
GROUP BY artist
ORDER BY total_streams DESC
LIMIT 10;
