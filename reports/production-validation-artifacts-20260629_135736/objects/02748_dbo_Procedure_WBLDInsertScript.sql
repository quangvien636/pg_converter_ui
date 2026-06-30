-- ─── PROCEDURE→FUNCTION: wbldinsertscript ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.wbldinsertscript(integer, character varying, character varying, text, text);
CREATE OR REPLACE FUNCTION public.wbldinsertscript(
    IN boardno integer,
    IN type character varying,
    IN mode character varying,
    IN loadscript text,
    IN definescript text
) RETURNS SETOF record
AS $function$
DECLARE
    cnt integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

Begin
SELECT COUNT(*) INTO cnt from WBLDBoardScript where boardno=wbldinsertscript.boardno and scripttype=wbldinsertscript.type and mode=wbldinsertscript.mode

IF cnt>0 THEN
		-- 기존에 있던것을 수정한다.;
		update WBLDBoardScript set loadscript = wbldinsertscript.loadscript, definescript=wbldinsertscript.definescript where boardno=wbldinsertscript.boardno and scripttype=wbldinsertscript.type and mode=wbldinsertscript.mode
	END IF;
ELSE
		-- 새로 저장한다.;
		Insert into WBLDBoardScript(boardno,scripttype, mode, loadscript, definescript, regid,regdate)
		values(boardno,type,mode,loadscript,definescript,regid,NOW())
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
