-- Active: 1748254570380@@127.0.0.1@5432@conservation_db
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL
)

CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(species_id),
    ranger_id INT REFERENCES rangers(ranger_id),
    location VARCHAR(100) NOT NULL,
    sighting_time TIMESTAMP with time zone NOT NULL,
    notes TEXT
)

INSERT INTO  rangers (name, region)
VALUES ('Alice Green', 'Northern Hills'),('Bob White', 'River Delta'),('Carol King', 'Mountain Range');

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status)
VALUES ('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes)
VALUES (1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

-- Problem 1
INSERT INTO rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains')

-- Problem 2
SELECT count(DISTINCT species_id) as "unique_species_count" FROM sightings

-- Problem 3
SELECT * FROM sightings
WHERE location LIKE '%Pass%';

-- Problem 4
SELECT r.name, count(r.ranger_id = s.ranger_id) as "total_sightings" FROM rangers as r
LEFT JOIN sightings as s ON r.ranger_id = s.ranger_id
GROUP BY r.name, s.ranger_id
ORDER BY r.name ASC;

-- Problem 5
SELECT common_name FROM species
WHERE species_id NOT IN (SELECT DISTINCT species_id FROM sightings);

-- Problem 6
SELECT s.common_name, si.sighting_time, r.name FROM sightings as si
LEFT JOIN species as s ON si.species_id = s.species_id
LEFT JOIN rangers as r ON si.ranger_id = r.ranger_id
ORDER BY si.sighting_time DESC
LIMIT 2;

-- Problem 7
UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date::date < '1800-01-01'::date;

-- Problem 8
SELECT sighting_id,
CASE
    WHEN extract(HOUR from sighting_time) BETWEEN '0' AND '11' THEN 'Morning'
    WHEN extract(HOUR from sighting_time) BETWEEN '12' AND '16' THEN 'Afternoon'
    WHEN extract(HOUR from sighting_time) BETWEEN '17' AND '23' THEN 'Evening'
    ELSE 'Out of Range'
END AS time_of_day
FROM sightings;

-- Problem 9
DELETE FROM rangers
WHERE ranger_id NOT IN (SELECT DISTINCT ranger_id FROM sightings);