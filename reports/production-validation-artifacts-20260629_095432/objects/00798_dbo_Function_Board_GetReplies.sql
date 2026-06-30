-- ─── FUNCTION: board_getreplies ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getreplies(bigint, character varying);
CREATE OR REPLACE FUNCTION public.board_getreplies(
    contentno bigint DEFAULT 4939,
    langcode character varying DEFAULT ''
) RETURNS TABLE(
    replyno text,
    moduserno text,
    modusername text,
    modpositionno text,
    modpositionname text,
    modpositionname text,
    moddepartno text,
    moddepartname text,
    regdate text,
    moddate text,
    groupno text,
    depth text,
    orderno text,
    content text,
    userphoto text,
    photo text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT BR.ReplyNo,
		BR.ModUserNo,
		BR.ModUserName,
		BR.ModPositionNo,
		CASE LangCode WHEN 'EN' THEN COALESCE(OP.Name_EN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name) WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name)WHEN 'VN' THEN COALESCE(OP.Name_VN,OP.Name) ELSE OD.Name END AS ModPositionName,
		--BR.ModPositionName,
		BR.ModDepartNo,
		CASE LangCode WHEN 'EN' THEN COALESCE(OD.Name_EN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name) WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name)WHEN 'VN' THEN COALESCE(OD.Name_VN,OD.Name) ELSE OD.Name END AS ModDepartName,
		BR.RegDate,
		BR.ModDate,
		BR.GroupNo,
		BR.Depth,
		BR.OrderNo,
		COALESCE(BR.Content,'') AS Content,
		OU.UserPhoto, 
		OU.Photo
	FROM Board_Replies BR 
	LEFT OUTER JOIN Organization_Users OU ON OU.UserNo = BR.ModUserNo
	LEFT OUTER JOIN Organization_Departments OD ON OD.DepartNo=BR.ModDepartNo AND OD.Enabled = TRUE
	LEFT OUTER JOIN Organization_Positions OP ON OP.PositionNo=BR.ModPositionNo AND OP.Enabled = TRUE
	WHERE ContentNo = board_getreplies.contentno
	ORDER BY GroupNo DESC, OrderNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
