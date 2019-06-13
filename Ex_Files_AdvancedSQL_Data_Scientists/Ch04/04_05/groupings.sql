/* Create a view to minimize the amount of typing and reduce the risk of making a mistake */
create view staff_div_reg as
   select
     s.*, cd.company_division, cr.company_regions
   from
     staff s
   left join
     company_divisions cd
   on
     s.department = cd.department
   left join
     company_regions cr
   on
      s.region_id = cr.region_id;

/* Verify the view has 1,000 rows */
select
  count(*)
from
  staff_div_reg;


/* Get the number of employees in each division within each region */
select
   company_division, company_regions, count(*)
from
   staff_div_reg
group by
   company_division, company_regions


/* Add an order by clause to make it easier to read */
select
   company_division, company_regions, count(*)
from
   staff_div_reg
group by
   company_division, company_regions
order by
   company_regions, company_division;

/* Get employee counts by division and by region */
select
   company_division, company_regions, count(*)
from
   staff_div_reg
group by
   grouping sets (company_division, company_regions)
order by
   company_regions, company_division;

/* Now, add in gender to break down even further */
/* Get employee counts by division and by region */
select
   company_division, company_region, gender, count(*)
from
   staff_div_reg
group by
   grouping sets (company_division, company_region, gender)
order by
   company_region, company_division, gender;
   
select * from company_regions limit 1;

select * from company_regions fetch first 1 rows only;