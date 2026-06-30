-- ─── FUNCTION: wbldinsertscript ───────────────────────────────
DROP FUNCTION IF EXISTS public.wbldinsertscript(integer, character varying, character varying, text, text);
CREATE OR REPLACE FUNCTION public.wbldinsertscript(
    boardno integer,
    type character varying,
    mode character varying,
    loadscript text,
    definescript text
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    cnt integer;
BEGIN

Begin
Select cnt = COUNT(*) from WBLDBoardScript where boardno=wbldinsertscript.boardno and scripttype=wbldinsertscript.type and mode=wbldinsertscript.mode

if cnt>0
	begin
		-- 기존에 있던것을 수정한다.;
		update WBLDBoardScript set loadscript = wbldinsertscript.loadscript, definescript=wbldinsertscript.definescript where boardno=wbldinsertscript.boardno and scripttype=wbldinsertscript.type and mode=wbldinsertscript.mode
	end
else
	begin
		-- 새로 저장한다.;
		Insert into WBLDBoardScript(boardno,scripttype, mode, loadscript, definescript, regid,regdate)
		values(boardno,type,mode,loadscript,definescript,regid,NOW())
	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
