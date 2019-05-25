select * 
from employeeAccess;

--normally these are params to a stored proc
declare @employeeId int = 6; 
declare @requesterId int = 1;  -- notice the CFO is in a different management chain, so requesterId 3 can't see Staff A  

select employeeId as targetId, employeeTitle, supervisorId
from employeeAccess 
where employeeId = @employeeId;

with recursiveAccess as
(
	-- our anchor employee 
	select employeeId, employeeTitle, supervisorId
	from employeeAccess
	where employeeId = @employeeId

	union all

	--recursion to get employee's chain of command
	select employeeAccess.employeeId, employeeAccess.employeeTitle, employeeAccess.supervisorId
	from recursiveAccess inner join employeeAccess on
		recursiveAccess.supervisorId = employeeAccess.employeeId
)
select employeeId as employeeCheckedId, employeeTitle
from recursiveAccess
where employeeId = @requesterId  --comment out this line to view the employee chain of command regardless of requester for fun
order by employeeId asc;

select case when @@ROWCOUNT > 0 then 'True' else 'False' end as hasAccess; 

--org chart style

with recursiveOrg as
(
	-- our anchor CEO
	select employeeId, employeeTitle, 1 as orgLevel, cast('1' as varchar(20)) as orgChartPath
	from employeeAccess
	where employeeId = 1

	union all

	--recursion to crawl org chart
	select employeeAccess.employeeId, employeeAccess.employeeTitle, recursiveOrg.orgLevel + 1 as "level",
		cast(recursiveOrg.orgChartPath + '/' + cast(employeeAccess.employeeId as varchar(5)) as varchar(20)) as orgChartPath
	from recursiveOrg inner join employeeAccess on
		recursiveOrg.employeeId = employeeAccess.supervisorId
)
select r.employeeId, r.employeeTitle, r.orgLevel, r.orgChartPath
from recursiveOrg as r
order by r.orgChartPath asc;