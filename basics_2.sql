-- Aggregations

select count(recommendedby), recommendedby from members
where recommendedby is not null
group by recommendedby
order by recommendedby

select facid, sum(slots) from bookings
group by facid
order by facid


select date_part('month', starttime) from bookings

select facid, sum(slots) from bookings
where date_part('month', starttime) = 9 and date_part('year', starttime) = 2012
group by facid
order by sum(slots)

--List total slots booked per facility per month.
select facid, date_part('month', starttime) as month, sum(slots) as totalSlots from bookings
where date_part('year', starttime) = 2012
group by facid, date_part('month', starttime)
order by facid, date_part('month', starttime) 

-- Find total number of members who has made aleast one booking.
select count(*)
from 
(select count(memid), sum(slots) as totalslots from bookings
group by memid) as a
where a.totalslots >= 1

--Produce facilities with more than thousand slots booked. output facility ID, hours sort by facility id.
select * from 
(select facid, sum(slots) as hrs from bookings
group by facid
order by facid) as a
where a.hrs > 1000

-- Find total revenue per facility sorted by revenue 

select f.name, sum(case when b.memid =0 then b.slots * f.guestcost else b.slots * f.membercost end) as revenue
from facilities as f 
inner join bookings as b
on f.facid = b.facid
group by f.facid
order by revenue

--
select * from 
(select
  f.name,
  sum(
    case
      when b.memid = 0 then b.slots * f.guestcost
      else b.slots * f.membercost
    end
  ) as revenue
from
  facilities as f
  inner join bookings as b on f.facid = b.facid
group by
  f.facid
order by
  revenue) as a
  where revenue < 1000

-- Output facility id that has highest number of slots.
select facid, sum(slots) as totalslots from bookings
group by facid
order by totalslots desc
fetch first row only

-- Output sum of slots per month per facility followed by total for slots across months.
delete from bookings where facid = 8 and date_part('month', starttime) = 1
SELECT facid, date_part('month', starttime) as month, sum(slots)  from bookings
where date_part('year', starttime) = 2012
group by rollup(facid, month)
order by facid, month

-- List total hours booked per named faicility
select f.facid, f.name, trim(to_char(sum(b.slots) / 2.0, '9999d99')) as "Total Hours" from bookings as b 
inner join facilities as f
on b.facid = f.facid
group by f.facid, f.name
order by f.facid

-- Each members first booking afer september 1st 2019 and member name and order by memid.
select distinct m.surname, m.firstname, a.memid, a.first_val as starttime from
(select memid, starttime as starttime1, first_value(starttime) over (partition by memid order by starttime) as first_val 
from (select * from bookings where date(starttime) >= date('2012-09-01'))as x ) as a
inner join members as m
on m.memid = a.memid
order by a.memid


-- Produce list of member names with each row containing total member count order by joindate
select (select count(*) from members) as count, surname, firstname from members
order by joindate

select count(*) over(), firstname, surname from members
order by joindate


/* Window functions help you work on particular section of the data which makes them very powerful*/
select
  count(*) over(
    partition by date_trunc('month', joindate)
    order by
      joindate asc
  ) as asc_,
  count(*) over(
    partition by date_trunc('month', joindate)
    order by
      joindate desc
  ) as desc_,
  firstname,
  surname
from
  members
order by
  joindate

  -- number the members based on joining date.
select row_number() over(), firstname, surname from members
order by joindate

-- Output the facility that has the highest number of slots ensure all ties are outputed.
select distinct facid, sum(slots) over (partition by facid)
from cd.bookings
order by sum desc
fetch first row only

--prduce list of members along with the number of hours they booked in facilities, rounded to the nearest ten hours.
--rank them by this rounded figure  output: firstname, surname, rounded hours, rank.
-- sort by rank, surname and firstname.

select b.firstname, b.surname, a.hours_, rank() over (order by hours_ desc) as rank from 
(select distinct memid, round(sum(slots) over (partition by memid)/2, -1) as hours_ from bookings) as a
join members as b
on
a.memid = b.memid 
order by rank, surname, firstname

-- Top 3 revenue generation facilities including ties output facility name and rank sorted by rank and facility. 
with t1 as (select f.name, case when b.memid=0 then b.slots*f.guestcost else b.slots*f.membercost end as revenue
            from bookings as b join facilities as f on f.facid = b.facid),
     t2 as (select name, sum(revenue) as revenue from t1 group by name)
select name, rank() over (order by revenue desc) as rank from t2
fetch first 3 rows only

-- Above query using rank.
with t1 as (select f.name, case when b.memid=0 then b.slots*f.guestcost else b.slots*f.membercost end as revenue
            from bookings as b join facilities as f on f.facid = b.facid),
     t2 as (select name, sum(revenue) as revenue from t1 group by name),
     t3 as (select name, rank() over (order by revenue desc) as rank from t2)
select * from t3
where rank < 4

-- classify facilities into 3 equally sized groups based on their revenue.
with t1 as (select f.name, case when b.memid = 0 then b.slots*f.guestcost else b.slots*f.membercost end as revenue 
  from facilities as f 
  join bookings as b
  on f.facid = b.facid),
  t2 as (select name, sum(revenue) as revenue from t1 group by name),
  t3 as (select name, rank() over (order by revenue desc) as rank, revenue from t2),
  t4 as (select name, ntile(3) over (order by revenue desc) as class from t3),
  t5 as (select * from t4 order by class, name)
select name, case when class=1 then 'high'
                  when class=2 then 'average'
                  when class=3 then 'low' end from t5

-- Calculate the payback time for each facility. 
select count(distinct
  date_part('month', starttime)) as month_count, count(distinct date_part('year', starttime)) as year_count
from
  bookings;

--Actual query
-- TODO: Compute monthly revenue - monthlymaintenance.
-- TODO: Compute initialoutlay/ (monthly_revenue - monthlymaintenance)

with t1 as ( select * from bookings as b join facilities as f on f.facid = b.facid),
     t2 as ( select name, date_part('month', starttime) as month, sum(case when memid = 0 then slots*guestcost else slots*membercost end) as revenue, 
            monthlymaintenance, initialoutlay from t1
            group by name, month, monthlymaintenance, initialoutlay ),
    t3 as (select name, initialoutlay, sum(revenue - monthlymaintenance) as income from t2
           group by name, initialoutlay),
    t4 as (select name, initialoutlay/income as months from t3)
select * from t4
order by name


select
  facs.name as name,
  facs.initialoutlay /(
    (
      sum(
        case
          when memid = 0 then slots * facs.guestcost
          else slots * membercost
        end
      ) / 3
    ) - facs.monthlymaintenance
  ) as months
from
  cd.bookings bks
  inner join cd.facilities facs on bks.facid = facs.facid
group by
  facs.facid
order by
  name;


-- rolling average of total revenue.
with t1 as (select b.facid, b.memid, to_char(b.starttime, 'YYYY-MM-DD') as date, b.slots from bookings as b),
     t2 as (select facid, memid, date, sum(slots) as slots from t1
            group by facid, memid, date having date >= '2012-08-01' and date <= '2012-08-31'),
     t3 as (select date, (case when t.memid = 0 then t.slots*f.guestcost
            else t.slots*membercost end) as revenue from t2 as t join facilities as f
            on t.facid = f.facid),
     t4 as (select date, sum(revenue) as revenue from t3
            group by date order by date)
     t5 as (select date, lead(revenue) over())
select * from t4;


-- Moving average version 2.
select e.date, avg(e.revenue) over (order by e.date asc rows 14 preceding)
from 
    (select c.date, c.revenue 
    from 
        (select to_char(b.starttime, 'YYYY-MM-DD') as date,
         case when b.memid = 0 then b.slots * f.guestcost
         else b.slots * f.membercost end as revenue
         from bookings as b
         inner join facilities as f
         on b.facid = f.facid) as c 
    where c.date >= '2012-08-01' and c.date <= '2012-08-31') as e


-- Moving Average 3 CORRECT answer for moving average
with t1 as (select date(b.starttime) as date, case when b.memid = 0 then b.slots * f.guestcost
           else b.slots * f.membercost end as revenue from bookings as b
           inner join facilities as f 
           on b.facid = f.facid),
     t2 as (select date, sum(revenue) as revenue from t1 group by date),
     t3 as (select date, avg(revenue) over (order by date asc rows 14 preceding) as revenue from t2),
     t4 as (select date, revenue from t3 where date >= '2012-08-01' and date <= '2012-08-31') 
select * from t4