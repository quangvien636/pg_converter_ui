-- ─── PROCEDURE→FUNCTION: noticesyn_mobile_getlistofnotices ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_mobile_getlistofnotices(integer, character varying, integer, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_mobile_getlistofnotices(
    IN userno integer,
    IN searchtext character varying,
    IN divisionno integer,
    IN importantonly boolean,
    IN countofarticles integer,
    IN anchornoticeno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	Query := '';
	WhereQuery := '';
	OrderByQuery := '';
	Query := 'SELECT TOP (' || CONVERT(NVARCHAR, CountOfArticles) + ') N.NoticeNo, N.RegUserNo, N.RegDate, N.Title, ' +;
			'D.DivisionNo, D.Name AS DivisionName, ' +
			'N.Content, N.Important, ' +
			'(SELECT COUNT(*) FROM NoticeSyn_Reference R WHERE R.NoticeNo = N.NoticeNo) AS CountRead, ' +
			'(SELECT COUNT(*) FROM NoticeSyn_Comments C WHERE C.NoticeNo = N.NoticeNo) AS CountComment ' +
		'FROM Notices N ' +
		'INNER JOIN NoticeSyn_Divisions D ON D.DivisionNo = N.DivisionNo '

	---------------------------------------------------------------------------------------

	IF AnchorNoticeNo != 0 THEN

		WhereQuery := 'N.NoticeNo < ' || CONVERT(NVARCHAR, AnchorNoticeNo) + ' ';
	END IF;

	IF ImportantOnly = 1 THEN

		IF WhereQuery != '' THEN

			WhereQuery := WhereQuery || 'AND N.Important = 1 ';
		END IF;

		ELSE BEGIN

			WhereQuery := 'N.Important = 1 ';
		END IF;

	END;

	IF DivisionNo != 0 THEN

		IF WhereQuery != '' THEN

			WhereQuery := WhereQuery || 'AND N.DivisionNo = ' || CONVERT(NVARCHAR, DivisionNo) + ' ';
		END IF;

		ELSE BEGIN

			WhereQuery := 'N.DivisionNo = ' || CONVERT(NVARCHAR, DivisionNo) + ' ';
		END IF;

	END;

	IF SearchText != '' THEN

		IF WhereQuery != '' THEN

			WhereQuery := WhereQuery || 'AND (N.Title ILIKE ''%' || SearchText || '%'' OR Content ILIKE ''%' || SearchText || '%'')';
		END IF;

		ELSE BEGIN

			WhereQuery := '(N.Title ILIKE ''%' || SearchText || '%'' OR Content ILIKE ''%' || SearchText || '%'')';
		END IF;

	END;

	OrderByQuery := 'ORDER BY N.RegDate DESC';
	---------------------------------------------------------------------------------------

	IF WhereQuery != '' THEN

		WhereQuery := 'WHERE ' || WhereQuery;
	END IF;

	Query := Query + WhereQuery + OrderByQuery;
	RAISE NOTICE '%', Query
	PERFORM query();
END;
-------------------------- /////////////////-----------------

-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
