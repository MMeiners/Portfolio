# City of Phoenix Open Data

The City of Phoenix has an Open Data Portal which the public can use to do their own analysis.  I have decided to use a couple of those datasets in my portfolio.  Since I don't have any specific goals or stories in mind, I will start with doing exploratory analysis in Tableau Public 2019.1.  The worksheets are available in this repo has PowerPoint files.  You can also follow the links below to see the live story dashboard in Tableau Public online.

### Sky Harbor Dataset

The first dataset I've looked at is the Sky Harbor Airport flight schedule.  It contains arrivals and departures for the month of January 2018.  The city has a showcase analysis on their website and I wanted to see what else I could see.  

My exploratory process started by doing simple summary level statistics.  How many flights total?  How many by type?  What does it look like at the terminal level?  Are there any patterns?  Tableau makes it easy to quickly slice and dice data by many different dimensions and get a feel for the data.  Eventually I saw a few interesting pieces and put it together in a story dashboard.

[Can't Buy a Flight](https://public.tableau.com/views/SkyHarborFlightswip2/CantBuyaFlight?:embed=y&:display_count=yes&:origin=viz_share_link)

### City of Phoenix Crime Sample

The second dataset that caught my eye was about a selection of crime incidents.  This dataset had more detail to it but I began my tour the same way.  As I went through the data I realized that I needed more context to really get any meaning from the data.  

The summary statistics are absolute counts and don't factor in elements that influence the outcome such as population density, zoning, policing, and other local demographics.  For example, zip codes are obviously different sizes.  That alone can have a huge effect on how dangerous an area may appear based on solely raw totals.  Normalizing the data may be something I look at later.  For now, I mention that as a small caveat in the story dashboard.

[A bit on crime in Phoenix](https://public.tableau.com/views/crime-data-wip1/AbitoncrimeinPhoenix___?:retry=yes&:embed=y&:display_count=yes&:origin=viz_share_link)
