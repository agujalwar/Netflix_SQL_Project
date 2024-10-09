# Netflix Movies and TV Shows Data Analysis using SQL
![Netflix](https://github.com/agujalwar/Netflix_SQL_Project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Understand Content Catalog: Analyze the distribution of Movies vs. TV Shows, genres, and countries to evaluate the diversity of Netflix’s offerings.
- Identify Content Trends: Examine release patterns over time to discover key trends in Netflix’s content production and acquisition.
- Target Audience Analysis: Assess content ratings to determine the primary audience Netflix serves and identify potential gaps in age group or content type.
- Analyze Global Reach: Investigate which countries produce the most content for Netflix and explore regional opportunities for growth.
- Popular Genres and Directors: Identify the most successful genres, directors, and content categories to inform future production and licensing decisions.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
CREATE TABLE netflix_shows (
    show_id VARCHAR(10) PRIMARY KEY,
    show_type VARCHAR(20),
    title VARCHAR(255),
    director VARCHAR(255),
    show_cast TEXT,
    country VARCHAR(255),
    date_added DATE,
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(50),
    listed_in TEXT,
    description TEXT
);
```
### Total shows in netflix
```sql
select count(show_id) as Total_Shows
from netflix_shows;
```
---------------------------------------------------------------------------

### Total shows added to Netflix as per year
```sql
select count(show_id) as Total_Shows,
		EXTRACT(YEAR FROM date_added) AS year_added
from netflix_shows
group by EXTRACT(YEAR FROM date_added)
order by EXTRACT(YEAR FROM date_added);
```
---------------------------------------------------------------------------

### Total shows as per ratings
```sql
select 	rating,
		count(show_id) as Total_Shows
from netflix_shows
group by rating
order by total_shows desc;
```
---------------------------------------------------------------------------

### Total Movies and TV shows 
```sql
select show_type,
		count(show_id) 
		from netflix_shows
group by show_type;
```
---------------------------------------------------------------------------

### checking duplicates
```sql
select 
    count(show_id) as total_count,
    count(distinct show_id) as distinct_count,
    (count(show_id) - count(distinct show_id)) as no_of_duplicates
from netflix_shows;
```
---------------------------------------------------------------------------

### Find no of shows as per countries
```sql
select unnest(string_to_array(country, ', ')) AS Country_list , count(*) as Total_count
from netflix_shows
group by country_list
order by Total_count desc;
```
---------------------------------------------------------------------------

### Find the average movie duration
```sql
SELECT ROUND(AVG(CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER))) AS avg_movie_duration
FROM netflix_shows
WHERE show_type = 'Movie' AND duration LIKE '%min%';
```
---------------------------------------------------------------------------

### Find the most Frequent Actors/Actresses
```sql
SELECT unnest(string_to_array(show_cast, ', ')) AS actor, COUNT(*) AS count
FROM netflix_shows
GROUP BY actor
ORDER BY count DESC
LIMIT 10;
```
---------------------------------------------------------------------------

### Most common rating for Movies and TV shows
```sql
select 	show_type,
		rating,
		total_count
from (
select 	show_type,
		rating, 
		count(show_id) as total_count,
		rank() over(partition by show_type order by count(*) desc ) as ranking
from netflix_shows
group by 1,2 
order by 3 desc
) as t1
where ranking = 1
;
```
---------------------------------------------------------------------------

### List all the movies released in year 2020 
```sql
select title,
release_year
from netflix_shows
where show_type = 'Movie' and
release_year= 2020 
;
```
---------------------------------------------------------------------------

### Find the top 5 countries with the most content on Netflix.
```sql
SELECT unnest(string_to_array(country, ', ')) AS country_new,
	COUNT(show_id) AS total_count
	FROM netflix_shows
	GROUP BY country_new
	ORDER BY total_count DESC
LIMIT 5;
```
---------------------------------------------------------------------------

### Identify the longest movie 
```sql
select title, 
		CAST(SUBSTRING(duration,1,POSITION(' ' IN duration)-1)as INT) as maximun_lenght
from netflix_shows
where show_type = 'Movie' and duration is not null
order by maximun_lenght  desc
LIMIT 1;
```
---------------------------------------------------------------------------

### Find content added in last 5 years 
```sql
select  title,
		EXTRACT(YEAR FROM date_added) AS year_added
from netflix_shows
where date_added is not null
and date_added >= current_date - interval '5 years'
order by year_added desc
;

select current_date, current_date - interval '5 years';
```
---------------------------------------------------------------------------

### Find all the movies and TV shows directed by 'Aitor Arregi' 
```sql
select *
from netflix_shows
where director ilike '%aitor Arregi%';
```
---------------------------------------------------------------------------

### Find top 5 Directors with most Movies and TV shows 
```sql
select unnest(string_to_array(director, ',')), count(show_id) as count_directors
from netflix_shows
group by 1
order by 2 desc;

select 	unnest(string_to_array(director, ',')), 
		count(show_id) as count_directors,
		rank() over( order by count(show_id)  desc) as ranking,
		row_number() over( order by count(show_id)  desc) as row_numbers,
		dense_rank() over( order by count(show_id)  desc) as dens_ranking
		
from netflix_shows
group by 1;

select * 
from (
select 	unnest(string_to_array(director, ',')), 
		count(show_id) as count_directors,
		row_number() over( order by count(show_id)  desc) as row_num
from netflix_shows
group by 1 ) as t1
where row_num <=5
;
```
--------------------------------------------------------------------------------------

### List all the TV shows with more than 5 seasons.
```sql
select Title
from
(
select 	title, 
		duration,
		CAST(SUBSTRING(duration,1,POSITION(' ' IN duration)-1)as INT) as seasons
from netflix_shows
where show_type like 'TV Show'
) as t1
where seasons >5
;
#### OR

select 	*
--		split_part (duration,' ',1) as seasons
from 	netflix_shows
where 	show_type like 'TV Show'
		and split_part (duration,' ',1):: numeric > 5
;
```
-----------------------------------------------------------------------------------
### Count the no of content items in each genre.
```sql
select listed_in
from netflix_shows;

SELECT unnest(string_to_array(listed_in, ', ')) AS genre,
	COUNT(show_id) AS total_count
	FROM netflix_shows
	GROUP BY genre
	ORDER BY total_count DESC;
```
-----------------------------------------------------------------------------------
###  List all the movies that are documentaries.
```sql
select *
from netflix_shows
where listed_in Ilike '%documentaries%'
;
```
-----------------------------------------------------------------------------------
### Find all the content without directors.
```sql
select * 
from Netflix_shows
where director is null
;
```
-------------------------------------------------------------------------------------

### Find how many movies actor Anupam Kher appeared in last 10 years.
```sql
select * 
from netflix_shows
where show_cast ILIKE '%anupam kher%'
and release_year > Extract(year from current_date) - 10
;

select current_date, current_date - interval '10 years'
select Extract(year from current_date) - 10

```
------------------------------------------------------------------------------------

### Categorize the content based on the presence of the keywords 'kill' and 'violence' in
### the description field. Label content containing these keywords as 'Bad' and all other
### content as 'Good'. Count how many items fall into each category. 
```sql
with T1
AS
(
select *, 
	CASE 
	when 	description iLike '%kill%' 
			or
			description iLike '%violence%' Then 'Bad_Content'
		Else 	'Good_Content'
	END Content_category
from netflix_shows
)
select 
Content_category,
count(*) as total_count
from T1
group by Content_category
;
```


