-- ─── TABLE: DMake_Auth_User ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Auth_User" (
    UserNo integer NOT NULL,
    BoardNo integer NOT NULL,
    IsRead boolean DEFAULT false,
    IsWrite boolean DEFAULT false,
    IsDelete boolean DEFAULT false,
    IsAdmin boolean DEFAULT false,
    PRIMARY KEY (UserNo, BoardNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
