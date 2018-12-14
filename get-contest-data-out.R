if(!require(stringr)) {install.packages("stringr"); library(stringr)} #str_split str_trim str_sub
if(!require(readr)) {install.packages("readr"); library(readr)} #write_csv

# create folder for output files if needed
dir.create("contests")

# get, open, and read in the file with results as text
download.file("https://results.enr.clarityelections.com/CA/Contra_Costa/92672/224337/reports/detailtxt.zip", "detailtxt.zip")
unzip("detailtxt.zip")
result_lines <- iconv(readLines("detail.txt"), "UTF-8") #read in as UTF-8 for diacritical in names

# mark the beginnings and ends of the lines for the contests 
begins <- grep("Vote For", result_lines)
ends <- grep("Totals:", result_lines)

# parse the beginning lines for contest names and how many picks for each contest
info_lines <- result_lines[begins] 
# NOTE: matrix forces the splits into the right configuration so each 2-col row is from the same text line
split_lines <- matrix(unlist(str_split(info_lines, "\\(Vote For ")), ncol=2, byrow=TRUE)
Contest <- str_trim(split_lines[,1],side="both")
Select <- str_sub(split_lines[,2],-2,1)

# create a numeric filename to reference the contest and write it to a CSV file with the other contest info
all_contests <- data.frame(Filename = paste0(1:length(info_lines),".csv"), Contest = Contest, Select = Select)
write_csv(all_contests,"contests/index-of-contests.csv")

# loop through and parse each set of lines for each contest 
for (i in 1:length(all_contests[,1])) {
  print(i) #echo
  # save out the text lines for the contest and read in as a fixed width file 
  writeLines(result_lines[(begins[i]+1):(ends[i]-1)], "temp.txt")
  columns <- nchar(readLines("temp.txt")[3])/30 #columns are 30 wide
  contest <- read.fwf("temp.txt", rep.int(30, columns))
  # make everything character
  contest[] <- lapply(contest, as.character)
  # add candidate/choice names as column names and clean them
  colnames(contest) <- c(contest[1,])
  colnames(contest) <- str_trim(colnames(contest), side = "both")
  # drop duplicative columns and last column, then drop top two rows
  contest <- contest[,c(seq(1, columns-1, 2))]
  contest <- contest[-c(1,2),]
  # save the precinct names as row names
  rownames(contest) <- contest[,1]
  # drop the precinct column so everything remaining as data should be a number, but stay as a data frame
  contest <- contest[,-1, drop=FALSE]
  # make the data numeric
  contest[] <- lapply(contest, as.numeric)
  # add the Precinct column back in, trim off white space, and throw out the row names
  contest <- cbind(Precinct = str_trim(rownames(contest), side = "both"), contest)
  rownames(contest) <- NULL
  # write everything out
  write_csv(contest, paste0("contests/",i,".csv"))
}
