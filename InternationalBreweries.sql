-- viewing the dataset
SELECT * FROM internationalbreweries;

-- total sales revenue for each brand?
SELECT BRANDS, SUM(COST) AS Total_Sales_Revenue
FROM internationalbreweries
GROUP BY BRANDS;

-- sales were made by each sales representative?
SELECT SALES_REP, COUNT(SALES_ID) AS Total_Sales_Count
FROM internationalbreweries
GROUP BY SALES_REP;
-- total profit and cost for each brand and region?
SELECT BRANDS, REGION, SUM(PROFIT) AS Total_Profit, SUM(COST) AS Total_Cost
FROM internationalbreweries
GROUP BY BRANDS, REGION;

-- months and years having the highest sales revenue?
SELECT MONTHS, YEARS, SUM(COST) AS Total_Sales_Revenue
FROM internationalbreweries
GROUP BY MONTHS, YEARS
ORDER BY Total_Sales_Revenue DESC
LIMIT 1;

-- average unit price for each brand
SELECT BRANDS, AVG(UNIT_PRICE) AS Avg_Unit_Price
FROM internationalbreweries
GROUP BY BRANDS;

-- total profit and cost for each month and year
SELECT MONTHS, YEARS, SUM(PROFIT) AS Total_Profit, SUM(COST) AS Total_Cost
FROM internationalbreweries
GROUP BY MONTHS, YEARS;

-- How many units of each brand sold in each country
SELECT BRANDS, COUNTRIES, SUM(QUANTITY) AS Total_Units_Sold
FROM internationalbreweries
GROUP BY BRANDS, COUNTRIES
ORDER BY Total_Units_Sold DESC;

-- monthly total profit and cost for each brand, and the percentage profit margin?
WITH MonthlyProfits AS (
    SELECT MONTHS, YEARS, BRANDS, SUM(PROFIT) AS Total_Profit, SUM(COST) AS Total_Cost
    FROM internationalbreweries
    GROUP BY MONTHS, YEARS, BRANDS
)
SELECT mp.MONTHS, mp.YEARS, mp.BRANDS, mp.Total_Profit, mp.Total_Cost,
       ROUND((mp.Total_Profit / NULLIF(mp.Total_Cost, 0)) * 100, 2) AS Profit_Margin
FROM MonthlyProfits mp;

-- For each brand, calculate the running total of profit and cost over the months and years.
WITH MonthlyRunningTotal AS (
    SELECT MONTHS, YEARS, BRANDS, SUM(PROFIT) AS Monthly_Total_Profit, SUM(COST) AS Monthly_Total_Cost
    FROM internationalbreweries
    GROUP BY MONTHS, YEARS, BRANDS
)
SELECT mrt.MONTHS, mrt.YEARS, mrt.BRANDS,
       SUM(mrt.Monthly_Total_Profit) OVER(PARTITION BY mrt.BRANDS ORDER BY mrt.YEARS, mrt.MONTHS) AS Running_Total_Profit,
       SUM(mrt.Monthly_Total_Cost) OVER(PARTITION BY mrt.BRANDS ORDER BY mrt.YEARS, mrt.MONTHS) AS Running_Total_Cost
FROM MonthlyRunningTotal mrt
ORDER BY mrt.BRANDS, mrt.YEARS, mrt.MONTHS;

-- What are the top 3 sales representatives based on the average profit per sale?
WITH AvgProfitPerSale AS (
    SELECT SALES_REP, AVG(PROFIT) AS Avg_Profit_Per_Sale
    FROM internationalbreweries
    GROUP BY SALES_REP
)
SELECT ap.SALES_REP, ap.Avg_Profit_Per_Sale
FROM AvgProfitPerSale ap
ORDER BY ap.Avg_Profit_Per_Sale DESC
LIMIT 3;
--