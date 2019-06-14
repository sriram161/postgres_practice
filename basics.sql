-- Membercost is 50th part of monthlymaintenance.
select facid, name, membercost, monthlymaintenance from facilities 
where membercost <= monthlymaintenance/50 and membercost > 0

-- Prdocue word Tennis in their name.
SELECT * FROM facilities WHERE name similar to '%Tennis%';

-- Retrieve facilities with ID 1 and 5 do with OR operator
SELECT * FROM facilities WHERE facid in (1, 5);

-- Create a new cost column if monthly cost exceeds 100 as 'expensive' else 'cheap'

SELECT name, 
CASE WHEN monthlymaintenance > 100 THEN 'expensive' 
     WHEN monthlymaintenance <= 100 THEN 'cheap'
END AS cost
FROM facilities;

-- return people who joined after september 2012.facilities
SELECT memid, surname, firstname, joindate FROM members
where joindate >= DATE '2012-09-01';

-- Produce an ordered list of first 10 surnames from members no duplicates.facilities.
SELECT DISTINCT surname FROM members
ORDER BY surname LIMIT 10;

SELECT DISTINCT surname FROM members
ORDER BY surname
FETCH FIRST 10 ROWS ONLY;

-- Combine list of all surnames and all facilities names
SELECT
  surname
FROM
  members UNION
SELECT name FROM facilities;

SELECT
  surname
FROM
  members
UNION ALL
SELECT
  name
FROM
  facilities;

-- NOTE: UNION removes duplicates and combines results into one column, on the otherhand UNION ALL doesnot remove duplicates. 

-- Get joindate of your last member. 
SELECT joindate AS latest FROM members
ORDER BY joindate DESC
FETCH FIRST 1 ROWS ONLY;

SELECT
  max(joindate) AS latest
FROM
  members

SELECT
  firstname,
  surname,
  joindate AS latest
FROM
  cd.members
ORDER BY
  joindate DESC
FETCH FIRST
  1 ROWS ONLY;

-- Retrive the start times of members booking. 
select c.starttime from
(select b.firstname, b.surname, a.starttime from bookings as a 
join members b
on a.memid = b.memid) as c
where c.firstname = 'David' and c.surname ='Farrell'

-- Return list of starttime and facility names ordered by sarttime. for tennis courts
select a.starttime,b.name from bookings as a
join (select facid, name from facilities where name similar to 'Ten%') as b
on a.facid = b.facid 
where DATE(a.starttime) = DATE '2012-09-21'
ORDER BY a.starttime

-- Produce list of members who has recommended another member.   
select
  a.firstname,
  a.surname
from
  cd.members as a
  join (
    select
      distinct b.recommendedby
    from
      cd.members as b
    where
      b.recommendedby is not null
  ) c on a.memid= c.recommendedby
order by
  a.surname,
  a.firstname

  -- Select members and the recommendedby surnames and firstnames
select
  distinct c.memfname,
  c.memsname,
  b.firstname as recfname,
  b.surname as recsname
from
  members as b
  right join (
    select
      distinct a.firstname as memfname,
      a.surname as memsname,
      a.recommendedby as recid
    from
      members as a
  ) as c on c.recid = b.memid
order by
  c.memsname,
  c.memfname
 
--- make right to left join.

select a.firstname as memfname, a.surname as memsname, b.firstname as recfname, b.surname as recsname from members as a left join members as b
on
a.recommendedby = b.memid
order by a.surname, a.firstname


--Produce a list who have used tennis court
select distinct a.firstname || ' ' || a.surname  as member, c.facname as facility from members as a join (select f.name as facname, b.memid
from facilities as f
join bookings as b
on f.facid = b.facid
where f.name similar to 'Tennis %') c
on c.memid = a.memid
order by a.firstname || ' ' || a.surname

-- Produce list of bookings on 2012-09-14 cost per member more than 30$ 
SELECT f.name, m.firstname || ' ' || m.surname as memname, 
SUM(CASE WHEN m.firstname = 'GUEST' THEN f.guestcost
         ELSE f.membercost
    END) AS cost
FROM bookings AS b
JOIN facilities AS f
ON f.facid = b.facid AND DATE(b.starttime) = DATE('2012-09-14')
JOIN  members AS m
ON m.memid = b.memid 
GROUP BY m.firstname || ' ' || m.surname, f.name,

-- Solution
SELECT m.firstname || ' ' || m.surname, f.name, 
CASE WHEN m.memid = 0 THEN b.slots*f.guestcost
ELSE b.slots*f.membercost
END AS cost
FROM members AS m
JOIN bookings AS b
ON m.memid = b.memid
JOIN facilities AS f
ON f.facid = b.facid
WHERE DATE(b.starttime) = DATE('2012-09-14') AND
(b.slots* f.guestcost > 30 OR b.slots*membercost > 30)
ORDER BY COST DESC

-- Test
select memid,b.facid, b.slots, b.starttime from bookings as b join facilities as f on f.facid = b.facid
where
  DATE(b.starttime) = DATE('2012-09-14')
order by memid, b.facid


-- pRINT ALL member names and recommender names.
SELECT DISTINCT (m.firstname || ' ' || m.surname) as member, 
(SELECT a.firstname || ' ' || a.surname FROM members AS a
WHERE a.memid = m.recommendedby) as recommender
FROM members AS m
