

--Retriving total number of passengers
SELECT COUNT(Parch), Parch
FROM Titanic
GROUP BY Parch

-- parents and child Survival
SELECT Parch, 
		SUM(CAST(Survived AS INT)) AS TotalSurvived, COUNT(*) TotalPassengers,
		100.0 * ROUND(SUM(CAST(Survived AS INT)),3) / COUNT(*) AS SurvivalRate
FROM Titanic
GROUP BY Parch
ORDER BY TotalSurvived
--spouses and siblings survival
SELECT SibSp, 
		SUM(CAST(Survived AS INT)) AS TotalSurvived, COUNT(*) TotalPassengers,
		100.0 * ROUND(SUM(CAST(Survived AS INT)),3) / COUNT(*) AS SurvivalRate
FROM Titanic
GROUP BY SibSp
ORDER BY TotalSurvived   --Family size had low impact on survival rate






--Passenger class and survival rate
SELECT
		SUM(CAST(Survived AS INT)) AS TotalSurvived,
		100.0 * ROUND(SUM(CAST(Survived AS INT)),3) / COUNT(*) AS SurvivalRate,
CASE 
		WHEN Pclass=1 THEN 'First Class'
		WHEN Pclass=2 THEN 'Second Class'
		WHEN Pclass=3 THEN 'Third Class'
		ELSE 'Unknown Class'
		END AS Passenger_class
FROM Titanic
GROUP BY Pclass
ORDER BY TotalSurvived

--The better the class, the higher survival rate. this is due to access to life saving equipment





-- Counting different Sex on board
SELECT Sex, COUNT(Sex) Total
FROM Titanic
GROUP BY Sex
-- Retrieving total number of passengers in each class
SELECT COUNT(Pclass) Total_passengers,
CASE 
		WHEN Pclass=1 THEN 'First Class'
		WHEN Pclass=2 THEN 'Second Class'
		WHEN Pclass=3 THEN 'Third Class'
		ELSE 'Unknown Class'
		END AS Passenger_class
		
FROM Titanic 
GROUP BY Pclass





-- Counting different age groups
SELECT
COUNT(CASE WHEN Age<= 15 THEN 1 END ) AS '0-15',
COUNT(CASE WHEN Age>=16 AND Age <=30 THEN 1 END) AS '16-30',
COUNT(CASE WHEN Age>=31  AND Age <=45THEN 1 END) AS '31-45',
COUNT(CASE WHEN Age >= 46 AND Age<=60 THEN 1 END ) AS '46-60',
COUNT(CASE 	WHEN Age>61 AND Age <=75 THEN 1 END)AS '61-75',
COUNT(CASE WHEN Age>=76 AND Age<=90 THEN 1 END) AS '76 and above', 
COUNT(CASE WHEN Age is NULL THEN 1 END)AS  'Unknown'
FROM Titanic  
--survival with respect to age groups
SELECT
  CASE
    WHEN Age < 10 THEN '0-10'
    WHEN Age BETWEEN 11 AND 20 THEN '11-20'
    WHEN Age BETWEEN 21 AND 30 THEN '21-30'
    WHEN Age BETWEEN 31 AND 40 THEN '31-40'
    WHEN Age BETWEEN 41 AND 50 THEN '41-50'
    WHEN Age BETWEEN 51 AND 60 THEN '51-60'
	WHEN Age BETWEEN 61 AND 70 THEN '61-70'
	WHEN Age> 70 THEN '70+'
    ELSE 'Unknown'
  END AS AgeGroup,
  COUNT(*) AS TotalPassengers,
  SUM(CAST(Survived AS INT)) AS TotalSurvived,
  100.0 * ROUND(SUM(CAST(Survived AS INT)),3) / COUNT(*) AS SurvivalRate
FROM
  Titanic
WHERE Age IS NOT NULL
GROUP BY CASE
    WHEN Age < 10 THEN '0-10'
    WHEN Age BETWEEN 11 AND 20 THEN '11-20'
    WHEN Age BETWEEN 21 AND 30 THEN '21-30'
    WHEN Age BETWEEN 31 AND 40 THEN '31-40'
    WHEN Age BETWEEN 41 AND 50 THEN '41-50'
    WHEN Age BETWEEN 51 AND 60 THEN '51-60'
	WHEN Age BETWEEN 61 AND 70 THEN '61-70'
	WHEN Age> 70 THEN '70+'
    ELSE 'Unknown'
  END
ORDER BY AgeGroup



-- Dermining survival count

SELECT COUNT( Survived) Survived	
FROM Titanic
WHERE Survived=1




-- Dead passengers  
SELECT COUNT( Survived) died
FROM Titanic
WHERE Survived=0






--Survival by sex
SELECT
  Sex,
  SurvivalRate
FROM (
  SELECT
    Sex,
    COUNT(*) AS Total_Passengers,
	 SUM(CAST(Survived AS INT)) AS TotalSurvived,
  100.0 * ROUND(SUM(CAST(Survived AS INT)),3) / COUNT(*) AS SurvivalRate
  FROM
    Titanic
  WHERE
    Sex IN ('male', 'female') 
	GROUP BY
    Sex
) AS GenderSurvival;

--Survival with respect to boarding station

SELECT Embarked Boarding_Station,
		COUNT(*) Total_passengers,
		SUM(CAST(Survived AS INT)) AS TotalSurvived,
  100.0 * ROUND(SUM(CAST(Survived AS INT)),3) / COUNT(*) AS SurvivalRate
FROM Titanic
WHERE Embarked IS NOT NULL
GROUP BY Embarked 

-- survival with respect to fare

SELECT
CASE 
	WHEN Fare<= 100 THEN '0-100'
	WHEN Fare BETWEEN 100 AND 200 THEN '101-200'
	WHEN Fare BETWEEN 200 AND 300 THEN '201-300'
	WHEN Fare BETWEEN 300 AND 400 THEN '301-400'
	ELSE '400 +'
	END AS Fare_paid,
	COUNT(*) Total_passengers,
	 SUM(CAST(Survived AS INT)) AS TotalSurvived,
  100.0 * ROUND(SUM(CAST(Survived AS INT)),2) / COUNT(*) AS SurvivalRate

FROM Titanic
GROUP BY CASE 
	WHEN Fare<= 100 THEN '0-100'
	WHEN Fare BETWEEN 100 AND 200 THEN '101-200'
	WHEN Fare BETWEEN 200 AND 300 THEN '201-300'
	WHEN Fare BETWEEN 300 AND 400 THEN '301-400'
	ELSE '400 +'
	END  
ORDER BY SurvivalRate DESC
--
SELECT *
FROM Titanic


WITH 
 regression_stats AS (
        SELECT
            SUM((Fare - fare_bar) * (Age - age_bar)) / SUM((Fare - fare_bar) * (Fare - fare_bar)) AS Slope,
            MAX(age_bar) AS age_bar_max,
            MAX(fare_bar) AS fare_bar_max
        FROM
            (SELECT 
                Age,
                AVG(Age) OVER() AS age_bar,
                Fare,
                AVG(Fare) OVER() AS fare_bar
            FROM 
                Titanic) AS aggregated_data
    ),
    -- Fetch the slope and intercept from the regression statistics
    trendline AS (
        SELECT
            Slope,
           age_bar_max- fare_bar_max  * Slope AS intercept
        FROM
            regression_stats
    )
-- Apply the trendline formula to the Titanic dataset
SELECT 
    Age, Fare,
    ROUND((Titanic.Age * (SELECT Slope FROM trendline) + (SELECT intercept FROM trendline)),2) AS predicted_fare
FROM 
    Titanic;

	SELECT Age, Fare, Parch
	FROM Titanic
	ORDER BY Fare DESC;
