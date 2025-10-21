-- DataSchema.sql
-- Physical schema of the Relaxation System Database

CREATE TABLE "User" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL CHECK (name ~ '^[A-Za-zА-Яа-яЇїЄєІіҐґ\\s\\-]+$'),
    age INT NOT NULL CHECK (age > 0),
    stress_level INT NOT NULL CHECK (stress_level BETWEEN 0 AND 10),
    sleep_mode VARCHAR(30)
);

CREATE TABLE Exercise (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL CHECK (title ~ '^[\\w\\s\\-\\.,!]{1,100}$'),
    type VARCHAR(50) NOT NULL,
    duration INT NOT NULL CHECK (duration > 0),
    instruction VARCHAR(300) NOT NULL CHECK (instruction <> ''),
    user_id INT NOT NULL,
    CONSTRAINT fk_exercise_user FOREIGN KEY (user_id)
        REFERENCES "User" (id)
        ON DELETE CASCADE
);

CREATE TABLE Sleep_Analysis (
    id SERIAL PRIMARY KEY,
    duration FLOAT NOT NULL CHECK (duration > 0),
    quality INT NOT NULL CHECK (quality BETWEEN 1 AND 10),
    start_time TIME NOT NULL,
    wake_time TIME NOT NULL,
    user_id INT NOT NULL,
    CONSTRAINT fk_sleep_analysis_user FOREIGN KEY (user_id)
        REFERENCES "User" (id)
        ON DELETE CASCADE
);

CREATE TABLE Feedback (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment VARCHAR(300),
    exercise_id INT,
    CONSTRAINT fk_feedback_exercise FOREIGN KEY (exercise_id)
        REFERENCES Exercise (id)
        ON DELETE SET NULL
);

CREATE TABLE Recommendation (
    id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    text VARCHAR(300) NOT NULL CHECK (text <> ''),
    user_id INT NOT NULL,
    sleep_analysis_id INT,
    feedback_id INT,
    CONSTRAINT fk_recommendation_user FOREIGN KEY (user_id)
        REFERENCES "User" (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_recommendation_sleep_analysis FOREIGN KEY (sleep_analysis_id)
        REFERENCES Sleep_Analysis (id)
        ON DELETE SET NULL,
    CONSTRAINT fk_recommendation_feedback FOREIGN KEY (feedback_id)
        REFERENCES Feedback (id)
        ON DELETE SET NULL
);