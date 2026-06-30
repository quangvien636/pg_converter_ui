-- ─── PROCEDURE→FUNCTION: votemastercount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.votemastercount(integer, integer);
CREATE OR REPLACE FUNCTION public.votemastercount(
    IN userno integer,
    IN authtype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- Now


	-- Total Count
	RETURN QUERY
	SELECT COUNT(*) Cnt
	FROM VOTEMaster M
	JOIN
	(
		SELECT *
		FROM 
		(
			SELECT ROW_NUMBER() OVER (PARTITION BY UserNo ORDER BY UserNo DESC) AS RowNum, UserNo, DepartNo, PositionNo
			FROM Organization_BelongToDepartment
			WHERE IsDefault = TRUE
		) R1
		WHERE RowNum = 1 -- Deduplication
	) B ON (M.RegUserNo = B.UserNo)
	JOIN Organization_Users U ON (M.RegUserNo = U.UserNo)
	JOIN Organization_Departments D ON (B.DepartNo = D.DepartNo)
	WHERE
	(
		CASE
		WHEN Mode = 'Ongoing' AND CONVERT(VARCHAR(10), Now, 120) BETWEEN StartDate AND EndDate AND (IsReg = TRUE OR IsReg IS NULL) THEN 1
		WHEN Mode = 'Completed' AND CONVERT(VARCHAR(10), Now, 120) > EndDate  AND (IsReg = TRUE OR IsReg IS NULL) THEN 1
		WHEN Mode = 'Managed' AND (AuthType = 1 OR AuthType = 2 OR (AuthType = 3 AND RegUserNo = votemastercount.userno)) THEN 1
		ELSE 0 END
	) = 1
	AND
	(
		CASE
		WHEN (AuthType = 1 OR AuthType = 2) THEN 1
		WHEN AuthType = 3 AND 
		(
			NOT EXISTS (SELECT * FROM VOTEQuestionnaire WHERE MasterID = M.ID)
			OR RegUserNo = votemastercount.userno
			OR
			(
				EXISTS
				(
					SELECT * 
					FROM VOTEQuestionnaire 
					WHERE MasterID = M.ID AND Type = 'U' AND No = votemastercount.userno
				)
			)
			OR
			(
				EXISTS
				(
					SELECT * 
					FROM VOTEQuestionnaire 
					WHERE MasterID = M.ID AND Type = 'EG' AND No IN
					(
						SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = votemastercount.userno
					)
				)
			)
			OR
			(
				EXISTS
				(
					SELECT * 
					FROM VOTEQuestionnaire 
					WHERE MasterID = M.ID AND Type = 'UG' AND No IN
					(
						SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = votemastercount.userno
					)
				)
			)
		) THEN 1
		ELSE 0 END 
	) = 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
