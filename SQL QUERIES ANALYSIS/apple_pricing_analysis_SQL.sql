USE apple_pricing_trends;

-- ============================================================
-- Question 1
-- Which Apple product category generated the highest total sales value?
-- ============================================================

SELECT
    Product_Category,
    ROUND(SUM(Current_Price_INR),2) AS Total_Sales_Value_INR
FROM apple_pricing
GROUP BY Product_Category
ORDER BY Total_Sales_Value_INR DESC;


-- ============================================================
-- Question 2
-- How have average product prices changed from 2020 to 2026?
-- ============================================================

SELECT
    YEAR(Date) AS Year,
    ROUND(AVG(Current_Price_INR),2) AS Average_Price_INR
FROM apple_pricing
GROUP BY YEAR(Date)
ORDER BY Year;


-- ============================================================
-- Question 3
-- Which product category commands the highest average selling price?
-- ============================================================

SELECT
    Product_Category,
    ROUND(AVG(Current_Price_INR),2) AS Average_Price_INR
FROM apple_pricing
GROUP BY Product_Category
ORDER BY Average_Price_INR DESC;


-- ============================================================
-- Question 4
-- Which models are priced above the average price
-- of their respective product category?
-- ============================================================

SELECT
    Model_Name,
    Product_Category,
    Current_Price_INR
FROM apple_pricing p
WHERE Current_Price_INR >
(
    SELECT AVG(Current_Price_INR)
    FROM apple_pricing
    WHERE Product_Category = p.Product_Category
)
ORDER BY Product_Category, Current_Price_INR DESC;


-- ============================================================
-- Question 5
-- Rank the Top 5 most expensive models within each category.
-- ============================================================

SELECT *
FROM
(
    SELECT
        Model_Name,
        Product_Category,
        Current_Price_INR,
        ROW_NUMBER() OVER(
            PARTITION BY Product_Category
            ORDER BY Current_Price_INR DESC
        ) AS Ranking
    FROM apple_pricing
) RankedProducts
WHERE Ranking <= 5
ORDER BY Product_Category, Ranking;


-- ============================================================
-- Question 6
-- Calculate the Year-over-Year (YoY) percentage
-- change in average selling price.
-- ============================================================

SELECT
    Year,
    Average_Price,
    Previous_Year_Price,

    ROUND(
        ((Average_Price - Previous_Year_Price)
        / Previous_Year_Price) * 100,
        2
    ) AS YoY_Percentage_Change

FROM
(
    SELECT
        YEAR(Date) AS Year,
        ROUND(AVG(Current_Price_INR),2) AS Average_Price,

        LAG(ROUND(AVG(Current_Price_INR),2))
        OVER(ORDER BY YEAR(Date)) AS Previous_Year_Price

    FROM apple_pricing
    GROUP BY YEAR(Date)
) AS PriceTrend
ORDER BY Year;