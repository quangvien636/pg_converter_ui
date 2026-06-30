-- ─── FUNCTION: worktodo_getreportbyuserno ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_getreportbyuserno(integer, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.worktodo_getreportbyuserno(
    userno integer,
    startdate timestamp without time zone,
    enddate timestamp without time zone
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


		countAssignedTask int,
		countCompleted int,
		countRejected int,
		countRestart int,
		countHold int,
		countCancel int,
		workingTime int,
		countStandby int,
		countRunning int,
		countDDay int,
		countChecking int

		set countTaskAssigned = (select count(*) from WorkToDo_ToDoList where  ModUserNo = worktodo_getreportbyuserno.userno and RepNo != worktodo_getreportbyuserno.userno and State in (0,1,2,6,7,8) and StartDate >=worktodo_getreportbyuserno.startdate and EndDate<=worktodo_getreportbyuserno.enddate )

		set countAssignedTask = (select count(*) from WorkToDo_ToDoList where  RepNo = worktodo_getreportbyuserno.userno AND ModUserNo != worktodo_getreportbyuserno.userno and State in (0,1,2,6,7,8) and StartDate >= worktodo_getreportbyuserno.startdate and EndDate <= worktodo_getreportbyuserno.enddate )

		set countCompleted = (select count(*) from WorkToDo_ToDoList where RepNo=worktodo_getreportbyuserno.userno and State=3 and StartDate >=worktodo_getreportbyuserno.startdate and EndDate<=worktodo_getreportbyuserno.enddate )

		set countRejected = (select count(*) from WorkToDo_ToDoList where RepNo=worktodo_getreportbyuserno.userno and State=6 and StartDate >=worktodo_getreportbyuserno.startdate and EndDate<=worktodo_getreportbyuserno.enddate )

		set countRestart = (select count(*) from WorkToDo_ToDoList where RepNo=worktodo_getreportbyuserno.userno and State=7 and StartDate >=worktodo_getreportbyuserno.startdate and EndDate<=worktodo_getreportbyuserno.enddate )

		set countHold = (select count(*) from WorkToDo_ToDoList where RepNo=worktodo_getreportbyuserno.userno and State=4 and StartDate >=worktodo_getreportbyuserno.startdate and EndDate<=worktodo_getreportbyuserno.enddate )

		set countCancel = (select count(*) from WorkToDo_ToDoList where RepNo=worktodo_getreportbyuserno.userno and State=5 and StartDate >=worktodo_getreportbyuserno.startdate and EndDate<=worktodo_getreportbyuserno.enddate )

		--set workingTime = (select sum(WorkTime) from WorkToDo_Journals where DataNo in (select DataNo from WorkToDo_ToDoList where RepNo=UserNo and State in (1,2,3,4,5,6,7,8) and StartDate >=StartDate and EndDate<=EndDate and RepNo = UserNo and ModUserNo != UserNo))
		set workingTime = (SELECT sum(WorkTime) FROM WorkToDo_Journals J INNER JOIN WorkToDo_ToDoList T ON T.DataNo = J.DataNo
							WHERE J.ModUserNo = worktodo_getreportbyuserno.userno AND WriteDate between StartDate and EndDate )

		set countStandby = (select count(*) from WorkToDo_ToDoList where RepNo=worktodo_getreportbyuserno.userno and State=2)

		set countRunning =  (select count(*) from WorkToDo_ToDoList where RepNo=worktodo_getreportbyuserno.userno and State=1)

		set countDDay =  (select count(*) from WorkToDo_ToDoList where RepNo=worktodo_getreportbyuserno.userno and State=1 and NOW() > (EndDate + 1))

		set countChecking =  (select count(*) from WorkToDo_ToDoList where RepNo=worktodo_getreportbyuserno.userno and State=8)

	 RETURN QUERY
	 select
			countTaskAssigned as TaskAssigned,
			countAssignedTask as AssignedTask,
            countCompleted as Completed,
			countRejected as Rejected,
			countRestart as Restart,
			countHold as Hold,
			countCancel as Cancel,
			workingTime as totalWorkingTime,
			countRunning as Running,
			countDDay as CountDDay,
			countStandby as StandBy,
			countChecking as Checking;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
