# SQL Recursion

The problem: Automatically determine if somebody should have access to view another person's training transcript.

While recursion is helpful in reporting (org charts for example), this example comes from when I built an OLTP training database.  Supervisors needed to know how their staff did on a training.  Without adding lots of complicated security logic, I needed to know if they have access to the staff records.  Luckily for me, the employee table had a self-referencing foreign key for staff and their supervisors.  Using a recursive query, I can walk that chain of command.

This is a toy example for my portfolio.  Including the actual stored procedures used is too sensitive.  I've included two scripts, one to build and populate a sample table and another with the query.

Here's how the sample table looks:

employeeId	|employeeTitle	|supervisorId
------------|---------------|------------
1	|CEO	|NULL
2	|VP	|1
3	|CFO	|1
4	|GM	|2
5	|Supervisor	|4
6	|Staff A	|5

Notice, the CFO is in a different command chain.  The stored procedure can take in parameters for our target user and requesting user.  This might get more complicated depending on security requirements (like using tokens/lookups instead of identity values that I used here for simplicity).

```sql
with recursiveAccess as
(
	-- our anchor employee 
	select employeeId, employeeTitle, supervisorId
	from employeeAccess
	where employeeId = @employeeId

	union all

	--recursion to get employee's chain of command
	select employeeAccess.employeeId, employeeAccess.employeeTitle, 
	       employeeAccess.supervisorId
	from recursiveAccess inner join employeeAccess on
		recursiveAccess.supervisorId = employeeAccess.employeeId
)
select employeeId as employeeCheckedId, employeeTitle
from recursiveAccess
-- comment out this next line to view the employee chain of command 
-- regardless of requester for fun
where employeeId = @requesterId  
order by employeeId asc;

select case when @@ROWCOUNT > 0 then 'True' else 'False' end as hasAccess; 
```

Once you grasp the basic idea of recursion using a CTE, it is fairly simple.  My suggestion is to build the CTE up slowly one piece at a time and never forget the anchor.  SQL Server does have recursion limits set but a runaway query can punish any server like a bad join.

Inside the CTE, recursion is done by using the CTE's name in a FROM clause like you see after the union all.  SQL will use the rows from the previous execution to join back in.  In this case, I'm walking up the chain.  Going in the other direction from the CEO will generate an org chart walking each branch.  

Recursion is a little sensitive so make sure the columns match exactly.  Union isn't normally this sensitive about column types and lengths.  Casting is your friend.

```sql
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
```

The org chart style shows the CFO clearly isn't in the main chain of command.  The chart paths go from 2 to 4.  This has implications for the access query earlier.  *hint hint*

employeeId	|employeeTitle	|orgLevel	|orgChartPath
------------|---------------|-----------|------------
1	|CEO	|1	|1
2	|VP	|2	|1/2
4	|GM	|3	|1/2/4
5	|Supervisor	|4	|1/2/4/5
6	|Staff A	|5	|1/2/4/5/6
3	|CFO	|2	|1/3