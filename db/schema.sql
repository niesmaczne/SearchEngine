BEGIN;

CREATE TABLE rss_feed (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    summary VARCHAR(32000),
    author VARCHAR(255),
    creation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    url VARCHAR(2083)  -- 2083 is a common maximum length for URLs
);

COMMIT;