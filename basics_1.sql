SELECT
  m.firstname || ' ' || m.surname,
  f.name,
  CASE
    WHEN m.memid = 0 THEN b.slots * f.guestcost
    ELSE b.slots * f.membercost
  END AS cost
FROM
  members AS m
  JOIN bookings AS b ON m.memid = b.memid
  JOIN facilities AS f ON f.facid = b.facid
WHERE
  DATE(b.starttime) = DATE('2012-09-14')
  AND (
    b.slots * f.guestcost > 30
    OR b.slots * membercost > 30
  )
ORDER BY
  COST DESC

  -- Rewrite using subqueries.

  SELECT
  m.firstname || ' ' || m.surname,
  f.name,
  CASE
    WHEN m.memid = 0 THEN b.slots * f.guestcost
    ELSE b.slots * f.membercost
  END AS cost
FROM
  members AS m
  JOIN bookings AS b ON m.memid = b.memid
  JOIN facilities AS f ON f.facid = b.facid
WHERE
  DATE(b.starttime) = DATE('2012-09-14')
  AND (
    b.slots * f.guestcost > 30
    OR b.slots * membercost > 30
  )
ORDER BY
  COST DESC

-- Practice refactoring query.

SELECT
  (select m.firstname || ' ' || m.surname from members as m where m.memid = a.memid) as member,
  a.fname,
  a.cost
from
(select b.memid, 
(select case when b.memid = 0 then b.slots * f.guestcost else b.slots * f.membercost end
from facilities as f where f.facid = b.facid) as cost, 
(select f.name from facilities f where f.facid = b.facid) as fname
from bookings as b
where date (b.starttime) = date('2012-09-14')) as a
where a.cost >= 35
order by a.cost desc

-- NOTE: Subqueries can only return on column!!!!