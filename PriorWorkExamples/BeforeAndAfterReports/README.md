# Before and After

One of the most important reports I worked on was the Statistical Bulletin for the Arizona Department of Economic Security, Division of Benefits and Medical Eligibility.  I was tasked with recreating this report in Tableau.  As part of this process I decided to attempt redesigning the report.  This report is available on the public AZ DES website and does not contain any confidential information.

Here is the [Statistical Bulletin for January 2012](statisticalBulletinBefore.pdf) before I got it.

In journalism, there is a concept known as the inverted pyramid.  It is a metaphor used to describe how information should be prioritized and structured.  The basic idea is to start with the most substantial key information then move on to important details and end with general or background info.  This was my guide to the redesign.

I asked myself who my audience was.  What did my audience need to know?  Was there another place where I could convey details?  Was there information missing?  Eventually, this ended up as a two piece report.  A Tableau report with the most important info and an Excel file with the little line items.  

When you look at the report, you'll see how it starts with current trends and ends at regional level detail.  The last page is added by a coworker in a revision.  Some of the program breakouts are not included in the Tableau report and exist only in Excel which I can't share.

The largest challenge in recreating this report was the data source.  Originally the data came from a mainframe job and was processed in SAS.  Tableau Server requires a different data source.  I needed to create SQL queries that could mimic the processing in SAS as best I could while letting Tableau calculated fields fill in the blanks.

View my updated [Statistical Bulletin for January 2016](statisticalBulletinAfter.pdf)
