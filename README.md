# Contra Costa County 2018 Election Results:
##  With a Focus on the West Contra Costa Unified School District Board
It's almost Christmas. Time for the County to finalize the election results, and they have. My focus is on the WCCUSD board election, but to look at any contest you need to wrangle the results out in a format that's easy to analyze.
### Getting the Results
On the [final results page](https://results.enr.clarityelections.com/CA/Contra_Costa/92672/Web02.222611/#/) of the county elections page, you can hunt down what you need:

![](https://i.imgur.com/6NpRQzo.png)

Here it lives as a ZIP file of a text file called details.txt. This is a series of fixed-column-width-format tables of different numbers of columns for each contest with some text metadata, glued all together in one file. Unpacking this information into a series of simple CSV files for each contest indexed in a central index file is the purpose of this R script:

`get-contest-data-out.R` 

Also included in this repository are the numbered CSV files with index from already running this.