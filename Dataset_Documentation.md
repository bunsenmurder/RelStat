# Documentation for Data Sets and their variables
## NBEO_usCol.csv - Numbeo.com US cost of Living 2018 
- [Sourced from](https://www.numbeo.com/cost-of-living/rankings.jsp?title=2018)
- [Retrieved From](https://raw.githubusercontent.com/reisanar/datasets/master/cost-of-living-2018.csv)
- Cost.of.Living.Index.Plus.Rent.Index(numbeo): Is a relative indicator of consumer goods prices, including groceries, restaurants, transportation and utilities. This also include accommodations expenses such as rent or mortgage. This index is built based on the best guess of average expenses in a given city for a four-person family. The lower this value the better.
- Rent.Index: Index of the average price of rent within a city.
- Local.Purchasing.Power.Index(numbeo): Shows relative purchasing power in buying goods and services in a given city for the average wage in that city. The higher this value the better. 
- Avg.Disp.Sal.Index(numbeo): Shows an index of the Average Disposable salary that is being made in that city. This is calculated by:
Avg.Disp.Sal.IndexCity =(Local.Purchasing.Power.IndexCity*Cost.of.Living.Plus.Rent.Index)/100  
- Lat: The geographical latitude of the city so that it can be mapped.
- Lng: The geographical Longitude of the city so that it can be mapped.

## BEA_usCol.csv - BEA Regional Price Parity, Regional Personal Income, and other Cost of Living Statistics 
- [Sourced from](https://www.bea.gov/)
- [Retreived from](https://apps.bea.gov/iTable/iTable.cfm?reqid=70&step=1&isuri=1&acrdn=8#reqid=70&step=1&surl=1)
- City: The City
- State: The State
- Avg Salary: Based on Regional Personal Income, this is the average wages in an area in dollars.
- Avg Salary Index: An index built on Regional Personal income, it is calculated by (Avg Salary per city/Avg Salary for the USA). This index is used to calculate the LPP.Index which is used for clustering.
- Regional Price Parity: Shows the Regional Price Parity is similar measure to the Cost.Of.Living.Plus.Rent.Index, but collected by the BEA.
- Local Purchasing Power: How much in dollars of buying power is left after accounting for Cost of Living expenses. Calculated the same as LPP.Index but the Avg Sal Index is replaced with just Average Salary.
- LPP.Index: This is similar to the Local.Purchasing.Power.Index by numbeo but calculated using the data from the BEA. This is calculated by: 
LPP.IndexUS = (Avg Salary Index/Regional Price Parity)*100
•	Lat: The geographical latitude of the city so that it can be mapped.
•	Lng: The geographical Longitude of the city so that it can be mapped.

## climate14_18.csv - Climate data obtained from GSOD for year 2015-2018
- [Sourced from](https://data.noaa.gov/dataset/dataset/global-surface-summary-of-the-day-gsod)
- [Retrieved using GSODR](https://ropensci.github.io/GSODR/)
- Elev M: Elevation of the area.
- YEARMODA: Time character string for the year month and day. This is used to organize the data for processing.
- TEMP:  Mean temperature for the day in degrees Fahrenheit to tenths. 
- WDSP: Mean wind speed for the day in knots to tenths.
- MAX: Maximum temperature reported during the day in Fahrenheit to tenths--time of max temp report varies by country and region, so this will sometimes not be the max for the calendar day.
- MIN: Minimum temperature reported during the day in Fahrenheit to tenths--time of min temp report varies by country and region, so this will sometimes not be the min for the calendar day.
- PRCP: Total precipitation (rain and/or melted snow) reported during the day in inches and hundredths; will usually not end with the midnight observation--i.e., may include latter part of previous day. 
- Relative Humidity: is the ratio of the amount of water vapor in the air present in the air compared to the maximum amount of water vapor the air can hold. This variable is the best correlated measure for personal comfort, fog and cloud formation. Below 30% the air feels dry, and above 60% is feels moist and sticky.
- HI: This is the Heat Index, which is a measure of uncomfortableness calculated from heat and humidity. This was calculated by the function heat.index() found in the weathermetrics packages for R.
- Sndp: Snow depth in inches to tenths--last report for the day if reported more than once. 
- Fog: Binary indicators for if there was an occurrence of fog during the day.
- Rain drizzle: Binary indicators for if there was an occurrence of Rain or Drizzle during the day.
- Snow ice pellets: Binary indicators for if there was an occurrence of snow or ice pellets during the day.
- Hail: Binary indicators for if there was an occurrence of hail during the day.
- Thunder: Binary indicators for if there was an occurrence of Thunder and Lightning during the day.
- Tornado funnel cloud: Binary indicators for if there was an occurrence of Tornado funnel clouds during the day.

## natDisasters.csv - Natural Disasters Data Set 
- (Sourced from)[https://www.thereadystore.com/natural-disasters-map]
- States: Name of the state for the entry.
- Abbreviation: The two letter abbreviation of State name.
- Blizzards,Volcanoes,.... The names for each variable is self explanatory in the data set and a natural disaster is represented with a Binary Indicator for whether or not the natural disaster happens in that state.
