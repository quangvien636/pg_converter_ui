-- ─── PROCEDURE→FUNCTION: votejoincnt ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.votejoincnt(integer);
CREATE OR REPLACE FUNCTION public.votejoincnt(
    IN id integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT COUNT(*) AS Cnt
	FROM
	(
		SELECT R1.*
		FROM
		(
			SELECT ROW_NUMBER() OVER (PARTITION BY U.UserNo ORDER BY U.UserNo DESC) AS RowNum,
			U.UserNo
			FROM Organization_BelongToDepartment B
			JOIN Organization_Users U ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
			JOIN Organization_Departments D ON (B.DepartNo = D.DepartNo)
			JOIN Organization_Positions P ON (B.PositionNo = P.PositionNo)
			WHERE
			(
				CASE
				WHEN NOT EXISTS (SELECT * FROM VOTEQuestionnaire WHERE MasterID = votejoincnt.id) THEN 1
				WHEN U.UserNo IN (SELECT No FROM VOTEQuestionnaire WHERE MasterID = votejoincnt.id AND Type = 'U') THEN 1
				ELSE 0 END
			) = 1
			OR
			(
				CASE
				WHEN NOT EXISTS (SELECT * FROM VOTEQuestionnaire WHERE MasterID = votejoincnt.id) THEN 1
				WHEN B.DepartNo IN (SELECT No FROM VOTEQuestionnaire WHERE MasterID = votejoincnt.id AND Type = 'EG') THEN 1
				ELSE 0 END
			) = 1
			OR
			(
				CASE
				WHEN NOT EXISTS (SELECT * FROM VOTEQuestionnaire WHERE MasterID = votejoincnt.id) THEN 1
				WHEN B.PositionNo IN (SELECT No FROM VOTEQuestionnaire WHERE MasterID = votejoincnt.id AND Type = 'UG') THEN 1
				ELSE 0 END
			) = 1
		) R1
		WHERE R1.RowNum = 1 -- Deduplication
	) R2
	LEFT JOIN
	(
		SELECT UserNo, PollDate
		FROM
		(
			SELECT UserNo, PollDate, ROW_NUMBER() OVER (PARTITION BY UserNo ORDER BY ID DESC) AS RowNum
			FROM VOTEResult
			WHERE MasterID = votejoincnt.id
		) R1
		WHERE RowNum = 1 -- Deduplication
	) R3 ON (R2.UserNo = R3.UserNo)
	WHERE
	(
		CASE
		WHEN State = '' THEN 1
		WHEN State = 'Y' AND R3.PollDate IS NOT NULL THEN 1
		WHEN State = '' AND R3.PollDate IS NULL THEN 1
		ELSE 0 END
	) = 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
