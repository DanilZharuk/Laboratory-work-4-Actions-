-- DataSchema.sql
-- Physical schema of the Relaxation System Database

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL
    CHECK (full_name ~ '^[A-Za-zА-Яа-яЇїЄєІіҐґ\\s\\-]+$'),
    age INT NOT NULL CHECK (age > 0),
    stress_level INT NOT NULL
    CHECK (stress_level BETWEEN 0 AND 10),
    sleep_mode VARCHAR(30)
);

CREATE TABLE exercises (
    exercise_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL
    CHECK (title ~ '^[\\w\\s\\-\\.,!]{1,100}$'),
    exercise_kind VARCHAR(50) NOT NULL,
    duration_min INT NOT NULL CHECK (duration_min > 0),
    instruction VARCHAR(300) NOT NULL CHECK (instruction <> ''),
    user_ref INT NOT NULL,
    CONSTRAINT fk_exercises_users FOREIGN KEY (user_ref)
    REFERENCES users (user_id)
    ON DELETE CASCADE
);

CREATE TABLE sleep_analysis (
    sleep_id SERIAL PRIMARY KEY,
    sleep_duration FLOAT NOT NULL CHECK (sleep_duration > 0),
    quality INT NOT NULL CHECK (quality BETWEEN 1 AND 10),
    start_at TIME NOT NULL,
    wake_at TIME NOT NULL,
    user_ref INT NOT NULL,
    CONSTRAINT fk_sleep_analysis_users FOREIGN KEY (user_ref)
    REFERENCES users (user_id)
    ON DELETE CASCADE
);

CREATE TABLE feedback (
    feedback_id SERIAL PRIMARY KEY,
    feedback_date DATE NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    feedback_comment VARCHAR(300),
    exercise_ref INT,
    CONSTRAINT fk_feedback_exercises FOREIGN KEY (exercise_ref)
    REFERENCES exercises (exercise_id)
    ON DELETE SET NULL
);

CREATE TABLE recommendations (
    recommendation_id SERIAL PRIMARY KEY,
    rec_type VARCHAR(50) NOT NULL,
    rec_text VARCHAR(300) NOT NULL
    CHECK (rec_text <> ''),
    user_ref INT NOT NULL,
    sleep_ref INT,
    feedback_ref INT,
    CONSTRAINT fk_recommendations_users FOREIGN KEY (user_ref)
    REFERENCES users (user_id)
    ON DELETE CASCADE,
    CONSTRAINT fk_recommendations_sleep FOREIGN KEY (sleep_ref)
    REFERENCES sleep_analysis (sleep_id)
    ON DELETE SET NULL,
    CONSTRAINT fk_recommendations_feedback FOREIGN KEY (feedback_ref)
    REFERENCES feedback (feedback_id)
    ON DELETE SET NULL
);
