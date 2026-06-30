-- ─── TABLE: WCHATMembers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WCHATMembers" (
    MemberNo serial NOT NULL,
    ChatNo integer NOT NULL,
    UserNo integer NOT NULL,
    RegDate timestamp without time zone,
    IsAlarm boolean
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
