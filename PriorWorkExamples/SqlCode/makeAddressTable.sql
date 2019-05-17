drop table if exists oltpStyleAddress

create table oltpStyleAddress
(
	id int identity(1,1) not null primary key,
	firstName varchar(20) not null,
	cityName varchar(20) not null,
	effectiveYear smallint not null  
)

insert into oltpStyleAddress(firstName, cityName, effectiveYear)
values ('Mark', 'Mesa', 2000), ('Mark', 'Mesa', 2002), ('Bob', 'Phoenix', 2001),
		('Mark', 'Mesa', 2004), ('Bob', 'Phoenix', 2003), ('Bob', 'Tempe', 2005),
		('Bob', 'Tempe', 2006), ('Mark', 'Phoenix', 2005), ('Mark', 'Phoenix', 2006),
		('Mark', 'Mesa', 2007), ('Bob', 'Phoenix', 2010), ('Mark', 'Mesa', 2008),
		('Mark', 'Phoenix', 2009), ('Mark', 'Phoenix', 2011), ('Mark', 'Mesa', 2012),
		('Bob', 'Phoenix', 2012), ('Bob', 'Tempe', 2015), ('Mark', 'Phoenix', 2009),
		('Mark', 'Phoenix', 2009), ('Mark', 'Phoenix', 2009), ('Mark', 'Mesa', 2012),
		('Mark', 'Mesa', 2012), ('Mark', 'Mesa', 2012), ('Mark', 'Mesa', 2015),
		('Mark', 'Mesa', 2016), ('Mark', 'Mesa', 2017), ('Mark', 'Phoenix', 2018),
		('Mark', 'Phoenix', 2019)
