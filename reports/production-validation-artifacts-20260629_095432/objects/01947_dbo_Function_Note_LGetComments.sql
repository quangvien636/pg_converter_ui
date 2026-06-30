-- ─── FUNCTION: note_lgetcomments ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_lgetcomments(uuid);
CREATE OR REPLACE FUNCTION public.note_lgetcomments(
    noteno uuid
) RETURNS TABLE(
    commentno text,
    listno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    content text,
    parentid text,
    name text,
    name_en text,
    userphoto text,
    photo text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT C.CommentNo, C.ListNo, C.RegUserNo, C.RegDate, C.ModUserNo, C.ModDate, C.Content, C.ParentID,
		U.Name, U.Name_EN, U.UserPhoto, U.Photo
	FROM Note_Comments C
	LEFT JOIN Organization_Users U ON U.UserNo = C.RegUserNo
	WHERE ListNo = note_lgetcomments.noteno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
