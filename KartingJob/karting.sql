INSERT INTO `addon_account` (name, label, shared) VALUES
    ('society_Karting', 'Karting', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
    ('society_Karting', 'Karting', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
    ('society_Karting', 'Karting', 1)
;

INSERT INTO `jobs` (name, label) VALUES
    ('Karting', 'Karting')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
    ('Karting',0,'recrue','Stagiaire',12,'{}','{}'),
    ('Karting',1,'novice','Employee',24,'{}','{}'),
    ('Karting',2,'experimente','Gérant piste',36,'{}','{}'),
    ('Karting',3,'chief','Manager',48,'{}','{}'),
    ('Karting',4,'boss','Boss',0,'{}','{}')
;
