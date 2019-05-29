drop table if exists employeeAccess;
go

create table employeeAccess
(
	employeeId int identity(1,1) not null primary key,
	employeeTitle varchar(10) not null,
	supervisorId int null references employeeAccess(employeeId)
);
go

-- relying on ident values here is probably a bad idea, but works for just this portfolio example
insert into employeeAccess(employeeTitle, supervisorId) 
	values ('CEO', null), ('VP', 1), ('CFO', 1), ('GM', 2), ('Supervisor', 4), ('Staff A', 5);
go