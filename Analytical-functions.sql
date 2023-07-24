-- Using Sakila Database ( If you don't have it, follow the instructions of installing the db from the previous lesson).

-- 1. find the running total of rental payments for each customer in the payment table, ordered by payment date. 
-- By selecting the customer_id, payment_date, and amount columns from the payment table, and then applying the SUM function to the amount column within each customer_id partition, ordering by payment_date.
USE sakila;
SELECT 
    customer_id, 
    payment_date, 
    amount,
    SUM(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS running_total
FROM payment
ORDER BY customer_id, payment_date;

-- 2.  find the rank and dense rank of each payment amount within each payment date by selecting the payment_date and amount columns from the payment table, 
-- and then applying the RANK and DENSE_RANK functions to the amount column within each payment_date partition, ordering by amount DESC.

SELECT 
    payment_date, 
    amount,
    RANK() OVER (PARTITION BY payment_date ORDER BY amount DESC) AS rank_val,
    DENSE_RANK() OVER (PARTITION BY payment_date ORDER BY amount DESC) AS dense_rank_val
FROM payment
ORDER BY payment_date, amount DESC;


-- 3. find the ranking of each film based on its rental rate, within its respective category. 

SELECT
    f.film_id,
    f.title,
    c.name AS category,
    f.rental_rate,
    RANK() OVER (PARTITION BY c.category_id ORDER BY f.rental_rate) AS ranking_within_category
FROM
    film f
JOIN
    film_category fc ON f.film_id = fc.film_id
JOIN
    category c ON fc.category_id = c.category_id
ORDER BY
    c.category_id, ranking_within_category;
    
-- 4.(OPTIONAL) update the previous query from above to retrieve only the top 5 films within each category

    SELECT
    film_id,
    title,
    category,
    rental_rate,
    ranking_within_category
FROM
    (
		SELECT
            f.film_id,
            f.title,
            c.name AS category,
            f.rental_rate,
            RANK() OVER (PARTITION BY c.category_id ORDER BY f.rental_rate) AS ranking_within_category
        FROM
            film f
        JOIN
            film_category fc ON f.film_id = fc.film_id
        JOIN
            category c ON fc.category_id = c.category_id
    ) ranked_films
WHERE
    ranking_within_category <= 5
ORDER BY
    category, ranking_within_category;

