# stratprotected
Generate stratified random samples of protected class demographics from population dataset.

## Demographics covered
1. Race
2. Ethnicity
3. Sex
4. Over 40 Years of Age
5. Veteran Status

## Stratified function
From: https://gist.github.com/mrdwab/6424112

## Overview
Proportions of demographics taken from sources included in the syntax in the Master branch:  
-[Race and Ethnicity 2010-2015 American Community Survey](https://en.wikipedia.org/wiki/Demography_of_the_United_States#Race_and_ethnicity)  
-[Age and Sex 2015](https://www.census.gov/data/tables/2015/demo/age-and-sex/2015-age-sex-composition.html)  
-[Veteran Status](https://www.va.gov/vetdata/Veteran_Population.asp)  

Note on veteran status: this proportion is on a steep decline from 2015-2045 and should be updated accordingly.

## User Inputs and Use
### User Inputs
1. Proportions for Protected Classes (defaults current US Population from sources above).  
2. Final sample sizes for each comparison (default is n = 1000).  
3. Seed (random starting value to reproduce results)  
3. Population dataframe with data coded in the following configuration, strings in parentheses should be the variable names for those columns:  
      1. Race (race)  
            1 = American Indian or Alaskan Native  
            2 = Asian  
            3 = Black or African American  
            4 = Native Hawaiian or other Pacific Islander  
            5 = Other  
            6 = Two or More Races  
            7 = White  
      2. Ethnicity (his)  
            0 = Not Hispanic or Latino  
            1 = Hispanic or Latino  
      3. Over 40 Years of Age (over40)  
            0 = Under 40  
            1 = Over 40  
      1. Sex (fem)  
            0 = Male  
            1 = Female  
      1. Veteran Status (vet)  
            0 = Non-Veteran  
            1 = Veteran  
### Use
You do not need all the demographic variables in your population dataset in order to run the syntax, just run the portions that are relevant for your comparsions.  A seperate sample dataset will be generated from each comparison and will retain all other data in your population dataset.

An example population dataset of randomly, evenly distributed demographic variables is provided in the Master branch.

