-- Practice SQL problem from WebDev Simplified

CREATE DATABASE record_company;
USE record_company;

--@block: First 2 tables are given
CREATE TABLE bands(
  id            INT NOT NULL AUTO_INCREMENT,
  name          VARCHAR(255) NOT NULL,
  PRIMARY KEY(id)
);

CREATE TABLE albums(
  id            INT NOT NULL AUTO_INCREMENT,
  name          VARCHAR(255) NOT NULL,
  release_year  INT,
  band_id       INT NOT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY(band_id) REFERENCES bands(id)
);


--@block: Problem 1: Create a Songs Table

-- This table should be called `songs` and have four properties with these exact names.
-- 1. `id`: An integer that is the primary key, and auto increments.
-- 2. `name`: A string that cannot be null.
-- 3. `length`: A float that represents the length of the song in minutes that cannot be null.
-- 4. `album_id`: An integer that is a foreign key referencing the albums table that cannot be null.

-- After successfully creating the table copy the code from [data.sql](data.sql) into MySQL Workbench, and run it to populate all of the data for the rest of the exercises. If you do not encounter any errors, then your answer is most likely correct.


CREATE TABLE songs(
    id          INT AUTO_INCREMENT,
    name        VARCHAR(255) NOT NULL,
    length      FLOAT(4, 2),
    album_id    INT NOT NULL,
    PRIMARY KEY(id)
);

ALTER TABLE songs
    ADD FOREIGN KEY(album_id)
    REFERENCES albums(id);


--@block: Problem 2: Select only the Names of all the Bands

-- Change the name of the column the data returns to `Band Name`

SELECT
    name as 'Band Name'
FROM
    bands;


--@block: Problem 3: Select the Oldest Album

-- Make sure to only return one result from this query, and that you are not returning any albums that do not have a release year.

SELECT
    id, name, release_year
FROM
    albums
WHERE
    release_year IS NOT NULL
ORDER BY
    release_year ASC
LIMIT
    1;


--@block: Problem 4: Get all Bands that have Albums

-- There are multiple different ways to solve this problem, but they will all involve a join.
-- Return the band name as `Band Name`.


SELECT
    DISTINCT bands.name AS 'Band Name'
FROM
    bands
JOIN
    albums
ON
    bands.id = albums.band_id;


--@block: Problem 5: Get all Bands that have No Albums

-- This is very similar to #4 but will require more than just a join.
-- Return the band name as `Band Name`.


SELECT
    DISTINCT bands.name AS 'Band Name'
FROM
    bands
LEFT JOIN
    albums
ON
    bands.id = albums.band_id
WHERE
    albums.band_id IS NULL;


--@block: Problem 6: Get the Longest Album

-- This problem sounds a lot like #3 but the solution is quite a bit different. I would recommend looking up the SUM aggregate function.
-- Return the album name as `Name`, the album release year as `Release Year`, and the album length as `Duration`.


SELECT
    albums.id AS 'ID', albums.name AS 'Name', albums.release_year AS 'Release Year', SUM(songs.length) AS 'Duration'
FROM
    albums
LEFT JOIN
    songs
ON
    albums.id = songs.album_id
GROUP BY
    albums.id
ORDER BY
    SUM(songs.length) DESC
LIMIT
    1;


--@block: Problem 7: Update the Release Year of the Album with no Release Year

-- Set the release year to 1986.
-- You may run into an error if you try to update the release year by using `release_year IS NULL` in the WHERE statement of your UPDATE. This is because MySQL Workbench by default will not let you update a table that has a primary key without using the primary key in the UPDATE statement. This is a good thing since you almost never want to update rows without using the primary key, so to get around this error make sure to use the primary key of the row you want to update in the WHERE of the UPDATE statement.


UPDATE
    albums
SET
    release_year = 1986
WHERE
    release_year IS NULL;

SELECT * FROM albums;


--@block: Problem 8: Insert a record for your favorite Band and one of their Albums

-- If you performed this correctly you should be able to now see that band and album in your tables.


INSERT INTO bands(name) VALUES('AC/DC');
INSERT INTO albums(name, release_year, band_id) VALUES('Back in Black', 1980, 8);

SELECT * FROM bands;
SELECT * FROM albums;


--@block: Problem 9: Delete the Band and Album you added in #8

-- The order of how you delete the records is important since album has a foreign key to band.


DELETE FROM
    albums
WHERE
    name = 'Back in Black';

DELETE FROM
    bands
WHERE
    name = 'AC/DC';

SELECT * FROM bands;
SELECT * FROM albums;


--@block: Problem 10: Get the Average Length of all Songs

-- Return the average length as `Average Song Duration`.


SELECT
    AVG(length) AS 'Average Song Duration'
FROM
    songs;


--@block: Problem 11: Select the longest Song off each Album

-- Return the album name as `Album`, the album release year as `Release Year`, and the longest song length as `Duration`.


SELECT
    albums.name AS 'Album',
    albums.release_year AS 'Release Year',
    MAX(songs.length) AS 'Duration'
FROM
    albums
LEFT JOIN
    songs
ON
    albums.id = songs.album_id
GROUP BY
    albums.id;


--@block: Problem 12: Get the number of Songs for each Band

-- This is one of the toughest question on the list. It will require you to chain together two joins instead of just one.
-- Return the band name as `Band`, the number of songs as `Number of Songs`.


SELECT
    bands.name AS 'Band',
    COUNT(songs.id) AS 'Number of Songs'
FROM
    bands
JOIN
    albums
ON
    bands.id = albums.band_id
JOIN
    songs
ON 
    albums.id = songs.album_id
GROUP BY
    bands.name;