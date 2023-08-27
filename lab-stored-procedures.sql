/* Instructions
Write queries, stored procedures to answer the following questions:

In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure. Use the following query:

  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.
*/

USE sakila;

delimiter //
CREATE PROCEDURE Category_Movie (IN param1 VARCHAR(10))
begin

SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email AS email
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category f ON f.film_id = i.film_id
JOIN category ca ON ca.category_id = f.category_id
WHERE ca.name COLLATE utf8mb4_general_ci = param1
GROUP BY full_name, email;

END;
//
delimiter ;

CALL Category_Movie("Action");
CALL Category_Movie("Animation");
CALL Category_Movie("Children");


# Write a query to check the number of movies released in each movie category. 

DROP PROCEDURE IF EXISTS Released_Movie;

delimiter //
CREATE PROCEDURE Released_Movie (IN param1 VARCHAR(10))
begin

SELECT param1 AS Category, COUNT(f.film_id) AS Total_Movies
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category ca ON ca.category_id = fc.category_id
WHERE ca.name COLLATE utf8mb4_general_ci = param1;

END;
//
delimiter ;

CALL Released_Movie("Action");

# Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.

DROP PROCEDURE IF EXISTS Count_Movies_By_Category;

DELIMITER //

CREATE PROCEDURE Count_Movies_By_Category(IN minReleaseCount INT)
BEGIN
    SELECT
        ca.name AS category_name,
        COUNT(f.film_id) AS movie_count
    FROM category ca
    JOIN film_category fc ON ca.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    GROUP BY ca.name
    HAVING movie_count > minReleaseCount
    ORDER BY movie_count;
END;
//

DELIMITER ;

CALL Count_Movies_By_Category(50); 
