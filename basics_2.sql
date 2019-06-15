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