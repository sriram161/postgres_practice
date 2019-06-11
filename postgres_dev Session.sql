create table company_divisions (
  department varchar(100),
  company_division varchar(100),
  primary key (department)
);

insert into
  company_divisions
values
  ('Automotive', 'Auto & Hardware');
insert into
  company_divisions
values
  ('Baby', 'Domestic');
insert into
  company_divisions
values
  ('Beauty', 'Domestic');
insert into
  company_divisions
values
  ('Clothing', 'Domestic');
insert into
  company_divisions
values
  ('Computers', 'Electronic Equipment');
insert into
  company_divisions
values
  ('Electronics', 'Electronic Equipment');
insert into
  company_divisions
values
  ('Games', 'Domestic');
insert into
  company_divisions
values
  ('Garden', 'Outdoors & Garden');
insert into
  company_divisions
values
  ('Grocery', 'Domestic');
insert into
  company_divisions
values
  ('Health', 'Domestic');
insert into
  company_divisions
values
  ('Home', 'Domestic');
insert into
  company_divisions
values
  ('Industrial', 'Auto & Hardware');
insert into
  company_divisions
values
  ('Jewelery', 'Fashion');
insert into
  company_divisions
values
  ('Kids', 'Domestic');
insert into
  company_divisions
values
  ('Movies', 'Entertainment');
insert into
  company_divisions
values
  ('Music', 'Entertainment');
insert into
  company_divisions
values
  ('Outdoors', 'Outdoors & Garden');
insert into
  company_divisions
values
  ('Shoes', 'Domestic');
insert into
  company_divisions
values
  ('Sports', 'Games & Sports');
insert into
  company_divisions
values
  ('Tools', 'Auto & Hardware');
insert into
  company_divisions
values
  ('Toys', 'Games & Sports');


select * from company_divisions;