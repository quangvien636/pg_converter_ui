-- ─── PROCEDURE→FUNCTION: votemasterrescnt ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.votemasterrescnt(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.votemasterrescnt(
    IN id integer,
    IN userno integer,
    IN authtype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- Count
	RETURN QUERY
	SELECT COUNT(*)
	FROM
	(
		SELECT MasterID, UserNo
		FROM VOTEMaster M 
		JOIN VOTEResult R ON (M.ID = R.MasterID)
		WHERE M.ID = votemasterrescnt.id
		AND
		(
			CASE
			WHEN (AuthType = 1 OR AuthType = 2) THEN 1
		WHEN AuthType = 3 AND 
		(
			NOT EXISTS (SELECT * FROM VOTEQuestionnaire WHERE MasterID = M.ID)
			OR RegUserNo = votemasterrescnt.userno
			OR
			(
				EXISTS
				(
					SELECT * 
					FROM VOTEQuestionnaire 
					WHERE MasterID = M.ID AND Type = 'U' AND No = votemasterrescnt.userno
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
						SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = votemasterrescnt.userno
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
						SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = votemasterrescnt.userno
					)
				)
			)
		) THEN 1
			ELSE 0 END 
		) = 1
		GROUP BY MasterID, UserNo
	) R1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
