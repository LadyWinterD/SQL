-- Show data during weekends in FY2019 after fiscal week 30
-- Limit results to incident type 4
SELECT
	ir.IncidentDate,
    -- Fiscal day of year: days since the start of the FY
	DATEDIFF(DAY, fy.FYStart, ir.IncidentDate) + 1 AS FiscalDayOfYear,
	fyweek.FiscalWeekOfYear
FROM dbo.IncidentRollup ir
	CROSS APPLY (SELECT '2019-07-01' AS FYStart) fy
    -- Number of weeks since the fiscal year began
	CROSS APPLY (
      SELECT DATEDIFF(WEEK, fy.FYStart, ir.IncidentDate) + 1 AS FiscalWeekOfYear
    ) fyweek
WHERE
	ir.IncidentTypeID = 4
    -- Fiscal year 2019, in dates
	AND ir.IncidentDate BETWEEN '2019-07-01' AND '2020-06-30'
	-- Determine if we are past the 30th fiscal week of the year
	AND fyweek.FiscalWeekOfYear > 30
	-- Determine if this is a weekend
	AND DATEPART(WEEKDAY, ir.IncidentDate) IN (1, 7);