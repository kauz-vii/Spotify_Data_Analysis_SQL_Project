-- BUSINESS PROBLEMS for Spotify Data Analysis --

-- ---------------------------------
-- Data Analysis - Easy Category
-- ---------------------------------

-- Q1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT track
FROM spotify
WHERE stream > 1000000000;

-- Q2. List all albums along with their respective artists.
SELECT DISTINCT album, artist
FROM spotify
ORDER BY artist, album;

-- Q3. Get the total number of comments for tracks where licensed = TRUE.
SELECT SUM(comments) AS total_comments
FROM spotify
WHERE licensed = TRUE;

-- Q4. Find all tracks that belong to the album type single.
SELECT track
FROM spotify
WHERE album_type = 'single';

-- Q5. Count the total number of tracks by each artist.
SELECT artist, COUNT(*) AS total_tracks
FROM spotify
GROUP BY artist
ORDER BY total_tracks DESC;


-- ---------------------------------
-- Data Analysis - Medium Category
-- ---------------------------------

-- Q6. Calculate the average danceability of tracks in each album.
SELECT
    album,
    ROUND(AVG(danceability), 3) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;


-- Q7. Find the top 5 tracks with the highest energy values.
SELECT
    track,
    artist,
    energy
FROM spotify
ORDER BY energy DESC
LIMIT 5;


-- Q8. List all tracks along with their views and likes where official_video = TRUE.
SELECT
    track,
    views,
    likes
FROM spotify
WHERE official_video = TRUE
ORDER BY views DESC;


-- Q9. For each album, calculate the total views of all associated tracks.
SELECT
    album,
    SUM(views) AS total_views
FROM spotify
GROUP BY album
ORDER BY total_views DESC;


-- Q10. Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT
    track
FROM spotify
WHERE most_played_on = 'Spotify'
  AND stream > views;


-- ---------------------------------
-- Data Analysis - Advanced Category
-- ---------------------------------

-- Q11. Find the top 3 most-viewed tracks for each artist using window functions.
SELECT artist, track, views
FROM (
    SELECT
        artist,
        track,
        views,
        ROW_NUMBER() OVER (PARTITION BY artist ORDER BY views DESC) AS rn
    FROM spotify
) t
WHERE rn <= 3
ORDER BY artist, rn;


-- Q12. Write a query to find tracks where the liveness score is above the average.
SELECT
    track,
    artist,
    liveness
FROM spotify
WHERE liveness > (
    SELECT AVG(liveness) FROM spotify
)
ORDER BY liveness DESC;


-- Q13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH energy_stats AS (
    SELECT
        album,
        MAX(energy) AS max_energy,
        MIN(energy) AS min_energy
    FROM spotify
    GROUP BY album
)
SELECT
    album,
    max_energy,
    min_energy,
    (max_energy - min_energy) AS energy_difference
FROM energy_stats
ORDER BY energy_difference DESC;


-- Q14. Find tracks where the energy-to-liveness ratio is greater than 1.2.
SELECT
    track,
    artist,
    energy,
    liveness,
    (energy / NULLIF(liveness, 0)) AS energy_liveness_ratio
FROM spotify
WHERE (energy / NULLIF(liveness, 0)) > 1.2
ORDER BY energy_liveness_ratio DESC;


-- Q15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT
    track,
    views,
    likes,
    SUM(likes) OVER (ORDER BY views DESC) AS cumulative_likes
FROM spotify
ORDER BY views DESC;


-- -------------------
-- QUERY OPTIMIZATION
-- -------------------

--Example query
SELECT 
    artist,
    track,
    album
FROM spotify
WHERE artist = 'Gorillaz'
    AND
    most_played_on = 'Youtube'
ORDER BY stream DESC LIMIT 25

EXPLAIN ANALYZE -- ET: 3.7 ms , PT: 0.9 ms
SELECT 
    artist,
    track,
    album
FROM spotify
WHERE artist = 'Gorillaz'
    AND
    most_played_on = 'Youtube'
ORDER BY stream DESC LIMIT 25

--Creating index
create index artist_index on spotify(artist);

EXPLAIN ANALYZE -- ET: 0.1 ms , PT: 0.1 ms
SELECT 
    artist,
    track,
    album
FROM spotify
WHERE artist = 'Gorillaz'
    AND
    most_played_on = 'Youtube'
ORDER BY stream DESC LIMIT 25