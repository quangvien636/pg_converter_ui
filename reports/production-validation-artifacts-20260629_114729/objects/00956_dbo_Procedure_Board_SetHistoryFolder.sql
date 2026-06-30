-- ─── PROCEDURE→FUNCTION: board_sethistoryfolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_sethistoryfolder(integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_sethistoryfolder(
    IN folderno integer,
    IN userno integer,
    IN isopen boolean
) RETURNS void
AS $function$
BEGIN

DELETE FROM public."Board_HistoryFolder" WHERE FolderNo= board_sethistoryfolder.folderno AND UserNo= board_sethistoryfolder.userno;
INSERT INTO public."Board_HistoryFolder"(UserNo,FolderNo,IsOpen)VALUES(UserNo,  FolderNo,  IsOpen);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
