# Spotify Data Analysis SQL Project
![](https://github.com/kauz-vii/Spotify_Data_Analysis_SQL_Project/blob/main/Spotify_logo_with_text.svg.png)

## Project Overview

**Project Title**: Spotify Data Analysis  
**Level**: Beginner to Intermediate  
**Database**: PostgreSQL  

This project focuses on analyzing a Spotify tracks dataset using SQL. It demonstrates end-to-end data analysis including:

- Database and schema creation  
- Data cleaning and NULL handling  
- Exploratory Data Analysis (EDA)  
- Solving business problems using SQL  
- Advanced SQL with window functions & CTEs  
- Query optimization using indexing and execution plans  

The project simulates real-world data analyst tasks and is designed for portfolio presentation.

---

## Objectives

1. **Design the database schema** for Spotify track data.
2. **Clean the dataset** by removing inconsistent records and detecting NULL values.
3. **Perform Exploratory Data Analysis (EDA)** to understand data distribution and trends.
4. **Solve business questions** using SQL (Easy → Medium → Advanced).
5. **Optimize query performance** using indexing and `EXPLAIN ANALYZE`.

---

## Database Schema

```sql
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
```

---

## Data Cleaning

### Remove Invalid Records

Tracks with zero duration were identified and removed:

```sql
SELECT * FROM spotify
WHERE duration_min = 0;

DELETE FROM spotify
WHERE duration_min = 0;
```

### Optimized NULL Detection

```sql
SELECT *
FROM spotify
WHERE to_jsonb(spotify)::text LIKE '%null%';
```

---

## Exploratory Data Analysis (EDA)

EDA was performed to understand:

- Total records and unique artists  
- Album type distribution  
- Track duration range  
- Most viewed and most liked tracks  
- Engagement ratio (likes/views)  
- Platform dominance (Spotify vs YouTube)  
- Audio feature averages  
- Duplicate detection  
- Top streamed artists  

Example:

```sql
SELECT artist, SUM(stream) AS total_streams
FROM spotify
GROUP BY artist
ORDER BY total_streams DESC
LIMIT 10;
```

---

## Business Problems & SQL Analysis

The project includes **15 real-world analytical queries** categorized by difficulty.

### Easy

- Tracks with more than **1 billion streams**
- Albums with their respective artists
- Total comments for licensed tracks
- Tracks released as singles
- Track count per artist

### Medium

- Average danceability per album
- Top 5 high-energy tracks
- Official videos with views & likes
- Total album views
- Tracks streamed more on Spotify than YouTube

### Advanced

- Top 3 most viewed tracks per artist *(Window Function)*
- Tracks with above-average liveness *(Subquery)*
- Energy range per album *(CTE)*
- Energy-to-liveness ratio analysis
- Cumulative likes based on views *(Window Function)*

---

## Query Optimization

Performance tuning was done using indexing and execution plan analysis.

### Before Index  
Execution Time: **3.7 ms**

### Create Index

```sql
CREATE INDEX artist_index ON spotify(artist);
```

### After Index  
Execution Time: **0.1 ms**

This demonstrates how indexing significantly improves query performance.

![](https://github.com/kauz-vii/Spotify_Data_Analysis_SQL_Project/blob/main/optimization.jpg)
---

## Key Insights

- A small number of artists contribute to the majority of total streams.
- Official videos generally receive higher engagement.
- Energy and loudness show a strong positive trend.
- Spotify is the dominant platform for streaming in the dataset.
- High engagement tracks can be identified using the like-to-view ratio.

---

## Tools & Technologies

- SQL  
- pgAdmin4

---

## How to Run the Project

1. Create the table using the provided schema.
2. Import the dataset into PostgreSQL.
3. Run the EDA queries.
4. Execute the business problem queries.
5. Run `EXPLAIN ANALYZE` to observe query optimization.

---

## Author – Kaushik Bhadra

This project is part of my SQL portfolio and showcases:

- Data cleaning techniques  
- Exploratory Data Analysis  
- Business-driven SQL queries  
- Window functions & CTEs  
- Query optimization using indexing  

---

## ⭐ Portfolio Value

This project demonstrates real data analyst skills:

- Writing efficient SQL queries  
- Converting raw data into business insights  
- Performance tuning  
- Structured analytical thinking  
