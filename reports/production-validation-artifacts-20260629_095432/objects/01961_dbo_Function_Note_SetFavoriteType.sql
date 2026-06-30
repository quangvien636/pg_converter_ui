-- ─── FUNCTION: note_setfavoritetype ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_setfavoritetype(uuid, integer, integer);
CREATE OR REPLACE FUNCTION public.note_setfavoritetype(
    listno uuid,
    userno integer,
    favoritetype integer
) RETURNS void
AS $function$
BEGIN



	UPDATE Note_Share
	SET FavoriteType=note_setfavoritetype.favoritetype
	WHERE ListNo=note_setfavoritetype.listno AND UserNo=UserShare

	UPDATE Note_List
	SET FavoriteType=note_setfavoritetype.favoritetype
	WHERE ListNo=note_setfavoritetype.listno AND UserNo=note_setfavoritetype.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
