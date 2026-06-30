-- ─── TABLE: ScheduleToDos ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleToDos" (
    ToDoNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Title character varying(100) NOT NULL,
    GroupNo integer NOT NULL,
    Important integer NOT NULL,
    CompleteDate timestamp without time zone,
    IsComplete boolean NOT NULL,
    IsNotiNote boolean NOT NULL,
    IsNotiMail boolean NOT NULL,
    IsNotiSMS boolean NOT NULL,
    IsNotiPopup boolean NOT NULL,
    NotiTimeType integer NOT NULL,
    ProgressRate integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
