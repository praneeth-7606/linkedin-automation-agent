CREATE TABLE IF NOT EXISTS people (
  person_id TEXT PRIMARY KEY,          -- LinkedIn profile URL
  name TEXT NOT NULL,
  company TEXT,
  role_title TEXT,
  relevance_score INTEGER CHECK (relevance_score BETWEEN 1 AND 10),
  profile_url TEXT,
  status TEXT NOT NULL DEFAULT 'discovered'
    CHECK (status IN ('discovered','requested','accepted','referral_sent','replied','declined','no_response')),
  previously_messaged INTEGER DEFAULT 0,
  connection_requested_at TEXT,
  connection_accepted_at TEXT,
  referral_sent_at TEXT,
  last_message_snippet TEXT,
  batch_id TEXT,
  notes TEXT
);

CREATE TABLE IF NOT EXISTS applications (
  job_id TEXT PRIMARY KEY,             -- job URL hash or board ID
  company TEXT,
  role TEXT,
  fit_score INTEGER CHECK (fit_score BETWEEN 1 AND 10),
  priority TEXT CHECK (priority IN ('P0-Perfect','P1-Strong','P2-Stretch')),
  status TEXT NOT NULL DEFAULT 'discovered'
    CHECK (status IN ('discovered','prioritized','networking','referred','applied','oa','interview','offer','rejected','withdrawn')),
  job_url TEXT,
  discovered_from TEXT,
  referral_person_id TEXT REFERENCES people(person_id),
  batch_id TEXT
);

CREATE INDEX IF NOT EXISTS idx_people_status ON people(status);
CREATE INDEX IF NOT EXISTS idx_apps_status ON applications(status);
