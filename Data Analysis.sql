--Player Analysis

--Players with the most goals
SELECT Player, SUM(Gls) AS Goals, SUM(MP) AS MatchesPlayed
FROM Players
GROUP BY Player
ORDER BY Goals DESC
LIMIT 10;

--Players with the most assists 
SELECT Player, SUM(Ast) AS Assists, SUM(MP) AS MatchesPlayed
FROM Players
GROUP BY Player
ORDER BY Assists DESC
LIMIT 10;

--Players with the most goal contributions (goals and assists)
SELECT Player, SUM(GA) AS GoalContributions, SUM(MP) AS MatchesPlayed
FROM Players
GROUP BY Player
ORDER BY GoalContributions DESC
LIMIT 10;

--Players with the highest goals per 90 with atleast 10 90s played
SELECT Player, COALESCE(SUM(gls/ NULLIF("90s",0)), 0) AS GoalsPer90
FROM Players
WHERE "90s" > 10
GROUP BY Player
ORDER BY GoalsPer90 DESC
LIMIT 10;

--Players with the highest goal involvements per 90 minute with atleast 10 90s played
SELECT Player, COALESCE(SUM(GA/ NULLIF("90s",0)), 0) AS InvolvementsPer90
FROM Players
WHERE "90s" > 10
GROUP BY Player
ORDER BY InvolvementsPer90 DESC
LIMIT 10;

--Players with highest expected goals and assists combined
SELECT Player, SUM(xG + xAG) AS XGA, SUM(GA) AS Contributions
FROM Players
GROUP BY Player
ORDER BY XGA DESC
LIMIT 10;

--Players with most progressive carries 
SELECT Player, SUM(PrgC) AS ProgressiveCarries
FROM Players
GROUP BY Player
ORDER BY ProgressiveCarries DESC
LIMIT 10;

--Players with most red cards
SELECT Player, SUM(CrdR) AS RedCards
FROM Players
GROUP BY Player
HAVING SUM(CrdR) = (
    SELECT MAX(TotalRedCards)
    FROM (
        SELECT SUM(CrdR) AS TotalRedCards
        FROM Players
        GROUP BY Player
    ) AS Subquery
);

--Players with most yellow cards
SELECT Player, SUM(CrdY) AS YellowCards
FROM Players
GROUP BY Player
ORDER BY YellowCards DESC
LIMIT 10;

-- Players with most cards
SELECT Player, SUM(CrdY + CrdR) AS TotalCards
FROM Players
GROUP BY Player
ORDER BY TotalCards DESC
LIMIT 10;

--Players who have played the most minutes
SELECT Player, SUM(Min) AS MinutesPlayed
FROM Players
GROUP BY Player
ORDER BY MinutesPlayed DESC
LIMIT 10;

--How many progressive carries does 'Cole Palmer' complete each game on average
SELECT Player, ROUND(SUM(PrgC / MP), 2) AS ProgressiveCarriesPerGame
FROM Players
WHERE Player = 'Cole Palmer'
GROUP BY PLayer;



--Position analysis

--Progressive runs per position
SELECT Pos, SUM(PrgR) AS ProgressiveRuns
FROM Players
GROUP BY Pos
ORDER BY ProgressiveRuns DESC;

--Progressive carries per position
SELECT Pos, SUM(PrgC) AS ProgressiveCarries
FROM Players
GROUP BY Pos
ORDER BY ProgressiveCarries DESC ;

--Progressive passes per position
SELECT Pos, SUM(PrgP) AS ProgressivePasses
FROM Players
GROUP BY Pos
ORDER BY ProgressivePasses DESC ;

--Positions with the highest number of expected goals 
SELECT Pos, SUM(xg) AS ExpectedGoals
FROM Players
GROUP BY Pos
ORDER BY ExpectedGoals DESC;

--Total goals contributions for each position
SELECT Pos, SUM(GA) AS Contributions, COUNT(Player) AS AmountOfPlayers
FROM Players
GROUP BY Pos
ORDER BY Contributions DESC;

--Players who have scored the most penalties 
SELECT Player, Round(SUM(PK),0) AS PenaltiesScored
FROM Players
GROUP BY Player
ORDER BY PenaltiesScored DESC
LIMIT 10;

--Players who have missed the most penalties
SELECT Player, COALESCE(SUM(PKatt - PK), 0) AS MissedPenalties
FROM Players
WHERE (PKatt - PK) > 0
GROUP BY Player
ORDER BY MissedPenalties DESC;

--Players conversion rate with atleast 1 penatly taken
SELECT Player, COALESCE(SUM(PK / NULLIF(PKatt,0)),0) AS PenaltyConversionRate, SUM(PKatt) AS PnealtiesAttempted
FROM Players
WHERE (PK / NULLIF(PKatt,0)) > 0
GROUP BY Player
ORDER BY PenaltyConversionRate DESC;

--Find the oldest player in the dataset 
SELECT Player, MAX(Age) AS Age
FROM Players
GROUP BY Player
ORDER BY Age DESC
LIMIT 1;

--Find the youngest player in the dataset
SELECT Player, MIN(Age) AS Age
FROM Players
GROUP BY Player
ORDER BY Age 
LIMIT 1;

--Player with the most goals from each country 
WITH TopScorers AS(
	SELECT DISTINCT ON (Nation) Player, Nation, Gls AS Goals
FROM Players
ORDER BY Nation DESC
)
SELECT Player, Nation, Goals
FROM TopScorers
WHERE Goals > 0 
ORDER BY Goals DESC;

--Defenders with the most goals
SELECT Player, Pos AS Position, SUM(Gls) AS Goals
FROM Players
WHERE Pos = 'DF'
GROUP BY Player, Pos
ORDER BY Goals DESC
LIMIT 20;

--Defenders with the most assists 
SELECT Player, Pos AS Position, Sum(Ast) AS Assists
FROM Players
WHERE Pos = 'DF'
GROUP BY Player, Pos
ORDER BY Assists DESC
LIMIT 20;

--Age analysis

--Overall goals and assists by each age group
SELECT Age , SUM(GA) AS Contributions, COUNT(Player) AS AmountOfPlayers
FROM Players
WHERE GA > 0
GROUP BY Age
ORDER BY Age;

--Average goals and assists by each age group
SELECT Age , ROUND(AVG(GA),0) AS Contributions , COUNT(Player) AS AmountOfPlayers
FROM Players
WHERE GA > 0
GROUP BY Age
ORDER BY Age;

--Sum of goals for under 25 and players 25 and over
SELECT CASE 
WHEN Age < 25 THEN 'Under25' Else ' Over25'
END AS AgeGroup,
SUM(GA) AS Contributions , COUNT(Player) AS AmountOfPlayers
FROM PLayers 
GROUP BY CASE 
WHEN Age < 25 THEN 'Under25' Else ' Over25'
END;

--Average age of players in each position
SELECT Pos, ROUND(AVG(Age),0) AS AverageAge
FROM Players
GROUP BY Pos;

--Average age of all players in the premier league
SELECT ROUND(AVG(age), 0) AS AverageAge
FROM Players;

--Team and nation analysis

--Goals scored per team
SELECT Team, SUM(Gls) AS GoalsScored
FROM Players
GROUP BY Team
ORDER BY GoalsScored DESC;

--Average age per team
SELECT Team, ROUND(AVG(Age), 0) AS AverageAge
FROM Players
GROUP BY Team
ORDER BY AverageAge;

--Amount of players per team
SELECT Team, COUNT(Player) AS AmountOfPlayers
FROM Players
GROUP BY Team
ORDER BY AmountOfPlayers DESC; 

--Amount of Players per Nationality
SELECT Nation, COUNT(Players) AS AmountOfPlayers
FROM Players
GROUP BY Nation
ORDER BY AmountOfPlayers DESC;

--Country with highest  goal contributions
SELECT Nation, SUM(GA) AS AverageContributions, COUNT(Player) AS AmountOfPlayers
FROM Players
WHERE GA > 0 
GROUP BY Nation
ORDER BY AverageContributions DESC;


