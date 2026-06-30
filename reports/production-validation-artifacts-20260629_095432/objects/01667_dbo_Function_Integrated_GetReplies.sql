-- ─── FUNCTION: integrated_getreplies ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_getreplies(bigint);
CREATE OR REPLACE FUNCTION public.integrated_getreplies(
    contentno bigint
) RETURNS TABLE(
    replyno text,
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
	SELECT ReplyNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName, ModDepartNo, ModDepartName,
		RegDate, ModDate, GroupNo, Depth, OrderNo, Content
	FROM Integrated_Replies
	WHERE ContentNo = integrated_getreplies.contentno
	ORDER BY GroupNo DESC, OrderNo ASC

END;


-----------------------// -----------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
