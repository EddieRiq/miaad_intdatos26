
CREATE DATABASE IF NOT EXISTS pokemon_db;
USE pokemon_db;

DROP TABLE IF EXISTS pokemon_type_dim;

CREATE TABLE pokemon_type_dim (
  type_name VARCHAR(32) PRIMARY KEY,
  type_group VARCHAR(32) NOT NULL
);

INSERT INTO pokemon_type_dim (type_name, type_group) VALUES
('normal','neutral'),
('fire','hot'),
('water','wet'),
('electric','electric'),
('grass','nature'),
('ice','cold'),
('fighting','combat'),
('poison','toxic'),
('ground','earth'),
('flying','air'),
('psychic','mystic'),
('bug','nature'),
('rock','earth'),
('ghost','mystic'),
('dragon','mystic'),
('dark','mystic'),
('steel','earth'),
('fairy','mystic');
