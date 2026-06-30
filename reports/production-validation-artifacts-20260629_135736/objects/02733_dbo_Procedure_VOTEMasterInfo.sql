-- ─── PROCEDURE→FUNCTION: votemasterinfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.votemasterinfo(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.votemasterinfo(
    IN id integer,
    IN userno integer,
    IN authtype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- Info
	RETURN QUERY
	SELECT
		M.ID, M.Title, M.Type, M.PopUp, M.StartDate, M.EndDate,
		M.Public, M.ItemCnt, M.RegUserNo, M.IsStandBy, M.IsReg, M.IsOuterVote, M.CompleteMessage,
		M.IsAnonyVote, UserNo AS UserNo,
		CASE 
		WHEN Lang = 'KO' THEN U.Name 
		WHEN Lang = 'EN' THEN U.Name_EN
		WHEN Lang = 'VN' THEN U.Name_VN
		WHEN Lang = 'JP' THEN U.Name_JP
		WHEN Lang = 'CH' THEN U.Name_CH ELSE U.Name END AS UserName,
		CASE WHEN (SELECT COUNT(*) FROM VOTEResult WHERE MasterID = M.ID AND UserNo = votemasterinfo.userno) > 0 THEN 1 ELSE 0 END AS IsJoin,
		AuthType AS Auth
	FROM VOTEMaster M
	JOIN Organization_Users U ON (M.RegUserNo = U.UserNo)
	WHERE ID = votemasterinfo.id
	AND
	(
		CASE
		WHEN (AuthType = 1 OR AuthType = 2) THEN 1
		WHEN AuthType = 3 AND 
		(
			NOT EXISTS (SELECT * FROM VOTEQuestionnaire WHERE MasterID = M.ID)
			OR RegUserNo = votemasterinfo.userno
			OR
			(
				EXISTS
				(
					SELECT * 
					FROM VOTEQuestionnaire 
					WHERE MasterID = M.ID AND Type = 'U' AND No = votemasterinfo.userno
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
						SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = votemasterinfo.userno
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
						SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = votemasterinfo.userno
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
