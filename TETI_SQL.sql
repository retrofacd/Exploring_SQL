USE sakila;
SHOW TABLES;
SELECT first_name,last_name FROM actor;

SELECT UPPER(CONCAT(first_name,' ',last_name)) as ACTOR_NAME FROM actor;

SELECT first_name, last_name, actor_id FROM actor
WHERE first_name like "Joe";

SELECT first_name,last_name,actor_id FROM actor
WHERE last_name like "%GEN%";

SELECT first_name,last_name,actor_id FROM actor
WHERE last_name like "%LI%"
ORDER BY last_name,first_name;

SELECT country_id,country FROM country
WHERE country in ('Afghanistan','Bangladesh','China');

SELECT * FROM actor;
ALTER TABLE actor ADD COLUMN description blob;

SELECT * FROM actor;
ALTER TABLE actor 
DROP COLUMN description;

SELECT last_name,COUNT(last_name) AS last_name_popularity
FROM actor
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;

SELECT last_name,COUNT(last_name)
AS last_name_popularity
FROM actor
GROUP BY last_name
HAVING COUNT(last_name)>=2
ORDER BY COUNT(last_name)ASC;

SELECT first_name,last_name,actor_id FROM actor
WHERE first_name='GROUCHO' 
AND last_name='WILLIAMS';

UPDATE actor
SET first_name='HARPO'
WHERE first_name='GROUCHO'
AND last_name='WILLIAMS';

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

SHOW CREATE TABLE sakila.address;

SELECT *  FROM staff AS s;
SELECT * FROM address AS a;

SELECT s.first_name,s.last_name,a.address
FROM staff AS s
INNER JOIN address AS a
ON s.address_id=a.address_id;

SELECT * FROM payment AS p;

SELECT s.first_name,s.last_name,SUM(amount)
FROM staff AS s
INNER JOIN payment AS p
ON p.staff_id=s.staff_id
WHERE MONTH(p.payment_date)=08 
AND YEAR(p.payment_date)=2005
GROUP BY s.staff_id;

SELECT * FROM film_actor AS fa;
SELECT * FROM film AS f;

SELECT f.title, COUNT(fa.actor_id) AS 'actors'
FROM film_actor AS fa
INNER JOIN film as f
ON f.film_id = fa.film_id
GROUP BY f.title
ORDER BY actors DESC;


SELECT * FROM film AS f;
SELECT * FROM inventory AS i;

SELECT f.title, COUNT(inventory_id)
FROM film AS f
INNER JOIN inventory AS i
ON f.film_id=i.film_id
WHERE title='HUNCHBACK IMPOSSIBLE'
GROUP BY f.title;

SELECT * FROM payment AS p;
SELECT * FROM customer AS c;

SELECT c.first_name,c.last_name,SUM(p.amount) AS 'Total Amount Paid'
FROM payment AS p
JOIN customer AS c
ON p.customer_id=c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name ASC;

SELECT title
FROM film
WHERE title LIKE 'K%'
OR title LIKE 'Q%'
AND language_id IN
(SELECT language_id FROM language WHERE name = 'English');

SELECT first_name, last_name FROM actor
WHERE actor_id IN (SELECT actor_id FROM film_actor
WHERE film_id =(SELECT film_id FROM film WHERE title = "Alone Trip"));

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

SELECT * FROM rental;

SELECT title, COUNT(title) as 'rentals'
FROM film AS f
JOIN inventory AS i
ON f.film_id = i.film_id
JOIN rental AS r
ON (i.inventory_id = r.inventory_id)
GROUP by title
ORDER BY rentals DESC;

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

SELECT * FROM rental;

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

SELECT * FROM top_five_revenue;

DROP VIEW top_five_revenue;