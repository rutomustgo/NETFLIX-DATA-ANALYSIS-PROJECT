-- NETFLIX PROJECT

-- CREATING TABLES


DROP TABLE IF EXISTS NETFLIX;
CREATE TABLE NETFLIX(
	show_id varchar(10),
	type varchar(10),
	title varchar(150),
	director varchar(210),
	casts varchar(900),
	country varchar(150),
	date_added varchar(50),
	release_year INT,
	rating VARCHAR(10),
	duration varchar(10),
	listed_in varchar(100),
	description varchar(270)
);


SELECT* FROM NETFLIX;

-- checking the importation of data

SELECT
count(*) as total_content
FROM NETFLIX;

-- 1. Count the Number of Movies vs TV Shows

SELECT
TYPE,
COUNT(*) AS TOTAL
FROM NETFLIX
GROUP BY 1;

-- 2. Find the Most Common Rating for Movies and TV Shows


SELECT
TYPE,
RATING
FROM
(

	SELECT
	TYPE,
	RATING,
	COUNT(*),
	RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
	FROM NETFLIX
	GROUP BY 1,2
	)AS T1
	WHERE
	RANKING=1;


-- 3. List All Movies Released in a Specific Year (e.g., 2020)


SELECT *
FROM netflix
WHERE LOWER(type) = 'movie'
AND release_year = 2020;



-- 4. Find the Top 5 Countries with the Most Content on Netflix

 SELECT 
    country,
    COUNT(*) AS total_titles
FROM 
    netflix
WHERE 
    country IS NOT NULL
GROUP BY 
    country
ORDER BY 
    total_titles DESC
LIMIT 5;


-- or


select
	UNNEST(STRING_TO_ARRAY(COUNTRY,',')),
	count(*) as total_content
from netflix
group by 1
order by 2 desc
limit 5;


-- 5. Identify the Longest Movie

select * from netflix
where
	lower(type)='movie'
	and 
	duration=(select max(duration) from netflix);


-- 6. Find Content Added in the Last 5 Years

select
*
from netflix
where
	TO_DATE(date_added,'Month,dd,yyyy')>=current_date - interval '5 years')
    
    


-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

select* from netflix
where
	director ilike '%Rajiv Chilaka%'


--8. List All TV Shows with More Than 5 Seasons


select
*
from netflix
where
	lower(type)= 'tv show'
	and
	split_part(duration,' ', 1)::numeric >5 

	

--9. Count the Number of Content Items in Each Genre

select
unnest(string_to_array(listed_in,','))as genre,
count(*)
from netflix
group by 1


--10.Find each year and the average numbers of content release in India on netflix.

select
to_date(date_added,'month dd ,yyyy')as date,
*
from netflix
where
	country='india'





--11. List All Movies that are Documentaries

SELECT * 
FROM netflix
WHERE listed_in ILIKE '%Documentaries%';


--12. Find All Content Without a Director

SELECT * 
FROM netflix
WHERE director IS NULL;


--13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT* FROM NETFLIX
WHERE
	casts ILIKE '%salman khan%'
	and
	release_year>extract(year from current_date) -10

--14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India


select
unnest(string_to_array(casts,',')) as actors,
count(*) as total_content
from netflix
where country ilike '%india%'
group by 1
order by 2 desc
limit 10


-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
--Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.


SELECT 
    CASE 
        WHEN LOWER(description) LIKE '%kill%' OR LOWER(description) LIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS content_category,
    COUNT(*) AS total_count
FROM 
    netflix
WHERE 
    description IS NOT NULL
GROUP BY 
    content_category;


--OR


with new_table
as
(
SELECT
*,
case
when
	description ilike '%kill%'
	or
	description ilike '%violence%' then 'bad_content'
	else 'good_content'
end category	
from netflix
)

select
category,
count(*)as total_content
from new_table
group by 1






























	


















































