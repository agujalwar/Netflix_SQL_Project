select * from netflix_shows
--limit 1;

/* Total shows in netflix */
select count(show_id) as Total_Shows
from netflix_shows;
---------------------------------------------------------------------------

-- Total shows added to Netflix as per year
select count(show_id) as Total_Shows,
		EXTRACT(YEAR FROM date_added) AS year_added
from netflix_shows
group by EXTRACT(YEAR FROM date_added)
order by EXTRACT(YEAR FROM date_added);
---------------------------------------------------------------------------

-- Total shows as per ratings
select 	rating,
		count(show_id) as Total_Shows
from netflix_shows
group by rating
order by total_shows desc;
---------------------------------------------------------------------------

-- Total Movies and TV shows 
select show_type,
		count(show_id) 
		from netflix_shows
group by show_type;
---------------------------------------------------------------------------

/*checking duplicates*/
select 
    count(show_id) as total_count,
    count(distinct show_id) as distinct_count,
    (count(show_id) - count(distinct show_id)) as no_of_duplicates
from netflix_shows;
---------------------------------------------------------------------------

-- Find no of shows as per countries
select unnest(string_to_array(country, ', ')) AS Country_list , count(*) as Total_count
from netflix_shows
group by country_list
order by Total_count desc;
---------------------------------------------------------------------------

-- Find the average movie duration
SELECT ROUND(AVG(CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER))) AS avg_movie_duration
FROM netflix_shows
WHERE show_type = 'Movie' AND duration LIKE '%min%';
---------------------------------------------------------------------------

/* Find the most Frequent Actors/Actresses */
SELECT unnest(string_to_array(show_cast, ', ')) AS actor, COUNT(*) AS count
FROM netflix_shows
GROUP BY actor
ORDER BY count DESC
LIMIT 10;
---------------------------------------------------------------------------

/* Most common rating for Movies and TV shows */
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
---------------------------------------------------------------------------

/* List all the movies released in year 2020 */
select title,
release_year
from netflix_shows
where show_type = 'Movie' and
release_year= 2020 
;
---------------------------------------------------------------------------

/* Find the top 5 countries with the most content on Netflix */

SELECT unnest(string_to_array(country, ', ')) AS country_new,
	COUNT(show_id) AS total_count
	FROM netflix_shows
	GROUP BY country_new
	ORDER BY total_count DESC
LIMIT 5;
---------------------------------------------------------------------------

/* Identify the longest movie */

select title, 
		CAST(SUBSTRING(duration,1,POSITION(' ' IN duration)-1)as INT) as maximun_lenght
from netflix_shows
where show_type = 'Movie' and duration is not null
order by maximun_lenght  desc
LIMIT 1;
---------------------------------------------------------------------------

/* Find content added in last 5 years */
select  title,
		EXTRACT(YEAR FROM date_added) AS year_added
from netflix_shows
where date_added is not null
and date_added >= current_date - interval '5 years'
order by year_added desc
;

select current_date, current_date - interval '5 years';
---------------------------------------------------------------------------

/* Find all the movies and TV shows directed by 'Aitor Arregi' */
select *
from netflix_shows
where director ilike '%aitor Arregi%';
---------------------------------------------------------------------------

/* Find top 5 Directors with most Movies and TV shows */
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
--------------------------------------------------------------------------------------

/* List all the TV shows with more than 5 seasons */
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
-- OR

select 	*
--		split_part (duration,' ',1) as seasons
from 	netflix_shows
where 	show_type like 'TV Show'
		and split_part (duration,' ',1):: numeric > 5
;

-----------------------------------------------------------------------------------
/* Count the no of content items in each genre */
select listed_in
from netflix_shows;

SELECT unnest(string_to_array(listed_in, ', ')) AS genre,
	COUNT(show_id) AS total_count
	FROM netflix_shows
	GROUP BY genre
	ORDER BY total_count DESC;
-----------------------------------------------------------------------------------
/*  List all the movies that are documentaries */

select *
from netflix_shows
where listed_in Ilike '%documentaries%'
;

-----------------------------------------------------------------------------------
/* Find all the content without directors */

select * 
from Netflix_shows
where director is null
;
-------------------------------------------------------------------------------------

/* Find how many movies actor Anupam Kher appeared in last 10 years */
select * 
from netflix_shows
where show_cast ILIKE '%anupam kher%'
and release_year > Extract(year from current_date) - 10
;

select current_date, current_date - interval '10 years'
select Extract(year from current_date) - 10
------------------------------------------------------------------------------------

/* Categorize the content based on the presence of the keywords 'kill' and 'violence' in
the description field. Label content containing these keywords as 'Bad' and all other
content as 'Good'. Count how many items fall into each category. */

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



























