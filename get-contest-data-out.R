if(!require(stringr)) {install.packages("stringr"); library(stringr)}
if(!require(dplyr)) {install.packages("dplyr"); library(dplyr)}
if(!require(readr)) {install.packages("readr"); library(readr)}

download.file("https://results.enr.clarityelections.com/CA/Contra_Costa/92672/224337/reports/detailtxt.zip", "detailtxt.zip")
unzip("detailtxt.zip")
result_lines <- readLines("detail.txt")
begins <- grep("Vote For", result_lines)
ends <- grep("Totals:", result_lines)
info_lines <- result_lines[begins] 
split_lines <- matrix(unlist(str_split(info_lines, "\\(Vote For ")), ncol=2, byrow=TRUE)
Contest <- str_trim(split_lines[,1],side="both")
Select <- str_sub(split_lines[,2],-2,1)
all_contests <- data.frame(Filename = paste0(1:length(info_lines),".csv"), Contest = Contest, Select = Select)
write_csv(all_contests,"contests-with-filenames.csv")

for (i in 1:length(all_contests[,1])) {
 print(i)
 writeLines(result_lines[(begins[i]+1):(ends[i]-1)], "temp.txt")
 columns <- nchar(readLines("temp.txt")[3])/30
 contest <- read.fwf("temp.txt", rep.int(30, columns))
 contest[] <- lapply(contest, as.character)
 colnames(contest) <- c(contest[1,])
 colnames(contest) <- str_trim(colnames(contest), side = "both")
 contest <- contest[,c(seq(1, columns-1, 2))]
 contest <- contest[-c(1,2),]
 rownames(contest) <- contest[,1]
 contest <- contest[,-1, drop=FALSE]
 contest[] <- lapply(contest, as.numeric)
 contest <- cbind(Precinct = rownames(contest), contest)
 rownames(contest) <- NULL
 write_csv(contest, paste0(i,".csv"))
}
