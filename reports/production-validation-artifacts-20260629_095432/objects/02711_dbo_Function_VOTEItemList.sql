-- ─── FUNCTION: voteitemlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.voteitemlist(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.voteitemlist(
    id integer,
    userno integer,
    authtype integer
) RETURNS TABLE(
    positionno text
)
AS $function$
BEGIN


	-- List
	RETURN QUERY
	SELECT I.* 
	FROM VOTEMaster M 
	JOIN VOTEItem I ON (M.ID = I.ParentID)
	WHERE M.ID = voteitemlist.id
	AND
	(
		CASE
		WHEN (AuthType = 1 OR AuthType = 2) THEN 1
		WHEN AuthType = 3 AND 
		(
			NOT EXISTS (SELECT * FROM VOTEQuestionnaire WHERE MasterID = M.ID)
			OR RegUserNo = voteitemlist.userno
			OR
			(
				EXISTS
				(
					SELECT * 
					FROM VOTEQuestionnaire 
					WHERE MasterID = M.ID AND Type = 'U' AND No = voteitemlist.userno
				)
			)
			OR
			(
				EXISTS
				(
					SELECT * 
					FROM VOTEQuestionnaire 
					WHERE MasterID = M.ID AND Type = 'EG' AND No IN
					(
						SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = voteitemlist.userno
					)
				)
			)
			OR
			(
				EXISTS
				(
					SELECT * 
					FROM VOTEQuestionnaire 
					WHERE MasterID = M.ID AND Type = 'UG' AND No IN
					(
						SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = voteitemlist.userno
					)
				)
			)
		) THEN 1
		ELSE 0 END 
	) = 1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
