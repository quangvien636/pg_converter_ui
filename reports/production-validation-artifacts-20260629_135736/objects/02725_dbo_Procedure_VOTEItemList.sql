-- ─── PROCEDURE→FUNCTION: voteitemlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.voteitemlist(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteitemlist(
    IN id integer,
    IN userno integer,
    IN authtype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- List
	RETURN QUERY
	SELECT I.* 
	FROM VOTEMaster M 
	JOIN VOTEItem I ON (M.ID = I.ParentID)
	WHERE M.ID = voteitemlist.id
	AND
	(
		CASE
		WHEN (AuthType = 1 OR AuthType = 2) THEN 1
		WHEN AuthType = 3 AND 
		(
			NOT EXISTS (SELECT * FROM VOTEQuestionnaire WHERE MasterID = M.ID)
			OR RegUserNo = voteitemlist.userno
			OR
			(
				EXISTS
				(
					SELECT * 
					FROM VOTEQuestionnaire 
					WHERE MasterID = M.ID AND Type = 'U' AND No = voteitemlist.userno
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
						SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = voteitemlist.userno
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
						SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = voteitemlist.userno
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
