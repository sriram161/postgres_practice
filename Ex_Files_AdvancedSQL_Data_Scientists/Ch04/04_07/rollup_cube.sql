/* Review the columns available in staff_div_reg view */
select
  *
from
  staff_div_reg
limit
  10;

create or replace view staff_div_reg_country as 
select s.*, cd.company_division, cr.company_regions, cr.country from staff s
left join 
company_divisions cd 
on
s.department = cd.department
left join
company_regions cr
on
s.region_id = cr.region_id

/* Select nubmer of employees by company_regions and country */
select
   company_regions, country, count(*)
from
   staff_div_reg_country
group by
   company_regions, country
order by
   country, company_regions

select * from staff_div_reg_country fetch first 1 rows only; 

/* Use rollup operation on the group by clause to create hierarchical sums */
select
   company_regions, country, count(*)
from
   staff_div_reg_country
group by
   rollup (country, company_regions)
order by
   country, company_regions


/* Use cube operation on the group by clause to create all possible combination of sets of grouping columns */
select
   company_division, company_regions,  count(*)
from
   staff_div_reg
group by
   cube (company_division, company_regions);
