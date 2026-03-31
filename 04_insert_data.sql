
INSERT INTO country (name)
SELECT * FROM (VALUES ('Uzbekistan'), ('Kazakhstan')) AS v(name)
WHERE NOT EXISTS (SELECT 1 FROM country c WHERE c.name = v.name);

INSERT INTO city (name, country_id)
SELECT 'Tashkent', country_id FROM country WHERE name = 'Uzbekistan'
ON CONFLICT DO NOTHING;

INSERT INTO city (name, country_id)
SELECT 'Almaty', country_id FROM country WHERE name = 'Kazakhstan'
ON CONFLICT DO NOTHING;

INSERT INTO station (name, city_id)
SELECT 'Central Station', city_id FROM city WHERE name = 'Tashkent'
ON CONFLICT DO NOTHING;

INSERT INTO station (name, city_id)
SELECT 'North Station', city_id FROM city WHERE name = 'Almaty'
ON CONFLICT DO NOTHING;

INSERT INTO sensor (type, unit, station_id)
SELECT 'Temperature', 'C', station_id FROM station WHERE name = 'Central Station'
ON CONFLICT DO NOTHING;

INSERT INTO sensor (type, unit, station_id)
SELECT 'Humidity', '%', station_id FROM station WHERE name = 'North Station'
ON CONFLICT DO NOTHING;

INSERT INTO measurement (sensor_id, measured_value, measured_at)
SELECT sensor_id, 25.5, '2023-01-01' FROM sensor WHERE type = 'Temperature'
ON CONFLICT DO NOTHING;

INSERT INTO measurement (sensor_id, measured_value, measured_at)
SELECT sensor_id, 60.2, '2023-02-01' FROM sensor WHERE type = 'Humidity'
ON CONFLICT DO NOTHING;

INSERT INTO app_user (full_name, gender)
VALUES 
('John Doe', 'male'),
('Anna Smith', 'female')
ON CONFLICT DO NOTHING;

INSERT INTO role (role_name)
VALUES ('admin'), ('operator')
ON CONFLICT DO NOTHING;

INSERT INTO user_role (user_id, role_id)
SELECT u.user_id, r.role_id
FROM app_user u, role r
WHERE u.full_name = 'John Doe' AND r.role_name = 'admin'
ON CONFLICT DO NOTHING;

INSERT INTO user_role (user_id, role_id)
SELECT u.user_id, r.role_id
FROM app_user u, role r
WHERE u.full_name = 'Anna Smith' AND r.role_name = 'operator'
ON CONFLICT DO NOTHING;

INSERT INTO alert (measurement_id, message)
SELECT measurement_id, 'High temperature detected'
FROM measurement
LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO device (serial_number, station_id)
SELECT 'SN-001', station_id FROM station WHERE name = 'Central Station'
ON CONFLICT DO NOTHING;

INSERT INTO device (serial_number, station_id)
SELECT 'SN-002', station_id FROM station WHERE name = 'North Station'
ON CONFLICT DO NOTHING;
