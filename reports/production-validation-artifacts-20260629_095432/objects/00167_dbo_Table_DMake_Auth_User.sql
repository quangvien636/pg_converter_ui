-- ─── TABLE: DMake_Auth_User ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Auth_User" (
    UserNo integer NOT NULL,
    BoardNo integer NOT NULL,
    IsRead boolean,
    IsWrite boolean,
    IsDelete boolean,
    IsAdmin boolean,
    PRIMARY KEY (UserNo, BoardNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
