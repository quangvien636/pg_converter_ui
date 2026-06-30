-- ─── PROCEDURE→FUNCTION: voteuserslist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.voteuserslist(integer, character varying);
CREATE OR REPLACE FUNCTION public.voteuserslist(
    IN id integer,
    IN lang character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT R2.UserNo, UserID, UserName, DepartName, PositionName, PollDate
	FROM
	(
		SELECT R1.*
		FROM
		(
			SELECT ROW_NUMBER() OVER (PARTITION BY U.UserNo ORDER BY U.UserNo DESC) AS RowNum,
			U.UserNo, U.UserID,
			CASE 
			WHEN Lang = 'KO' THEN U.Name 
			WHEN Lang = 'EN' THEN U.Name_EN
			WHEN Lang = 'VN' THEN U.Name_VN
			WHEN Lang = 'JP' THEN U.Name_JP
			WHEN Lang = 'CH' THEN U.Name_CH ELSE U.Name END AS UserName,
			D.DepartNo,
			CASE 
			WHEN Lang = 'KO' THEN D.Name 
			WHEN Lang = 'EN' THEN D.Name_EN
			WHEN Lang = 'VN' THEN D.Name_VN
			WHEN Lang = 'JP' THEN D.Name_JP
			WHEN Lang = 'CH' THEN D.Name_CH ELSE D.Name END AS DepartName,
			CASE 
			WHEN Lang = 'KO' THEN P.Name 
			WHEN Lang = 'EN' THEN P.Name_EN
			WHEN Lang = 'VN' THEN P.Name_VN
			WHEN Lang = 'JP' THEN P.Name_JP
			WHEN Lang = 'CH' THEN P.Name_CH ELSE D.Name END AS PositionName
			FROM Organization_BelongToDepartment B
			JOIN Organization_Users U ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
			JOIN Organization_Departments D ON (B.DepartNo = D.DepartNo)
			JOIN Organization_Positions P ON (B.PositionNo = P.PositionNo)
			WHERE 
			(
				CASE
				WHEN NOT EXISTS (SELECT * FROM VOTEQuestionnaire WHERE MasterID = voteuserslist.id) THEN 1
				WHEN U.UserNo IN (SELECT No FROM VOTEQuestionnaire WHERE MasterID = voteuserslist.id AND Type = 'U') THEN 1
				ELSE 0 END
			) = 1
			OR
			(
				CASE
				WHEN NOT EXISTS (SELECT * FROM VOTEQuestionnaire WHERE MasterID = voteuserslist.id) THEN 1
				WHEN B.DepartNo IN (SELECT No FROM VOTEQuestionnaire WHERE MasterID = voteuserslist.id AND Type = 'EG') THEN 1
				ELSE 0 END
			) = 1
			OR
			(
				CASE
				WHEN NOT EXISTS (SELECT * FROM VOTEQuestionnaire WHERE MasterID = voteuserslist.id) THEN 1
				WHEN B.PositionNo IN (SELECT No FROM VOTEQuestionnaire WHERE MasterID = voteuserslist.id AND Type = 'UG') THEN 1
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
			WHERE MasterID = voteuserslist.id
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
