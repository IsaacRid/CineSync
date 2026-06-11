CREATE TABLE users (
    user_id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    account_created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    account_updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE groups (
    group_id BIGSERIAL PRIMARY KEY,
    group_name VARCHAR(255) NOT NULL,
    created_by BIGINT NOT NULL REFERENCES users(user_id),
    max_size INT NOT NULL DEFAULT 8,
    group_created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    group_updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE group_members (
    user_id BIGINT NOT NULL REFERENCES users(user_id),
    group_id BIGINT NOT NULL REFERENCES groups(group_id),
    role VARCHAR(20) NOT NULL,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, group_id)
);

CREATE TABLE sessions (
    session_id BIGSERIAL PRIMARY KEY,
    group_id BIGINT NOT NULL REFERENCES groups(group_id),
    created_by BIGINT NOT NULL REFERENCES users(user_id),
    status VARCHAR(20) NOT NULL DEFAULT 'WAITING',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE session_user_genres (
    session_id BIGINT NOT NULL REFERENCES sessions(session_id),
    user_id BIGINT NOT NULL REFERENCES users(user_id),
    genre VARCHAR(100) NOT NULL,
    PRIMARY KEY (session_id, user_id, genre)
);

CREATE TABLE movies (
    movie_id BIGSERIAL PRIMARY KEY,
    tmdb_id BIGINT UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    overview TEXT NOT NULL,
    poster_path VARCHAR(255) NOT NULL,
    release_date DATE NOT NULL,
    vote_average DECIMAL(4,2) NOT NULL,
    runtime INT NOT NULL
);

CREATE TABLE swipes (
    swipe_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(user_id),
    movie_id BIGINT NOT NULL REFERENCES movies(movie_id),
    session_id BIGINT NOT NULL REFERENCES sessions(session_id),
    swiped_right BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, movie_id, session_id)
);

CREATE TABLE matches (
    match_id BIGSERIAL PRIMARY KEY,
    session_id BIGINT NOT NULL REFERENCES sessions(session_id),
    movie_id BIGINT NOT NULL REFERENCES movies(movie_id),
    matched_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (session_id, movie_id)
);

CREATE TABLE reviews (
    review_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(user_id),
    movie_id BIGINT NOT NULL REFERENCES movies(movie_id),
    group_id BIGINT NOT NULL REFERENCES groups(group_id),
    rating DECIMAL(2,1) NOT NULL,
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, movie_id, group_id)
);

CREATE TABLE watchlist (
    watchlist_id BIGSERIAL PRIMARY KEY,
    group_id BIGINT NOT NULL REFERENCES groups(group_id),
    movie_id BIGINT NOT NULL REFERENCES movies(movie_id),
    added_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (group_id, movie_id)
);