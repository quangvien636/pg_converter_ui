-- ─── FUNCTION: noticesyn_mobile_getlistofnotices ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_mobile_getlistofnotices(integer, character varying, integer, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_mobile_getlistofnotices(
    userno integer,
    searchtext character varying,
    divisionno integer,
    importantonly boolean,
    countofarticles integer,
    anchornoticeno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN




	SET Query = ''
	SET WhereQuery = ''
	SET OrderByQuery = ''
	
	SET Query =
		'SELECT TOP (' || CONVERT(NVARCHAR, CountOfArticles) + ') N.NoticeNo, N.RegUserNo, N.RegDate, N.Title, ' +
			'D.DivisionNo, D.Name AS DivisionName, ' +
			'N.Content, N.Important, ' +
			'(SELECT COUNT(*) FROM NoticeSyn_Reference R WHERE R.NoticeNo = N.NoticeNo) AS CountRead, ' +
			'(SELECT COUNT(*) FROM NoticeSyn_Comments C WHERE C.NoticeNo = N.NoticeNo) AS CountComment ' +
		'FROM Notices N ' +
		'INNER JOIN NoticeSyn_Divisions D ON D.DivisionNo = N.DivisionNo '

	---------------------------------------------------------------------------------------

	IF (AnchorNoticeNo != 0) BEGIN

		SET WhereQuery = 'N.NoticeNo < ' || CONVERT(NVARCHAR, AnchorNoticeNo) + ' '

	END

	IF (ImportantOnly = 1) BEGIN

		IF (WhereQuery != '') BEGIN

			SET WhereQuery = WhereQuery || 'AND N.Important = 1 '

		END

		ELSE BEGIN

			SET WhereQuery = 'N.Important = 1 '

		END

	END

	IF (DivisionNo != 0) BEGIN

		IF (WhereQuery != '') BEGIN

			SET WhereQuery = WhereQuery || 'AND N.DivisionNo = ' || CONVERT(NVARCHAR, DivisionNo) + ' '

		END

		ELSE BEGIN

			SET WhereQuery = 'N.DivisionNo = ' || CONVERT(NVARCHAR, DivisionNo) + ' '

		END

	END

	IF (SearchText != '' ) BEGIN

		IF (WhereQuery != '') BEGIN

			SET WhereQuery = WhereQuery || 'AND (N.Title ILIKE ''%' || SearchText || '%'' OR Content ILIKE ''%' || SearchText || '%'')'

		END

		ELSE BEGIN

			SET WhereQuery = '(N.Title ILIKE ''%' || SearchText || '%'' OR Content ILIKE ''%' || SearchText || '%'')'

		END

	END

	SET OrderByQuery = 'ORDER BY N.RegDate DESC'

	---------------------------------------------------------------------------------------

	IF (WhereQuery != '') BEGIN

		SET WhereQuery = 'WHERE ' || WhereQuery

	END

	SET Query = Query + WhereQuery + OrderByQuery
	RAISE NOTICE '%', Query
	EXEC SP_EXECUTESQL Query

END;
-------------------------- /////////////////-----------------

-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
