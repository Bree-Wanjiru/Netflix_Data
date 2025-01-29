CREATE TABLE Netflixdata (
    show_id VARCHAR(100) PRIMARY KEY,
    type_ VARCHAR(10),
    title VARCHAR(255),
    director VARCHAR(255),
    cast_ TEXT,
    country VARCHAR(255),
    date_added VARCHAR(255),
    release_year VARCHAR(255),
    rating VARCHAR(10),
    duration VARCHAR(20),
    listed_in VARCHAR(255),
    description TEXT
); 

SELECT * 
FROM Netflixdata;

-- Data cleaning
-- select data where title is null
SELECT * 
FROM Netflixdata where title is null;

-- select data where cast and director is null
SELECT * 
FROM Netflixdata 
where cast_ is null
AND director is null;

-- delete data where cast and director is null
DELETE FROM Netflixdata 
where cast_ is null
AND director is null;

-- select data where date_added is null
SELECT * 
FROM Netflixdata where date_added is null;

-- delete data where date_added is null
DELETE FROM Netflixdata 
where date_added is null;

SELECT *
FROM Netflixdata ;

-- Renaming null values
SELECT show_id, type_, title, 
COALESCE (director, 'NO Director') as director,
COALESCE (cast_, 'NO Cast') as cast_
from Netflixdata;

-- How many TV shows and movies are available on Netflix?
SELECT type_, COUNT(*) 
FROM Netflixdata
GROUP BY type_;

-- Who are the top 10 directors with the most content on Netflix?
SELECT director, COUNT(title) as tots
FROM Netflixdata
WHERE director is not null
GROUP BY director 
ORDER BY tots DESC
LIMIT 10;

-- What are the most popular genres on Netflix?
SELECT listed_in, COUNT(*) AS popularity
FROM (
  SELECT unnest(string_to_array(listed_in, ',')) AS listed_in
  FROM Netflixdata
) AS listed_in_split
GROUP BY listed_in
ORDER BY popularity DESC
LIMIT 10;

-- What are the 10 most recently added titles on Netflix?
SELECT title , date_added
FROM Netflixdata
ORDER BY date_added DESC
LIMIT 10;

-- Calculate the average release year for TV shows and movies separately.
SELECT type_, AVG(release_year::INT) as avg_releaseyear
FROM Netflixdata
GROUP BY type_

-- Identify the top 10 countries with the most content available on Netflix.
SELECT trimmed_country, COUNT(title) as title_no
FROM (
SELECT  unnest(string_to_array(country, ',')) AS trimmed_country, title
FROM Netflixdata
WHERE country is not null
)
GROUP BY trimmed_country
ORDER BY title_no DESC
LIMIT 10;

-- Find the titles with the longest and shortest durations on Netflix.
(
    SELECT title, duration
    FROM Netflixdata
    WHERE duration LIKE '%min%'
    ORDER BY CAST(regexp_replace(duration, '[^0-9]', '', 'g') AS INT) DESC
    LIMIT 1  -- Longest Movie
)
UNION ALL
(
    SELECT title, duration
    FROM Netflixdata
    WHERE duration LIKE '%Season%'
    ORDER BY CAST(regexp_replace(duration, '[^0-9]', '', 'g') AS INT) DESC
    LIMIT 1  -- Longest TV Show
);

(
    SELECT title, duration
    FROM Netflixdata
    WHERE duration LIKE '%min%'
    ORDER BY duration ASC
    LIMIT 1  -- Shortest Movie
)
UNION ALL
(
    SELECT title, duration
    FROM Netflixdata
    WHERE duration LIKE '%Season%'
    ORDER BY duration ASC
    LIMIT 1  
	-- Shortest TV Show
);

	-- Shortest TV Shows as there are several
SELECT title, duration
FROM Netflixdata
WHERE duration LIKE '%Season%'
AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) = (
    -- Find the maximum number of seasons
    SELECT MIN(CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER))
    FROM Netflixdata
    WHERE duration LIKE '%Season%'
);

-- Analyze how much content was added to Netflix each year.
SELECT  EXTRACT(YEAR FROM CAST(date_added AS DATE))as years, COUNT(title) as tot_content
FROM Netflixdata
GROUP BY years
ORDER BY tot_content DESC 

-- Find the top 10 movies with the longest titles.
SELECT title, type_, LENGTH(title) as length_title
FROM Netflixdata
WHERE type_ LIKE 'Movie%'
ORDER BY length_title DESC
LIMIT 10;

