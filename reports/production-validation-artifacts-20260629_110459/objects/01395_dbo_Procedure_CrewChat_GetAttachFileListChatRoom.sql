-- ─── PROCEDURE→FUNCTION: crewchat_getattachfilelistchatroom ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getattachfilelistchatroom(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getattachfilelistchatroom(
    IN roomno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	select M.MessageNo, M.RoomNo, M.UserNo, A.AttachNo, A.FileName, 
	A.FullPath, A.RegDate, A.Size, A.Type, A.ThumbWidth, A.ThumbHeight
	from CrewChat_Messages M
	LEFT JOIN CrewChat_Attach A ON A.AttachNo = M.AttachNo
	where M.AttachNo > 0 AND A.AttachNo IS NOT NULL
	AND M.RoomNo = crewchat_getattachfilelistchatroom.roomno
	order by M.RegDate asc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
