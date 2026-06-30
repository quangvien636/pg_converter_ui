-- ─── PROCEDURE→FUNCTION: note_setfavoritetype ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_setfavoritetype(uuid, integer, integer);
CREATE OR REPLACE FUNCTION public.note_setfavoritetype(
    IN listno uuid,
    IN userno integer,
    IN favoritetype integer
) RETURNS void
AS $function$
BEGIN



	UPDATE Note_Share
	FavoriteType := note_setfavoritetype.favoritetype;
	WHERE ListNo=note_setfavoritetype.listno AND UserNo=UserShare

	UPDATE Note_List
	FavoriteType := note_setfavoritetype.favoritetype;
	WHERE ListNo=note_setfavoritetype.listno AND UserNo=note_setfavoritetype.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
