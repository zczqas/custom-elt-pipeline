
  
    

  create  table "destination_db"."public"."film_ratings__dbt_tmp"
  
  
    as
  
  (
    

WITH films_with_ratings AS (
    SELECT
        film_id,
        title,
        release_date,
        price,
        rating,
        user_rating,
        

CASE
    WHEN user_rating >= 4.5 THEN 'Excellent'
    WHEN user_rating >= 4.0 THEN 'Good'
    WHEN user_rating >= 3.0 THEN 'Average'
    ELSE 'Poor'
END AS rating_category


    FROM "destination_db"."public"."films"
),

films_with_actors AS (
    SELECT
        f.film_id,
        f.title,
        STRING_AGG(a.actor_name, ', ') AS actors
    FROM "destination_db"."public"."films" AS f
    LEFT JOIN "destination_db"."public"."film_actors" AS fa ON fa.film_id = f.film_id
    LEFT JOIN "destination_db"."public"."actors" AS a ON fa.actor_id = a.actor_id
    GROUP BY f.film_id, f.title
)

SELECT
    fwf.*,
    fwa.actors
FROM films_with_ratings AS fwf
LEFT JOIN films_with_actors AS fwa ON fwf.film_id = fwa.film_id


  );
  