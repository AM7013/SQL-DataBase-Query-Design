DROP TABLE IF EXISTS BoxOffice CASCADE;
DROP TABLE IF EXISTS Movies CASCADE;


CREATE TABLE IF NOT EXISTS Movies (
    id SERIAL PRIMARY KEY ,
    title VARCHAR(255) NOT NULL DEFAULT 'Untitled Movie',
    release_year INT NOT NULL DEFAULT EXTRACT(YEAR FROM CURRENT_DATE) CHECK (release_year >= 1888 AND release_year <= EXTRACT(YEAR FROM CURRENT_DATE) + 5),
    genre VARCHAR(100),
    director VARCHAR(255),
    length_minutes FLOAT CHECK (length_minutes >= 0 AND length_minutes <= 2000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS BoxOffice (
    movie_id INT NOT NULL,
    rating FLOAT CHECK (rating >= 0 AND rating <= 10),
    domestic_sales FLOAT,
    international_sales FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (movie_id) REFERENCES Movies(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE OR REPLACE VIEW movie AS
SELECT 
    movies.id,
    movies.title,
    movies.release_year,
    movies.genre,
    movies.director,
    movies.length_minutes,
    BoxOffice.rating,
    BoxOffice.domestic_sales,
    BoxOffice.international_sales,
    BoxOffice.international_sales + BoxOffice.domestic_sales AS total_sales
FROM movies
LEFT JOIN BoxOffice ON movies.id = BoxOffice.movie_id;



CREATE OR REPLACE VIEW MovieSummary AS
SELECT
    title,
    genre,
    director,
    rating,
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
    domestic_sales + international_sales AS total_sales
FROM movies
JOIN BoxOffice ON movies.id = BoxOffice.movie_id
WHERE rating >=8.0
ORDER BY rating DESC;




INSERT INTO Movies (id, title, release_year, genre, director, length_minutes) VALUES
(1,'Inception', 2010, 'Science Fiction', 'Christopher Nolan', 148),
(2,'The Godfather', 1972, 'Crime', 'Francis Ford Coppola', 175),
(3,'Pulp Fiction', 1994, 'Crime', 'Quentin Tarantino', 154),
(4,'The Shawshank Redemption', 1994, 'Drama', 'Frank Darabont', 142),
(5,'The Dark Knight', 2008, 'Action', 'Christopher Nolan', 152),
(6,'Forrest Gump', 1994, 'Drama', 'Robert Zemeckis', 142),
(7,'The Matrix', 1999, 'Science Fiction', 'The Wachowskis', 136),
(8,'Gladiator', 2000, 'Action', 'Ridley Scott', 155),
(9,'Dexter', 2006, 'Crime', 'Michael Cuesta', 60),
(10,'The Lord of the Rings: The Return of the King', 2003, 'Fantasy', 'Peter Jackson', 201);


INSERT INTO BoxOffice (movie_id, rating, domestic_sales, international_sales) VALUES
(1, 8.8, 292.6, 535.7),
(2, 9.2, 134.9, 133.7),
(3, 8.9, 107.9, 213.9),
(4, 9.3, 28.3, 58.3),
(5, 9.0, 534.9, 469.7),
(6, 8.8, 330.2, 500.2),
(7, 8.7, 171.5, 292.0),
(8, 8.5, 187.7, 457.6),
(9, 8.6, 173.3, 0.0),
(10, 8.9, 377.8, 1119.9);
