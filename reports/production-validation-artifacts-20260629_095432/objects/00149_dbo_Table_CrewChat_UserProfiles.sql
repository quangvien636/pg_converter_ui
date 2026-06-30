-- ─── TABLE: CrewChat_UserProfiles ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_UserProfiles" (
    ProfileNo serial NOT NULL,
    UserNo integer NOT NULL,
    NickName character varying(20) NOT NULL,
    StateMessage character varying(60) NOT NULL,
    StateType integer NOT NULL,
    PCVersion character varying(50)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
