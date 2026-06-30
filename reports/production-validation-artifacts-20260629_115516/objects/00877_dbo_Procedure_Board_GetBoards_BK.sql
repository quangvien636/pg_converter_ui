-- ─── PROCEDURE→FUNCTION: board_getboards_bk ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getboards_bk(integer, boolean, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_getboards_bk(
    IN userno integer DEFAULT 70,
    IN isdisabled boolean DEFAULT FALSE,
    IN viewmode integer DEFAULT -1,
    IN displaytypeno integer DEFAULT -1,
    IN isadmin boolean DEFAULT FALSE
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF IsDisabled = TRUE THEN
	   IF IsAdmin = FALSE THEN
			RETURN QUERY
			SELECT BoardNo, ModUserNo, ModDate, Name, Description, FolderNo, DisplayTypeNo, SortNo,
				IsReply, IsHead, IsNotice, IsRecommend, RecommendedDisplayCount, Enabled,ViewMode,SpecType,
				(SELECT COUNT(*) FROM Board_Contents BC 
				WHERE BC.BoardNo = Board_Boards.BoardNo AND BC.Enabled = TRUE-- And BC.RegUserNo <> UserNo 
					And BC.BoardNo IN (SELECT * FROM public."Board_GetBoardAllow"(  UserNo ,2))
					And BC.ContentNo Not In (Select Board_ViewedLogs.ContentNo From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getboards_bk.userno)
					AND ((BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 INNER JOIN public."Organization_GetDepartmentsByUser"(UserNo) DP ON DP.DepartNo= BS1.DepartNo)) OR (BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1
where BSS1.contentno=BC.ContentNo and BSS1.userno=board_getboards_bk.userno)) OR ((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = BC.ContentNO) <=0 ) )  ) As CountContent
			FROM Board_Boards 
			WHERE (ViewMode=board_getboards_bk.viewmode OR ViewMode < 0) And (DisplayTypeNo=board_getboards_bk.displaytypeno OR DisplayTypeNo < 0)
			ORDER BY SortNo ASC ,BoardNo ASC
	   END IF;
	   ELSE
			RETURN QUERY
			SELECT BoardNo, ModUserNo, ModDate, Name, Description, FolderNo, DisplayTypeNo, SortNo,
				IsReply, IsHead, IsNotice, IsRecommend, RecommendedDisplayCount, Enabled,ViewMode,SpecType,
				(SELECT COUNT(*) FROM Board_Contents BC  WHERE BC.BoardNo = Board_Boards.BoardNo AND BC.Enabled = TRUE-- And BC.RegUserNo <> UserNo 
					And BC.ContentNo Not In (Select Board_ViewedLogs.ContentNo From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getboards_bk.userno) ) As CountContent
			FROM Board_Boards
			WHERE (ViewMode=board_getboards_bk.viewmode OR ViewMode < 0) And (DisplayTypeNo=board_getboards_bk.displaytypeno OR DisplayTypeNo < 0)
			ORDER BY SortNo ASC ,BoardNo ASC
	   END IF;
		

	END IF;
	
	ELSE BEGIN
		IF IsAdmin = FALSE THEN
			RETURN QUERY
			SELECT BoardNo, ModUserNo, ModDate, Name, Description, FolderNo, DisplayTypeNo, SortNo,
				IsReply, IsHead, IsNotice, IsRecommend, RecommendedDisplayCount, Enabled,ViewMode,SpecType,
				(SELECT COUNT(*) FROM Board_Contents BC 
				WHERE BC.BoardNo = Board_Boards.BoardNo AND BC.Enabled = TRUE --And BC.RegUserNo <> UserNo 
					And BC.BoardNo IN (SELECT * FROM public."Board_GetBoardAllow"(  UserNo ,2))
					And BC.ContentNo Not In (Select Board_ViewedLogs.ContentNo From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getboards_bk.userno)
					AND ((BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 INNER JOIN public."Organization_GetDepartmentsByUser"(UserNo) DP ON DP.DepartNo= BS1.DepartNo)) OR (BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1
where BSS1.contentno=BC.ContentNo and BSS1.userno=board_getboards_bk.userno)) OR ((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = BC.ContentNO) <=0 ) ) ) As CountContent
			FROM Board_Boards
			WHERE Enabled = TRUE AND (ViewMode=board_getboards_bk.viewmode  OR ViewMode < 0) And (DisplayTypeNo=board_getboards_bk.displaytypeno OR DisplayTypeNo < 0)
			ORDER BY SortNo ASC ,BoardNo ASC
		END IF;
	   ELSE
			RETURN QUERY
			SELECT BoardNo, ModUserNo, ModDate, Name, Description, FolderNo, DisplayTypeNo, SortNo,
				IsReply, IsHead, IsNotice, IsRecommend, RecommendedDisplayCount, Enabled,ViewMode,SpecType,
				(SELECT COUNT(*) FROM Board_Contents  
					WHERE  Board_Contents.BoardNo = Board_Boards.BoardNo AND Enabled = TRUE 
						--And Board_Contents.RegUserNo <> UserNo 
						And Board_Contents.ContentNo Not In (Select Board_ViewedLogs.ContentNo From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getboards_bk.userno)) As CountContent
			FROM Board_Boards
			WHERE Enabled = TRUE AND (ViewMode=board_getboards_bk.viewmode  OR ViewMode < 0) And (DisplayTypeNo=board_getboards_bk.displaytypeno OR DisplayTypeNo < 0)
			ORDER BY SortNo ASC,BoardNo ASC
	   END IF;
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
