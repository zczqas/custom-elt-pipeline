{% macro generate_film_ratings() %}

WITH films_with_ratings AS (
    SELECT
        film_id,
        title,
        release_date,
        price,
        rating,
        user_rating,
        {{ generate_ratings() }}
    FROM {{ ref('films') }}
),

films_with_actors AS (
    SELECT
        f.film_id,
        f.title,
        STRING_AGG(a.actor_name, ', ') AS actors
    FROM {{ ref('films') }} AS f
    LEFT JOIN {{ ref('film_actors') }} AS fa ON fa.film_id = f.film_id
    LEFT JOIN {{ ref('actors') }} AS a ON fa.actor_id = a.actor_id
    GROUP BY f.film_id, f.title
)

SELECT
    fwf.*,
    fwa.actors
FROM films_with_ratings AS fwf
LEFT JOIN films_with_actors AS fwa ON fwf.film_id = fwa.film_id

{% endmacro %}