-- Let's see what we have after running the makeAddressTable script
select * 
from oltpStyleAddress


-- Closer look at a person of interest
select * 
from oltpStyleAddress
where firstName = 'Mark'


-- Secret sauce here.  We generate a cluster id by using the difference in partitions
-- This techique is useful in doing any kind of cluster/island analysis
select firstName, cityName, effectiveYear,
	ROW_NUMBER() over (partition by firstName order by effectiveYear) -
	ROW_NUMBER() over (partition by firstName, cityName order by effectiveYear) as clusterId
from oltpStyleAddress
order by firstName, effectiveYear


-- Using the clustering column from above, we can define a CTE for ease of use letting us reduce
-- the granularity and duplication of data.  We could do additional work like adding counts of rows, etc.
with base as
(
	select firstName, cityName, effectiveYear,
		ROW_NUMBER() over (partition by firstName order by effectiveYear) -
		ROW_NUMBER() over (partition by firstName, cityName order by effectiveYear) as clusterId
	from oltpStyleAddress
)
select firstName, cityName, min(effectiveYear) as startingOn
from base
group by firstName, cityName, clusterId
order by firstName, startingOn


-- For it to be even more helpful... lets call on lead() so we have an end date column
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