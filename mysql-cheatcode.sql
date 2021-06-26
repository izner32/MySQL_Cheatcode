-- CHEATCODE FOR SQL BY RENZ CARILLO
-- I MAINLY USE THIS AS QUICK OVERVIEW WHEN I'M ABOUT TO USE THE LANGUAGE, COMMENTS ARE CREATED BASED ON MY OWN UNDERSTANDING 
-- ROADMAP WAS PULLED FROM LINKEDIN LEARNING | LEARNING PATH: BECOME A DATABASE DEVELOPER-- LESSON 3.1 - CREATING DATABASE

CREATE DATABASE movies; -- make sure to refresh navigator pane for this new schema/database to appear
-- *note: you could do these things easily with wizard

-- LESSON 3.2 - CREATING TABLE
-- (PK) PRIMARY KEY - UNIQUE TO EACH RECORDS
-- (NN) NOT NULL - CANNOT CONTAIN NULL VALUES
-- (UQ) UNIQUE - EACH ROW MUST HAVE A UNIQUE VALUE IN THIS COLUMN
-- (B) BINARY - COLUMN WILL CONTAIN BINARY DATA
-- (UN) UNSIGNED - COLUMN CANNOT CONTAIN ANY NEGATIVE NUMBERS
-- (ZF) ZERO FILL - VALUES WILL BE PADDED TO MAXIMUM COLUMN SIZE WITH ZEROES WHEN DISPLAYED
-- (AI) AUTO INCREMENT - WILL AUTOMATICALLY GENERATE AN UNUSED VALUE FOR THIS COLUMN
-- (G)  GENERATED - COLUMN VALUE WILL BE AUTOMATICALLY GENERATED BASED ON SUPPLIED EXPRESSION

CREATE TABLE movies_basic -- CREATE TABLE table_name
(id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, -- these are the keywords from above
title VARCHAR(100), -- field_name datatype(n)
genre VARCHAR(20),
release_year INT,
director VARCHAR(40),
studio VARCHAR(30),
critics_rating DECIMAL(2,1) DEFAULT 0);

-- modifying table
ALTER TABLE movies_basic -- we're saying we're about to modify a table
ADD COLUMN box_office_gross FLOAT, -- add a new field with float as a datatype
RENAME COLUMN critics_rating to critic_rating, -- renaming field_name
CHANGE COLUMN director director VARCHAR(50); -- changing the datatype of a field

-- LESSON 3.3 - PRIMARY KEYS AND FOREIGN KEYS
-- PRIMARY KEYS - UNIQUE TO EACH COLUMN VALUES
-- FOREIGN KEYS - PRIMARY KEYS IN ANOTHER TABLE THAT IS LINKED TO THE CURRENT TABLE

-- LESSON 3.4 - IMPORTING DATA FROM EXCEL
-- NAVIGATOR -> MOVIES(TABLE) -> MOVIES_BASIC(TABLE) -> RIGHT-CLICK, THEN TABLE DATA IMPORT WIZARD -> SELECT CORRECT FILE THEN KEEP ON CLICKING NEXT
SELECT * FROM movies.movies_basic; -- have a look at newly imported data

-- CHALLENGE: CREATE NEW NORMALIZED TABLES, SIMILAR DATA TO MOVIES_BASIC BUT IN FIVE TABLES, EACH TABLES WILL HAVE ONE PRIMARY AND POSSIBLY FOREIGN KEYS, POPULATE EACH TABLE WITH THE DATASETS FROM THE EXERCISE FILES

-- LESSON 4.1 - SELECT - this just means return this that we're selecting, we've already learned this at sql programming go check it out
SELECT genre, title -- SELECT field_name
FROM movies.movies_basic; -- FROM main_table.sub_table

-- LESSON 4.2 - REFINE SELECT QUERIES
-- selecting specific no. of rows
SELECT *
FROM movies.movies_basic
LIMIT 5; -- only select 5 rows(records) of data

SELECT *
FROM movies.movies_basic
LIMIT 5, 10; -- start with 5th row end with 10th row | somehow works like offset in sql programming

-- selecting unique values only
SELECT DISTINCT genre
FROM movies_basic;

-- renaming the field names
SELECT title AS "Title", 
	   genre AS "Genre"
FROM movies_basic;

-- organizing by ascending or descending order
SELECT * 
FROM movies_basic
ORDER BY genre ASC; -- default order is asc, if i didn't specify asc it would still be in an ascending order

-- organizing the 1st specified field first then organize the 2nd specified field
SELECT * FROM movies_basic ORDER BY genre, release_year; -- i'm just gonna format it this way so our code wouldn't be too long
 
 -- LESSON 4.3 - USING WHERE CLAUSE - it is somehow like an if statement for sql
 SELECT * FROM movies_basic
 WHERE id >= 10; -- look at your programming language cheatcode to see more logical operators, there are plenty of them, also you could AND, OR, etc. you know them already
 
 -- using like clause to find matching words
 SELECT * FROM movies_basic
 WHERE genre LIKE "Children"; -- you could also use LIKE "c%" to match everything that starts with letter c | % is pretty much like _ | != is equal to <>
 
-- using functions in where clause, again, it functions just like an if statement in other programming languages
SELECT * FROM movies_basic
WHERE LENGTH(title) > 20;

-- LESSON 4.4 - DISPLAY DATA WITH CASE, we're somehow adding a new field into table
-- using if function, only used for single conditions
SELECT title AS 'Title',
IF(critic_rating > 6, 'Good', 'Bad') -- wow, if is a function here in sql and the way it works is just like a ternary operator in c++ 'IF(if condition, is true then do this, is false then do this)'
AS 'Score' -- we'll be using this to prettify the field name
FROM movies_basic;

-- using case statement, this is used for multiple conditions
SELECT title AS 'Title',
CASE
	WHEN critic_rating < 5 THEN 'Bad'
    WHEN critic_rating < 8 THEN 'Decent'
    ELSE 'Good' -- if nothing else is true
END AS 'Score' -- name this field as score
FROM movies_basic;

SELECT * FROM movies_basic;
-- CHALLENGE: DESIGN A QUERY TO DISPLAY DATA FROM MOVIES_BASIC IN A SPECIFIC FORMAT, CAPITALIZATION AND PUNCTUATION MATTER, 
-- 1ST COLUMN IS TITLE 2ND COLUMN IS RELEASED WHERE DATA RELEASED <2000S IS 20TH CENTURY AND >2000S IS 21ST CENTURY, 3RD COLUMN IS DIRECTOR, AND 4TH COLUMN IS REVIEWS | <=5 - BAD, 5.1-7 - DECENT, 7.1-8.9 - GOOD, >=9 - AMAZING
SELECT title AS 'Title', 
IF(release_year < 2000, '20th Century','21st Century') AS 'Released',
director AS 'Director',
CASE
	WHEN critic_rating <= 5 THEN 'Bad' 
    WHEN critic_rating > 5 AND critic_rating <= 7 THEN 'Bad'
    WHEN critic_rating > 7 AND critic_rating <= 8.9 THEN 'Good'
    ELSE 'Amazing'
END AS 'Reviews'
FROM movies_basic;

-- LESSON 5 - CRUD | CREATE(INSERT INTO, VALUES), READ(SELECT), UPDATE(UPDATE, SET), DELETE(DELETE)
-- LESSON 5.1 - USING INSERT to add data into table | CREATE
INSERT INTO movies_basic (title, genre, release_year, director, studio, critic_rating)
VALUES ('Challenge of the Emperor', 'Adventure', 2010, 'Miley Watson', 'Bix', 7.2); -- this is the equivalent of adding 1 record
SELECT * FROM movies_basic; -- have a look at the changes

-- LESSON 5.2 - USING UPDATE to modify data | UPDATE
-- have a look first at the data you wanted to modify
SELECT * FROM movies_basic WHERE director = 'Miley Watson';

-- this would cause an error, this statement below is saying to change where every director is miley watson, you might wrongly update some data with these and i think that's the reason why sql made this resulting to an error but you could disable the error by unchecking the safe updates
UPDATE movies_basic 
SET director = 'Mike Watson'
WHERE director IS 'Miley Watson'

-- try to update with specifics in mind, always
UPDATE movies_basic 
SET director = 'Mike Watson'
WHERE id IS 43;

-- LESSON 5.3 - USING DELETE to obviously delete data | DELETE
-- if you have a database that is huge, delete is not a good idea, you should use truncate, by using truncate and let's say you remove rows 1-4, truncate would start the autoincrement counting again at 1 unlike delete where if you remove rows 1-4 the 1st value in the table would be 5
DELETE -- syntactically looks like select | note: if you have auto increment id
FROM movies_basic
WHERE release_year < 1927;

-- CHALLENGE: CORRECT MISTAKES IN MOVIES_BASIC TABLE, ADD RENCE PERA'S FILM,  CHANGE GENRE Sci-Fi to SF for all fasltead group films, remove all the films garry scott did for lionel brownstone
-- look at data
SELECT * FROM movies_basic;

-- add
INSERT INTO movies_basic (title, genre, release_year, director, studio, critic_rating)
VALUES ('Run for the Forest', 'Drama', 1946, 'Rence Pera', 'Lionel Brownstone', 7.3),
('Luck of the Night', 'Drama', 1951, 'Rence Pera', 'Lionel Brownstone', 6.8),
('Invader Glory', 'Adventure', 1953, 'Rence Pera', 'Studio 60', 5.5);

-- update
UPDATE movies_basic
SET genre = 'SF'
WHERE genre = 'Sci-Fi' AND studio LIKE 'Falstead%';

-- delete
DELETE 
FROM movies_basic
WHERE director = 'Garry Scott' AND studio = 'Lionel Brownstone';

-- look at the changes
SELECT * FROM movies_basic

-- LESSON 6.1 - BASICS OF JOIN
-- CROSS JOIN - MATCH TABLE1(ROW1) TO ALL ROWS OF TABLE2, MATCH TABLE1(ROW2) TO ALL ROWS OF TABLE2, ... YOU GET THE PATTERN
-- INNER JOIN - JOIN ONLY THOSE WITH MATCHING VALUES FROM TWO TABLES, IF TABLE1 DOESNT MATCH ANYTHING WITH TABLE2 DON'T INCLUDE IT
-- OUTER JOIN - JOIN EVERYTHING FROM ONE TABLE1 AND IF TABLE2 DOESN'T HAVE THE MATCHING VALUES WITH TABLE1 LEAVE THEM AT NULL, THERE ARE VERSIONS OF JOIN, LOOK AT YOUR SQL PROGRAMMING CHEATCODE

-- LESSON 6.2 - USING INNER JOIN
-- JOIN VS INNER JOIN, JOIN ONLY KEEPS ONE COPY OF THE COLUMN WHILE INNER JOIN KEEPS EVERYTHING UNLESS SPECIFIED BUT THE FUNCTIONALITY IS ALMOST THE SAME
-- create a 2nd table first to match with the 1st table
CREATE TABLE studio
(id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
studio_name VARCHAR(100),
city VARCHAR(100));

CREATE TABLE titles
(id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
title VARCHAR(100),
genre_id INT,
release_year INT,
director_id INT,
studio_id INT);

SELECT titles.title, studio.city
FROM titles -- 1st table
INNER JOIN studio -- 2nd table, the one you're linking
ON titles.studio_id = studio.id -- linking table1 to table2 with a key that has the same value on two table
ORDER BY titles.title;

-- LESSON 6.3 - USING OUTER JOINS
SELECT * 
FROM movies_basic
RIGHT OUTER JOIN studio -- join everything from studio(right) 
ON movies_basic.studio = studio.studio_name -- if there is a value in studio_name that is not in movies_basic.studio, then studio would be null
ORDER BY movies_basic.studio;











