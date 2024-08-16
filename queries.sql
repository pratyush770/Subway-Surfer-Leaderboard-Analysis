-- 1) Top Performers for Each Country where platform is Android -- 
SELECT 
    s.Player_ID,
    s.Player_Name,
    s.Verified,
    s.Platform_Name,
    s.Category_Name,
    s.Player_Country,
    s.Player_Pronouns,
    SEC_TO_TIME(s.Speedrun_Time) AS Time_Taken,
    s.Place AS Position
FROM
    subway_surfers s
        JOIN
    (SELECT 
        Player_Country, MIN(Place) AS MinPlace
    FROM
        subway_surfers
    GROUP BY Player_Country) AS tp ON s.Player_Country = tp.Player_Country
        AND s.Place = tp.MinPlace
WHERE
    s.Platform_Name = 'Android'
ORDER BY s.Player_Country;

-- 2) Top Performers for Each Platform who have not mentioned their pronouns -- 
 SELECT 
    s.Player_ID,
    s.Player_Name,
    SEC_TO_TIME(s.Speedrun_Time) AS Seconds,
    s.Place AS Place,
    s.Platform_Name,
    s.Category_Name,
    s.Player_Country
FROM
    subway_surfers s
        JOIN
    (SELECT 
        Platform_Name, MIN(Place) AS MinPlace
    FROM
        subway_surfers
    GROUP BY Platform_Name) AS tp ON s.Platform_Name = tp.Platform_Name
        AND s.Place = tp.MinPlace
WHERE
    s.Player_Pronouns = 'Not Mentioned'
ORDER BY s.Platform_Name;

-- 3) Top Performers for each category --
With TopPerformers AS
( 
SELECT Category_Name, MIN(Place) as Position
FROM subway_surfers
GROUP BY Category_Name
)
SELECT 
    s.Player_ID,
    s.Player_Name,
    SEC_TO_TIME(s.Speedrun_Time) AS Seconds,
    s.Place,
    s.Platform_Name,
    s.Category_Name,
    s.Player_Country
FROM subway_surfers s
JOIN TopPerformers tp
ON s.Category_Name = tp.Category_Name
AND s.Place = tp.Position
ORDER BY s.Category_Name;

-- 4) Top performers whose country name starts from 'a' --
With TopPerformers AS
( 
SELECT Player_Country, MIN(Place) as Position
FROM subway_surfers
GROUP BY Player_Country
)
SELECT 
	s.Player_ID,
    s.Player_Name,
    SEC_TO_TIME(s.Speedrun_Time) AS Seconds,
    s.Place,
    s.Platform_Name,
    s.Category_Name,
    s.Player_Country
FROM subway_surfers s
JOIN TopPerformers tp
ON s.Player_Country = tp.Player_Country
AND s.Place = tp.Position
WHERE s.Player_Country LIKE 'a%'
ORDER BY s.Player_Country;

-- 5) Number of players for each country whose pronouns are "she/her"--
SELECT 
    COUNT(*) AS Number_of_Players, Player_Country
FROM
    subway_surfers
WHERE
    Player_Pronouns = 'She/Her'
GROUP BY Player_Country
ORDER BY Number_of_Players;

-- 6) Number of players for each platform who have not mentioned their country name--
SELECT 
    COUNT(*) AS Number_of_Players
FROM
    subway_surfers
WHERE
    Player_Country = 'Not Mentioned'
GROUP BY Platform_Name
ORDER BY Number_of_Players;

-- 7) Top 3 Performers for each platform --
WITH RankedPerformers AS (
    SELECT 
        s.Player_ID,
        s.Player_Name,
        s.Verified,
        s.Platform_Name,
        s.Category_Name,
        s.Player_Country,
        s.Player_Pronouns,
        SEC_TO_TIME(s.Speedrun_Time) AS Time_Taken,
        s.Place AS Position,
        ROW_NUMBER() OVER (PARTITION BY s.Platform_Name ORDER BY s.Place) AS Player_Rank
    FROM
        subway_surfers s
)
SELECT *
FROM 
    RankedPerformers
WHERE 
    Player_Rank <= 3
ORDER BY 
    Platform_Name,
    Position;
    
-- 8) Percentage of Players for each platform -- 
SELECT 
    ROUND((COUNT(*) / (SELECT 
                    COUNT(*) AS total
                FROM
                    subway_surfers) * 100),
            2) AS Percentage_of_Players,
    Platform_Name
FROM
    subway_surfers
GROUP BY Platform_Name
ORDER BY Percentage_of_Players;

-- 9) Percentage of Players for each country whose name starts with 'c' --
SELECT 
    ROUND((COUNT(*) / (SELECT 
                    COUNT(*) AS total
                FROM
                    subway_surfers) * 100),
            2) AS Percentage_of_Players,
    Player_Country
FROM
    subway_surfers
WHERE
    Player_Country LIKE 'c%'
GROUP BY Player_Country
ORDER BY Player_Country;

-- 10) Top 10 Players for 'Mystery Hurdles' Category --
SELECT 
    *
FROM
    subway_surfers
WHERE
    Category_Name = 'Mystery Hurdles'
ORDER BY Place
LIMIT 10;