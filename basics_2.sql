-- Aggregations

select count(recommendedby), recommendedby from members
where recommendedby is not null
group by recommendedby
order by recommendedby