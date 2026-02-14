DELETE FROM Boxoffice 
WHERE movie_id IN (4, 6);

-- simple select with join:

SELECT * FROM movies
LEFT JOIN BoxOffice ON movies.id = BoxOffice.movie_id
ORDER BY id ASC;

-- select with join and case statements:

SELECT title, rating, length_minutes,
        CASE
            WHEN rating >=9 THEN '✨ Masterpiece'
            WHEN rating >=7 THEN '😎 amazing'
            WHEN rating >=5 THEN '😐 meh'
            ELSE '😔 probably sucks'
        END AS rating_category,
        CASE   
            WHEN genre = 'Action' THEN '🔥 Action'
            WHEN genre = 'Drama' THEN '🎭 Drama'
            WHEN genre = 'Crime' THEN '🔫 Crime'
            WHEN genre = 'Science Fiction' THEN '👽 Sci-Fi'
            WHEN genre = 'Fantasy' THEN '🧙‍♂️ Fantasy'
            ELSE '🎬 Other'
        END AS genre_icon,
        CASE
            WHEN length_minutes >= 150 THEN '🍿 Long'
            WHEN length_minutes >= 90 THEN '🍿 Medium'
            ELSE '🍿 Short'
        END AS length_category,
        CASE
            WHEN director = 'Christopher Nolan' THEN 'GOAT Nolan'
            ELSE director
        END AS director_category,
        Domestic_sales + international_sales AS total_sales
FROM movies
LEFT JOIN BoxOffice ON movies.id = BoxOffice.movie_id
ORDER BY rating DESC;


-- Rollup:

EXPLAIN ANALYZE
SELECT 
    genre,
    director,
    COUNT(*) AS movie_count,
    SUM(total_sales) AS total_sales
FROM movie
GROUP BY ROLLUP(genre, director)
ORDER BY genre NULLS LAST, director NULLS LAST, total_sales DESC;

SELECT 
    genre,
    director,
    COUNT(*) AS movie_count,
    SUM(total_sales) AS total_sales
FROM movie
GROUP BY ROLLUP(genre, director)
ORDER BY genre NULLS LAST, director NULLS LAST, total_sales DESC;

-- testing VIEW:

SELECT * FROM movie
ORDER BY total_sales DESC;

SELECT * FROM moviesummary
WHERE rating >= 8.0
ORDER BY rating DESC;

