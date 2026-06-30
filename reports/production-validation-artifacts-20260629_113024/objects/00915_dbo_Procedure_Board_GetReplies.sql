-- ─── PROCEDURE→FUNCTION: board_getreplies ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getreplies(bigint, character varying);
CREATE OR REPLACE FUNCTION public.board_getreplies(
    IN contentno bigint DEFAULT 4939,
    IN langcode character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT BR.ReplyNo,
		BR.ModUserNo,
		BR.ModUserName,
		BR.ModPositionNo,
		CASE LangCode WHEN 'EN' THEN COALESCE(OP.Name_EN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name) WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name)WHEN 'VN' THEN COALESCE(OP.Name_VN,OP.Name) ELSE OD.Name END AS ModPositionName,
		--BR.ModPositionName,
		BR.ModDepartNo,
		CASE LangCode WHEN 'EN' THEN COALESCE(OD.Name_EN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name) WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name)WHEN 'VN' THEN COALESCE(OD.Name_VN,OD.Name) ELSE OD.Name END AS ModDepartName,
		BR.RegDate,
		BR.ModDate,
		BR.GroupNo,
		BR.Depth,
		BR.OrderNo,
		COALESCE(BR.Content,'') AS Content,
		OU.UserPhoto, 
		OU.Photo
	FROM Board_Replies BR 
	LEFT OUTER JOIN Organization_Users OU ON OU.UserNo = BR.ModUserNo
	LEFT OUTER JOIN Organization_Departments OD ON OD.DepartNo=BR.ModDepartNo AND OD.Enabled = TRUE
	LEFT OUTER JOIN Organization_Positions OP ON OP.PositionNo=BR.ModPositionNo AND OP.Enabled = TRUE
	WHERE ContentNo = board_getreplies.contentno
	ORDER BY GroupNo DESC, OrderNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
