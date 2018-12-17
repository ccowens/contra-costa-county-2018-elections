if(!require(readr)) {install.packages("readr"); library(readr)}
if(!require(dplyr)) {install.packages("dplyr"); library(dplyr)}
if(!require(janitor)) {install.packages("janitor"); library(janitor)}

map_to_cities <- data.frame(City_code = c("ELCR","ELSO","ERIC","GIAN","HERC","KENS","NRIC","PINL","RICH","ROLL","SPAB"),
                            City = c("El Cerrito","El Sobrante","East Richmond Heights","Richmond","Hercules","Kensington","North Richmond","Pinole","Richmond","Richmond","San Pablo"),
                            stringsAsFactors = FALSE
)

wccusd <- read_csv("contests/32.csv")

full <- colnames(wccusd)
partial <- c(full[-1])
partial <- sapply(str_split(partial, " "), function (x) if(x[length(x)] %in% c("JR", "JR.", "III", "IV", "V")) 
    {x[length(x)-1]}
  else
    {x[length(x)]})
colnames(wccusd)[-1] <- partial
  
wccusd$City_code <- substr(wccusd$Precinct, 1, 4)
wccusd <- left_join(wccusd, map_to_cities) %>% 
  select(-City_code, -Precinct) %>% 
  select(City, everything())

wccusd <- aggregate(. ~ City, wccusd, sum)

wccusd <- adorn_percentages(wccusd)

x <- apply(wccusd[-1], 2, max)

 <- t(data.frame(x))


join(y, wccusd)

str(data.frame(t(t(x))))
t(t(x))
left_join(x, wccusd)
x[]
