# Exploring_SQL
1a. Display the first and last names of all actors from the table actor.
USE sakila;
SHOW TABLES;
SELECT first_name,last_name FROM actor;

1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
“The CONCAT() function concatenates two or more expressions together.”

SELECT UPPER(CONCAT(first_name,' ',last_name)) as ACTOR_NAME FROM actor;

2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT first_name, last_name, actor_id FROM actor
WHERE first_name like "Joe";

2b. Find all actors whose last name contain the letters GEN:
SELECT first_name,last_name,actor_id FROM actor
WHERE last_name like "%GEN%";

2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT first_name,last_name,actor_id FROM actor
WHERE last_name like "%LI%"
ORDER BY last_name,first_name;

2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id,country FROM country
WHERE country in ('Afghanistan','Bangladesh','China');

3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
“Most VARCHAR operations are much faster than CLOB / BLOB operations. “

SELECT * FROM actor;
ALTER TABLE actor ADD COLUMN description blob;


3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column
SELECT * FROM actor;
ALTER TABLE actor
DROP COLUMN description;


4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name,COUNT(last_name) AS last_name_popularity
FROM actor
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;

4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name,COUNT(last_name)
AS last_name_popularity
FROM actor
GROUP BY last_name
HAVING COUNT(last_name)>=2
ORDER BY COUNT(last_name)ASC;


4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
SELECT first_name,last_name,actor_id FROM actor
WHERE first_name='GROUCHO' 
AND last_name='WILLIAMS';


UPDATE actor
SET first_name='HARPO'
WHERE first_name='GROUCHO'
AND last_name='WILLIAMS';


4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
SELECT first_name,last_name,actor_id FROM actor
WHERE first_name='HARPO' 
AND last_name='WILLIAMS';

UPDATE actor
SET first_name=(CASE WHEN first_name='HARPO' THEN 'GROUCHO' END)
WHERE
actor_id = 172; 

SELECT first_name,last_name,actor_id FROM actor
WHERE first_name='GROUCHO' 
AND last_name='WILLIAMS';

5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8

6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT *  FROM staff AS s;
SELECT * FROM address AS a;

SELECT s.first_name,s.last_name,a.address
FROM staff AS s
INNER JOIN address AS a
ON s.address_id=a.address_id;

6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT * FROM payment AS p;

SELECT s.first_name,s.last_name,SUM(amount)
FROM staff AS s
INNER JOIN payment AS p
ON p.staff_id=s.staff_id
WHERE MONTH(p.payment_date)=08 
AND YEAR(p.payment_date)=2005
GROUP BY s.staff_id;

6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT * FROM film_actor AS fa;
SELECT * FROM film AS f;

SELECT f.title, COUNT(fa.actor_id) AS 'actors'
FROM film_actor AS fa
INNER JOIN film as f
ON f.film_id = fa.film_id
GROUP BY f.title
ORDER BY actors DESC;

6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT * FROM film AS f;
SELECT * FROM inventory AS i;

SELECT f.title, COUNT(inventory_id)
FROM film AS f
INNER JOIN inventory AS i
ON f.film_id=i.film_id
WHERE title='HUNCHBACK IMPOSSIBLE'
GROUP BY f.title;

6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT * FROM payment AS p;
SELECT * FROM customer AS c;

SELECT c.first_name,c.last_name,SUM(p.amount) AS 'Total Amount Paid'
FROM payment AS p
JOIN customer AS c
ON p.customer_id=c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name ASC;

7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE title LIKE 'K%'
OR title LIKE 'Q%'
AND language_id IN
(SELECT language_id FROM language WHERE name = 'English');

7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name FROM actor
WHERE actor_id IN (SELECT actor_id FROM film_actor
WHERE film_id =(SELECT film_id FROM film WHERE title = "Alone Trip"));

7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT * FROM customer AS cus;
SELECT * FROM country AS ctr;
SELECT * FROM city AS cit; 

SELECT first_name, last_name,email, country FROM customer AS cus
JOIN address AS a
ON cus.address_id = a.address_id
JOIN city AS cit
ON a.city_id = cit.city_id
JOIN country AS ctr
ON cit.country_id = ctr.country_id
WHERE ctr.country = 'canada';

7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT * FROM film_category AS fc;
SELECT * FROM film AS f;
SELECT * FROM category AS c;

SELECT title, name FROM
film AS f
JOIN film_category AS fc
ON f.film_id=fc.film_id
JOIN category AS c
ON c.category_id=fc.category_id
WHERE name='Family';

7e. Display the most frequently rented movies in descending order.
SELECT * FROM rental;

SELECT title, COUNT(title) as 'rentals'
FROM film AS f
JOIN inventory AS i
ON f.film_id = i.film_id
JOIN rental AS r
ON (i.inventory_id = r.inventory_id)
GROUP by title
ORDER BY rentals DESC;

7f. Write a query to display how much business, in dollars, each store brought in.
SELECT * FROM payment AS p;
SELECT * FROM store AS s;

SELECT s.store_id, SUM(amount) AS gross
FROM payment AS p
JOIN rental AS r
ON p.rental_id = r.rental_id
JOIN inventory AS i
ON i.inventory_id = r.inventory_id
JOIN store AS s
ON s.store_id = i.store_id
GROUP BY s.store_id;

7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, city, country
FROM store AS s
JOIN customer AS cu
ON s.store_id = cu.store_id
JOIN staff AS st
ON s.store_id = st.store_id
JOIN address AS a
ON cu.address_id = a.address_id
JOIN city AS ci
ON a.city_id = ci.city_id
JOIN country AS coun
ON ci.country_id = coun.country_id;

7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name AS 'genre', SUM(p.amount) AS 'gross' 
FROM category AS c
JOIN film_category AS fc 
ON c.category_id=fc.category_id
JOIN inventory AS i 
ON fc.film_id=i.film_id
JOIN rental AS r 
ON i.inventory_id=r.inventory_id
JOIN payment AS p 
ON r.rental_id=p.rental_id
GROUP BY c.name ORDER BY gross DESC
LIMIT 5;

8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_revenue AS
SELECT c.name AS 'genre', SUM(p.amount) AS 'gross' 
FROM category AS c
JOIN film_category AS fc 
ON c.category_id=fc.category_id
JOIN inventory AS i 
ON fc.film_id=i.film_id
JOIN rental AS r 
ON i.inventory_id=r.inventory_id
JOIN payment AS p 
ON r.rental_id=p.rental_id
GROUP BY c.name ORDER BY gross DESC
LIMIT 5;

8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_revenue;

8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_revenue;
