-- Physical schema of the relaxation system database

create table users (
    id serial primary key,
    name varchar(50) not null check (name ~ '^[A-Za-zА-Яа-яЇїЄєІіҐґ\\s\\-]+$'),
    age int not null check (age > 0),
    stress_level int not null check (stress_level between 0 and 10),
    sleep_mode varchar(30)
);

create table exercises (
    id serial primary key,
    title varchar(100) not null check (title ~ '^[\\w\\s\\-\\.,!]{1,100}$'),
    type varchar(50) not null,
    duration int not null check (duration > 0),
    instruction varchar(300) not null check (instruction <> ''),
    user_id int not null,
    constraint fk_exercises_users foreign key (user_id)
        references users (id)
        on delete cascade
);

create table sleep_analysis (
    id serial primary key,
    duration float not null check (duration > 0),
    quality int not null check (quality between 1 and 10),
    start_time time not null,
    wake_time time not null,
    user_id int not null,
    constraint fk_sleep_analysis_users foreign key (user_id)
        references users (id)
        on delete cascade
);

create table feedback (
    id serial primary key,
    feedback_date date not null,
    rating int check (rating between 1 and 5),
    comment varchar(300),
    exercise_id int,
    constraint fk_feedback_exercises foreign key (exercise_id)
        references exercises (id)
        on delete set null
);

create table recommendations (
    id serial primary key,
    recommendation_type varchar(50) not null,
    recommendation_text varchar(300) not null check (recommendation_text <> ''),
    user_id int not null,
    sleep_analysis_id int,
    feedback_id int,
    constraint fk_recommendations_users foreign key (user_id)
        references users (id)
        on delete cascade,
    constraint fk_recommendations_sleep_analysis foreign key (sleep_analysis_id)
        references sleep_analysis (id)
        on delete set null,
    constraint fk_recommendations_feedback foreign key (feedback_id)
        references feedback (id)
        on delete set null
);
