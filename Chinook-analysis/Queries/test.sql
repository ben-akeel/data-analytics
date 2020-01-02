/* The Chinook database contains all invoices from the beginning of 2009 till the end of 2013. The employees at Chinook store are interested in seeing all invoices that happened in 2013 only. Using the Invoice table, write a query that returns all the info of the invoices in 2013. 
*/

SELECT * 
FROM Invoice
WHERE Invoice.InvoiceDate BETWEEN '2013-01-01' AND '2014-01-01'
ORDER BY Invoice.InvoiceDate;


/*
The Chinook team decided to run a marketing campaign in Brazil, Canada, india, and Sweden. Using the customer table, write a query that returns the first name, last name, and country for all customers from the 4 countries.
*/

SELECT c.FirstName, c.LastName, c.Country
FROM Customer c
WHERE c.Country IN ('Brazil', 'Canada', 'India', 'Sweden');


/*
Using the Track and Album tables, write a query that returns all the songs that start with the letter 'A' and the composer field is not empty. Your query should return the name of the song, the name of the composer, and the title of the album.
*/

SELECT t.NAME SNAME, t.Composer CNAME, a.Title
FROM Track t
JOIN Album a
ON t.AlbumId = a.AlbumId
WHERE t.Name LIKE 'A%' AND t.Composer LIKE '%';


/*
The Chinook team would like to throw a promotional Music Festival for their top 10 cutomers who have spent the most in a single invoice. Write a query that returns the first name, last name, and invoice total for the top 10 invoices ordered by invoice total descending.
*/

SELECT c.FirstName, c.LastName, i.Total
FROM Invoice i
JOIN Customer c
ON i.CustomerId = c.CustomerId
ORDER BY i.TOTAL DESC
LIMIT 10;

/*
Use the Invoice table to determine the countries that have the most invoices. Provide a table of BillingCountry and Invoices ordered by the number of invoices for each country. The country with the most invoices should appear first.
*/

select BillingCountry, count(billingCountry) noOfBills
from invoice
group by 1
order by 2 desc;



/*
We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns the 1 city that has the highest sum of invoice totals. Return both the city name and the sum of all invoice totals.
*/

select BillingCity, sum(total) TotalSpent
from invoice
group by 1
order by 2 desc
limit 1;


/*
The customer who has spent the most money will be declared the best customer. Build a query that returns the person who has spent the most money. I found the solution by linking the following three: Invoice, InvoiceLine, and Customer tables to retrieve this information, but you can probably do it with fewer!
*/

select c.customerid, c.FirstName, c.Lastname, sum(i.total) customerTotal
from invoice i
join customer c
on c.customerid = i.customerid
group by 1, 2, 3
order by 4 desc
limit 1;


/*
The team at Chinook would like to identify all the customers who listen to Rock music. Write a query to return the email, first name, last name, and Genre of all Rock Music listeners. Return your list ordered alphabetically by email address starting with 'A'.
*/

select distinct c.email, c.firstname, c.lastname, g.name
from customer c
join invoice i
on c.customerid = i.customerid
join invoiceline 
on invoiceline.invoiceid = i.invoiceid
join track
on track.trackid = invoiceline.trackid
join genre g
on g.genreid = track.genreid
where g.name = 'Rock'
order by 1;


/*
Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount.

You should only need to use the Customer and Invoice tables.
*/

WITH tempo1 AS 
(
SELECT   c.CustomerId, c.FirstName, c.LastName,c.Country,SUM(i.Total) custotal
FROM 
Customer c
JOIN Invoice i
ON c.CustomerId = i.CustomerId
GROUP BY 1, 2, 3, 4
)

SELECT tempo1.*
FROM tempo1
JOIN
( SELECT FirstName, LastName, CustomerId, Country, MAX(custotal) AS cusMaxSpent
FROM tempo1
GROUP BY Country
)tempo2
ON tempo1.Country = tempo2.Country
WHERE tempo1.custotal = tempo2.cusMaxSpent
order by country;