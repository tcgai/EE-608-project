create database movie;

use movie;
#-------------------------general
drop tables if exists movie_general;
create table movie_general(
Id Int,
Budget double,
popularity double,
release_date date,
release_year INT,
revenue bigint,
runtime int,
tagline Varchar(200),
title varchar(2000),
vote_average decimal(3,1),
vote_count int
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/tmdb_5000_movies_modified.csv'
INTO TABLE movie_general
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Id,Budget,popularity,@release_date,@release_year,revenue,@runtime,@tagline,title,vote_average,vote_count)
set
release_date = nullif(@release_date,''),
release_year = nullif(@release_year,''),
runtime = nullif(@runtime,''),
tagline = nullif(@tagline,'');

#------------------------actor
drop tables if exists actor;
create table actor(
id int,
actor1 Varchar(50),
actor2 Varchar(50),
actor3 Varchar(50)
);
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/movies_Actor.csv'
INTO TABLE actor
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


#---------------category
drop tables if exists category;
create table category(
id	varchar(20),
Action varchar(20),
Adventure varchar(20),
Fantasy	varchar(20),
Science_Fiction varchar(20),
Crime varchar(20),	
Drama varchar(20),	
Thriller varchar(20),
Animation varchar(20),
Family varchar(20),	
Western varchar(20),	
Comedy varchar(20),	
Romance varchar(20),	
Horror varchar(20),	
Mystery varchar(20),	
History	varchar(20),
War varchar(20),
Music varchar(20),	
Documentary varchar(20),	
Foreigner varchar(20)
);
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/movies_category.csv'
INTO TABLE category
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

#----------keywords
drop tables if exists keywords;
create table keywords(
id int,
woman_director int,	
independent_film int,	
duringcreditsstinger int,	
based_on_novel int,
murder int,	
aftercreditsstinger int,	
violence int,
dystopia int,	
sport int,	
revenge int
);
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/movies_keywords.csv'
INTO TABLE keywords
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

#-----------------country
drop tables if exists country;
create table country(
id int,
couontries Varchar(100)
);
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/movies_country.csv'
INTO TABLE country
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

#-----cannot only trust on popularity, because for most of them the vote_avg is not high
select title,popularity, tagline,vote_average 
from movie_general
order by popularity Desc
limit 10;

#----------cannot only trust on vote_avg becuase for most of movies, the popularity is low 
select title, popularity, tagline,vote_average
from movie_general
order by vote_average desc
limit 20;

#--------------cannot trust on budget, beause for most of them the vote is not high
select release_date,title, budget, revenue, vote_average,popularity
from movie_general
order by revenue desc
limit 20;



#-----------------
# transform to useful message for category 
SET SQL_SAFE_UPDATES = 0;
UPDATE category
SET Action = 'Action'
WHERE Action = '1';
UPDATE category
SET Action = ''
WHERE Action = '0';

UPDATE category
SET Adventure = 'Adventure'
WHERE Adventure = '1';
UPDATE category
SET Adventure = ''
WHERE Adventure = '0';

UPDATE category
SET Fantasy = 'Fantasy'
WHERE Fantasy = '1';
UPDATE category
SET Fantasy = ''
WHERE Fantasy = '0';

UPDATE category
SET Science_fiction = 'Science_fiction'
WHERE Science_fiction = '1';
UPDATE category
SET Science_fiction = ''
WHERE Science_fiction = '0';

UPDATE category
SET Crime = 'Crime'
WHERE Crime = '1';
UPDATE category
SET Crime = ''
WHERE Crime = '0';

UPDATE category
SET Drama = 'Drama'
WHERE Drama = '1';
UPDATE category
SET Drama = ''
WHERE Drama = '0';

UPDATE category
SET Thriller = 'Thriller'
WHERE Thriller = '1';
UPDATE category
SET Thriller = ''
WHERE Thriller = '0';

UPDATE category
SET Animation = 'Animation'
WHERE Animation = '1';
UPDATE category
SET Animation = ''
WHERE Animation = '0';

UPDATE category
SET Family = 'Family'
WHERE Family = '1';
UPDATE category
SET Family = ''
WHERE Family = '0';

UPDATE category
SET Western = 'Western'
WHERE Western = '1';
UPDATE category
SET Western = ''
WHERE Western = '0';

UPDATE category
SET Comedy = 'Comedy'
WHERE Comedy = '1';
UPDATE category
SET Comedy = ''
WHERE Comedy = '0';

UPDATE category
SET Romance = 'Romance'
WHERE Romance = '1';
UPDATE category
SET Romance = ''
WHERE Romance = '0';

UPDATE category
SET Horror = 'Horror'
WHERE Horror = '1';
UPDATE category
SET Horror = ''
WHERE Horror = '0';

UPDATE category
SET Mystery = 'Mystery'
WHERE Mystery = '1';
UPDATE category
SET Mystery = ''
WHERE Mystery = '0';

UPDATE category
SET History = 'History'
WHERE History = '1';
UPDATE category
SET History = ''
WHERE History = '0';

UPDATE category
SET War = 'War'
WHERE War = '1';
UPDATE category
SET War = ''
WHERE War = '0';

UPDATE category
SET Music = 'Music'
WHERE Music = '1';
UPDATE category
SET Music = ''
WHERE Music = '0';

UPDATE category
SET Documentary = 'Documentary'
WHERE Documentary = '1';
UPDATE category
SET Documentary = ''
WHERE Documentary = '0';

UPDATE category
SET Foreigner = 'Foreigner'
WHERE Foreigner = '1';
UPDATE category
SET Foreigner = ''
WHERE Foreigner = '0';

DROP VIEW if exists categories;
CREATE VIEW categories AS
SELECT id, CONCAT(Action,' ',Adventure,' ',Fantasy,' ',Science_fiction,' ',Crime,' ',Drama,' ',Thriller,' ',Animation,' ',Family,' ',Western,' ',Comedy,' ',Romance,' ',
Horror,' ',Mystery,' ',History,' ',War,' ',Music,' ',Documentary,' ',Foreigner) as categories
from category;

#--------------- join some information with category
select m.title, m.release_date, m.popularity, m.budget, m.revenue, m.vote_average,c.categories
from movie_general m
inner join categories c
on m.Id = c.Id
order by popularity desc
limit 10;


#-------- cannot trust on popularity because people watching movies more and more frequently.
select release_year, count(distinct(Id)) as Number_of_movies, avg(popularity) as average_popularity 
from movie_general
group by release_year
order by release_year DESC;



## find the most famous actors
select m.title, a.actor1, a.actor2, a.actor3
from movie_general m
join actor a
on m.Id = a.Id
where m.popularity>200;

#----------- 
select * 
from actor a1, actor a2
where a1.Id > a2.Id and a1.actor1 = a2.actor2 and a1.actor1 not like 'unknown'
and a1.actor2 not like 'unknown' and a1.actor3 not like 'unknown';



