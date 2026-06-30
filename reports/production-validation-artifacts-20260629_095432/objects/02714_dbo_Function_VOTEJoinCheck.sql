-- ─── FUNCTION: votejoincheck ───────────────────────────────
DROP FUNCTION IF EXISTS public.votejoincheck(integer, integer);
CREATE OR REPLACE FUNCTION public.votejoincheck(
    id integer,
    userno integer
) RETURNS TABLE(
    positionno text
)
AS $function$
BEGIN


	-- Check
	RETURN QUERY
	SELECT SUM(Cnt) Cnt
	FROM
	(
		SELECT CASE WHEN NOT EXISTS (SELECT * FROM VOTEQuestionnaire WHERE MasterID = votejoincheck.id) THEN 1 ELSE 0 END Cnt
		UNION ALL
			SELECT COUNT(*) Cnt 
			FROM VOTEQuestionnaire 
			WHERE MasterID = votejoincheck.id AND Type = 'U' AND No = votejoincheck.userno
		UNION ALL
			SELECT COUNT(*) Cnt
			FROM VOTEQuestionnaire 
			WHERE MasterID = votejoincheck.id AND Type = 'EG' AND No IN
			(
				SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = votejoincheck.userno
			)
		UNION ALL
			SELECT COUNT(*) Cnt
			FROM VOTEQuestionnaire 
			WHERE MasterID = votejoincheck.id AND Type = 'UG' AND No IN
			(
				SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = votejoincheck.userno
			)
	) R1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
