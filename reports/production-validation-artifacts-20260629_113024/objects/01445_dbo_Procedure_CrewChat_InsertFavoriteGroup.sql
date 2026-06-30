-- ─── PROCEDURE→FUNCTION: crewchat_insertfavoritegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_insertfavoritegroup(integer);
CREATE OR REPLACE FUNCTION public.crewchat_insertfavoritegroup(
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    sortno integer;
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- 추가될 그룹의 소트번호

	SortNo := (SELECT COALESCE(MAX(SortNo),0) FROM CrewChat_FavoriteGroups WHERE UserNo=crewchat_insertfavoritegroup.userno);
	SortNo := SortNo + 1;;
	INSERT INTO CrewChat_FavoriteGroups (UserNo, Name, SortNo, ModDate)
	VALUES (UserNo, Name, SortNo, NOW())
	

	GroupNo := lastval();
	IF GroupNo > 0 THEN
		-- 즐겨찾기 그룹 정보
		RETURN QUERY
		SELECT GroupNo, UserNo, Name, SortNo, ModDate FROM CrewChat_FavoriteGroups 
		WHERE GroupNo = GroupNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
