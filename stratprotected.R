library(dplyr)
# Stratified function from mrdwab -----------------------------------------
# https://gist.github.com/mrdwab/6424112

stratified <- function(df, group, size, select = NULL, 
                       replace = FALSE, bothSets = FALSE) {
  if (is.null(select)) {
    df <- df
  } else {
    if (is.null(names(select))) stop("'select' must be a named list")
    if (!all(names(select) %in% names(df)))
      stop("Please verify your 'select' argument")
    temp <- sapply(names(select),
                   function(x) df[[x]] %in% select[[x]])
    df <- df[rowSums(temp) == length(select), ]
  }
  df.interaction <- interaction(df[group], drop = TRUE)
  df.table <- table(df.interaction)
  df.split <- split(df, df.interaction)
  if (length(size) > 1) {
    if (length(size) != length(df.split))
      stop("Number of groups is ", length(df.split),
           " but number of sizes supplied is ", length(size))
    if (is.null(names(size))) {
      n <- setNames(size, names(df.split))
      message(sQuote("size"), " vector entered as:\n\nsize = structure(c(",
              paste(n, collapse = ", "), "),\n.Names = c(",
              paste(shQuote(names(n)), collapse = ", "), ")) \n\n")
    } else {
      ifelse(all(names(size) %in% names(df.split)),
             n <- size[names(df.split)],
             stop("Named vector supplied with names ",
                  paste(names(size), collapse = ", "),
                  "\n but the names for the group levels are ",
                  paste(names(df.split), collapse = ", ")))
    }
  } else if (size < 1) {
    n <- round(df.table * size, digits = 0)
  } else if (size >= 1) {
    if (all(df.table >= size) || isTRUE(replace)) {
      n <- setNames(rep(size, length.out = length(df.split)),
                    names(df.split))
    } else {
      message(
        "Some groups\n---",
        paste(names(df.table[df.table < size]), collapse = ", "),
        "---\ncontain fewer observations",
        " than desired number of samples.\n",
        "All observations have been returned from those groups.")
      n <- c(sapply(df.table[df.table >= size], function(x) x = size),
             df.table[df.table < size])
    }
  }
  temp <- lapply(
    names(df.split),
    function(x) df.split[[x]][sample(df.table[x],
                                     n[x], replace = replace), ])
  set1 <- do.call("rbind", temp)
  
  if (isTRUE(bothSets)) {
    set2 <- df[!rownames(df) %in% rownames(set1), ]
    list(SET1 = set1, SET2 = set2)
  } else {
    set1
  }
}


# Demograpic Proportions --------------------------------------------------

# All values represent % of US population from 2015 for which census data are available
# Demographics are from the United States Census Bureau - American Community Survey (2010-2015) 
# https://en.wikipedia.org/wiki/Demography_of_the_United_States#Race_and_ethnicity

# sample sizes n will be proportionate to the demographic percentages listed below
# what you want the final sample size to be
# The way this works: you put in the final sample size (e.g., n = 1000) it get's multiplied
# by the proportations you enter below (e.g., Black or African American 12.6%) to determine
# the final sample size (e.g., n = 126).  For each demographic in the comparison the final
# sample size is the sum for each group (e.g., sex .49*1000 [male] + .51*1000 [female] = 1000)
# n.race   = final sample size for the race sample
# n.ethn   = final sample size for the ethnicity sample
# n.sex    = final sample size for the sex sample
# n.over40 = final sample size for the unver/over40 comparison
# n.vet    = final sample size for the veteran/non-veteran comparison
n.race   = 1000
n.his    = 1000
n.sex    = 1000
n.over40 = 1000
n.vet    = 1000

# Race
# ame = Proportion of American Indian or Alaskan Native in US Population
# asi = Proportion of Asian in US Population
# bla = Proportion of Black or African American in US Population
# nat = Proportion of Native Hawaiian or Other Pacific Islander  in US Population
# oth = Proportion of Other in US Population
# two = Proportion of Two or More Races in US Population
# whi = Proportion of White in US Population
ame = .008
asi = .052
bla = .126
nat = .002
oth	= .048
two = .031
whi = .733

# Ethnicity
# his = Hispanic or Latino American (of any race)
his = .163

# Age and Sex
# Age and sex demography from census.gov 2015 survey
# https://www.census.gov/data/tables/2015/demo/age-and-sex/2015-age-sex-composition.html

# Age
# over40 = proportion of Americans over 40
over40 = .471

# Sex
# fem = proportion of females in the US
fem  = .510

# Veteran status
# data taken from here: https://www.va.gov/vetdata/Veteran_Population.asp
# NOTE: MAINTAIN THIS NUMBER AS IT IS ON A STEEP DECLINE FROM 2015-2045
vet = .066

# READING IN EXAMPLE POPULATION DATA ----
population <- read.csv("demographics.csv", as.is=FALSE, header=TRUE)
colnames(population)[1] <- "race"

population$race <- recode(population$race, 
                          `1` = "American Indian or Native Alaskan", 
                          `2` = "Asian",
                          `3` = "Black or African American",
                          `4` = "Native Hawaiian or Other Pacific Islander",
                          `5` = "Other",
                          `6` = "Two or More Races",
                          `7` = "White")
population$his <- recode(population$his, 
                         `0` = "Not Hispanic or Latino", 
                         `1` = "Hispanic or Latino"
)
population$over40 <- recode(population$over40, 
                            `0` = "Under 40", 
                            `1` = "Over 40"
)
population$fem <- recode(population$fem, 
                         `0` = "Male", 
                         `1` = "Female"
)
population$vet <- recode(population$vet, 
                         `0` = "Non-Veteran", 
                         `1` = "Veteran"
)


# Sampling: race ----------------------------------------------
set.seed(1)
sample.race <- stratified(population, 
                          group = "race", 
                          size = c("American Indian or Native Alaskan" = ame*n.race, 
                                   "Asian" = asi*n.race, 
                                   "Black or African American" = bla*n.race, 
                                   "Native Hawaiian or Other Pacific Islander" = nat*n.race, 
                                   "Other" = oth*n.race, 
                                   "Two or More Races" = two*n.race, 
                                   "White" = whi*n.race)
                          )
table(sample.race$race)

# Sampling: ethnicity Hispanic or Latino----------------------------------------------
set.seed(1)
sample.his <- stratified(population, 
                          group = "his", 
                          size = c("Not Hispanic or Latino" = (1-his)*n.his, 
                                   "Hispanic or Latino" = his*n.his
                                   )
)
table(sample.his$his)

# Sampling: Under40/Over40 ----------------------------------------------


set.seed(1)
sample.over40 <- stratified(population, 
                         group = "over40", 
                         size = c("Under 40" = (1-over40)*n.over40, 
                                  "Over 40" = over40*n.over40
                         )
)
table(sample.over40$over40)

# Sampling: Sex ----------------------------------------------
set.seed(1)
sample.fem <- stratified(population, 
                            group = "fem", 
                            size = c("Male" = (1-fem)*n.sex, 
                                     "Female" = fem*n.sex
                            )
)
table(sample.fem$fem)

# Sampling: Veteran Status ----------------------------------------------
set.seed(1)
sample.vet <- stratified(population, 
                         group = "vet", 
                         size = c("Non-Veteran" = (1-vet)*n.vet, 
                                  "Veteran" = vet*n.vet
                         )
)
table(sample.vet$vet)




