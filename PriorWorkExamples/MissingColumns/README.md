# Missing columns

I've included scripts to create a dummy table with data and the analysis.  All code is written specifically for this portfolio because including the real thing would be too sensitive. 

In the real world, data isn't perfect and ready for analysis via a simple select statement.  In this case, I needed to report from an address table in an OLTP system which was missing a column I wanted.    

I needed to calculate where a person was at any given point in time.  The problem was that the address table lacked an end date and had a granularity mismatch.  Every time a new record was added to the system an effective date was given but the preceding record was not closed or tagged in any way.  Here's an example.

id | Name | City | Effective Year
---|------|------|---------------
1	|Mark	|Mesa	|2000
2	|Mark	|Mesa	|2002
4	|Mark	|Mesa	|2004
8	|Mark	|Phoenix	|2005
9	|Mark	|Phoenix	|2006
10	|Mark	|Mesa	|2007

Effective dates had gaps or could even be duplicate.  The secret was generating a cluster id that I can group on.  For example, using the difference in row_number() results like this:

```sql
select firstName, cityName, effectiveYear,
	ROW_NUMBER() over (partition by firstName order by effectiveYear) -
	ROW_NUMBER() over (partition by firstName, cityName order by effectiveYear) as clusterId
from oltpStyleAddress
order by firstName, effectiveYear
```
Name | City | Effective Year | Cluster Id
------|------|----------------|-----------
Mark	|Mesa	|2000	|0
Mark	|Mesa	|2002	|0
Mark	|Mesa	|2004	|0
Mark	|Phoenix	|2005	|3
Mark	|Phoenix	|2006	|3
Mark	|Mesa	|2007	|2

Once that is done, I can use a CTE and calculate other aggregates as needed.  How many cities did Mark live in over the last ten years?  Easy.  How many times did he move last year?  Simple.  Or, what I needed: what was the effective end date?

```sql
with base as
(
	select firstName, cityName, effectiveYear,
		ROW_NUMBER() over (partition by firstName order by effectiveYear) -
		ROW_NUMBER() over (partition by firstName, cityName order by effectiveYear) as clusterId
	from oltpStyleAddress
)
select firstName, cityName, min(effectiveYear) as startingOn,
	lead(cast(min(effectiveYear) as varchar(4)), 1, 'N/A')
		over (partition by firstName order by min(effectiveYear)) as endingOn
from base
group by firstName, cityName, clusterId
order by firstName, startingOn
```

Here I used lead() to help grab the last piece I needed after grouping.

firstName	|cityName	|startingOn	|endingOn
------------|-----------|-----------|--------
Mark	|Mesa	|2000	|2005
Mark	|Phoenix	|2005	|2007
Mark	|Mesa	|2007	|2009
Mark	|Phoenix	|2009	|2012
Mark	|Mesa	|2012	|2018
Mark	|Phoenix	|2018	|N/A