-- ─── FUNCTION: integrated_getreply ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_getreply(bigint);
CREATE OR REPLACE FUNCTION public.integrated_getreply(
    replyno bigint
) RETURNS TABLE(
    replyno text,
    contentno text,
    moduserno text,
    modusername text,
    modpositionno text,
    modpositionname text,
    moddepartno text,
    moddepartname text,
    regdate text,
    moddate text,
    groupno text,
    depth text,
    orderno text,
    content text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ReplyNo,ContentNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName, ModDepartNo, ModDepartName,
		RegDate, ModDate, GroupNo, Depth, OrderNo, Content
	FROM Board_Replies
	WHERE ReplyNo = integrated_getreply.replyno

END;
-------------/////////////////////---------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
