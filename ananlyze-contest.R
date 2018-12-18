if(!require(readr)) {install.packages("readr"); library(readr)}
if(!require(dplyr)) {install.packages("dplyr"); library(dplyr)}
if(!require(janitor)) {install.packages("janitor"); library(janitor)}
if(!require(stringr)) {install.packages("stringr"); library(stringr)}

map_to_cities <- data.frame(City_code = c("ELCR","ELSO","ERIC","GIAN","HERC","KENS","NRIC","PINL","RICH","ROLL","SPAB"),
                            City = c("El Cerrito","El Sobrante","East Richmond Heights","Richmond","Hercules","Kensington","North Richmond","Pinole","Richmond","Richmond","San Pablo"),
                            stringsAsFactors = FALSE
)

wccusd <- read_csv("contests/32.csv")

fullrow <- colnames(wccusd)
candidates <- c(fullrow[-1])
candidates <- sapply(str_split(candidates, " "), function (x) if(x[length(x)] %in% c("JR", "JR.", "III", "IV", "V")) 
    {x[length(x)-1]}
  else
    {x[length(x)]})
colnames(wccusd)[-1] <- candidates
  
wccusd$City_code <- substr(wccusd$Precinct, 1, 4)
wccusd <- left_join(wccusd, map_to_cities) %>% 
  select(-City_code, -Precinct) %>% 
  select(City, everything())

wccusd <- aggregate(. ~ City, wccusd, sum)

wccusd <- adorn_percentages(wccusd)

best_result <- apply(wccusd[-1], 2, max)

best_city <- unlist(lapply(candidates, function(x) {
  wccusd[match(best_result[x], pull(select(wccusd,x))), 1]
}))

best_city_by_candidate <- data.frame(`Best Result` = best_result, `City` = best_city, stringsAsFactors = FALSE)
