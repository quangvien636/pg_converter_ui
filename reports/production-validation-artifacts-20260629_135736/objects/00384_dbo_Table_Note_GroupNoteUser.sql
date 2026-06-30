-- ─── TABLE: Note_GroupNoteUser ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Note_GroupNoteUser" (
    GroupNo uuid NOT NULL,
    ListNo uuid NOT NULL,
    UserNo integer NOT NULL,
    PRIMARY KEY (GroupNo, ListNo, UserNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
