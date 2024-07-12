
-- Use the new database
USE HospitalDB;
GO

-- Create tables
CREATE TABLE adm_prc (
    adprc_no INT NOT NULL,
    adprc_date_time DATETIME NOT NULL,
    adprc_pat_cost DECIMAL(7, 2) NOT NULL,
    adprc_items_cost DECIMAL(6, 2) NOT NULL,
    adm_no INT NOT NULL,
    proc_code INT NOT NULL,
    request_dr_id INT NOT NULL,
    perform_dr_id INT,
    CONSTRAINT PK_adm_prc PRIMARY KEY (adprc_no)
);
GO

CREATE TABLE admission (
    adm_no INT NOT NULL,
    adm_date_time DATETIME NOT NULL,
    adm_discharge DATETIME,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    CONSTRAINT PK_admission PRIMARY KEY (adm_no)
);
GO

CREATE TABLE costcentre (
    cc_code CHAR(5) NOT NULL,
    cc_title VARCHAR(50) NOT NULL,
    cc_manager_name VARCHAR(80) NOT NULL,
    CONSTRAINT PK_costcentre PRIMARY KEY (cc_code)
);
GO

CREATE TABLE doctor (
    doctor_id INT NOT NULL,
    doctor_title VARCHAR(2) NOT NULL,
    doctor_fname VARCHAR(50),
    doctor_lname VARCHAR(50),
    doctor_phone CHAR(10) NOT NULL,
    CONSTRAINT PK_doctor PRIMARY KEY (doctor_id)
);
GO

CREATE TABLE doctor_speciality (
    spec_code CHAR(6) NOT NULL,
    doctor_id INT NOT NULL,
    CONSTRAINT PK_doctor_speciality PRIMARY KEY (spec_code, doctor_id)
);
GO

CREATE TABLE item (
    item_code CHAR(5) NOT NULL,
    item_description VARCHAR(100) NOT NULL,
    item_stock INT NOT NULL,
    item_cost DECIMAL(7, 2) NOT NULL,
    cc_code CHAR(5) NOT NULL,
    CONSTRAINT PK_item PRIMARY KEY (item_code)
);
GO

CREATE TABLE item_treatment (
    adprc_no INT NOT NULL,
    item_code CHAR(5) NOT NULL,
    it_qty_used INT NOT NULL,
    it_item_total_cost DECIMAL(8, 2) NOT NULL,
    CONSTRAINT PK_item_treatment PRIMARY KEY (adprc_no, item_code)
);
GO

CREATE TABLE patient (
    patient_id INT NOT NULL,
    patient_fname VARCHAR(50),
    patient_lname VARCHAR(50),
    patient_address VARCHAR(100) NOT NULL,
    patient_dob DATE NOT NULL,
    patient_contact_phn CHAR(10) NOT NULL,
    CONSTRAINT PK_patient PRIMARY KEY (patient_id)
);
GO

CREATE TABLE medical_procedure (
    proc_code INT NOT NULL,
    proc_name VARCHAR(100) NOT NULL,
    proc_description VARCHAR(300) NOT NULL,
    proc_time INT NOT NULL,
    proc_std_cost DECIMAL(7, 2) NOT NULL,
    CONSTRAINT PK_medical_procedure PRIMARY KEY (proc_code)
);
GO

CREATE TABLE speciality (
    spec_code CHAR(6) NOT NULL,
    spec_description VARCHAR(50) NOT NULL,
    CONSTRAINT PK_speciality PRIMARY KEY (spec_code)
);
GO

-- Add foreign key constraints
ALTER TABLE adm_prc ADD CONSTRAINT FK_adm_prc_admission FOREIGN KEY (adm_no) REFERENCES admission (adm_no);
ALTER TABLE item_treatment ADD CONSTRAINT FK_item_treatment_adm_prc FOREIGN KEY (adprc_no) REFERENCES adm_prc (adprc_no);
ALTER TABLE item ADD CONSTRAINT FK_item_costcentre FOREIGN KEY (cc_code) REFERENCES costcentre (cc_code);
ALTER TABLE admission ADD CONSTRAINT FK_admission_doctor FOREIGN KEY (doctor_id) REFERENCES doctor (doctor_id);
ALTER TABLE doctor_speciality ADD CONSTRAINT FK_doctor_speciality_doctor FOREIGN KEY (doctor_id) REFERENCES doctor (doctor_id);
ALTER TABLE adm_prc ADD CONSTRAINT FK_adm_prc_doctor_perform FOREIGN KEY (perform_dr_id) REFERENCES doctor (doctor_id);
ALTER TABLE adm_prc ADD CONSTRAINT FK_adm_prc_doctor_request FOREIGN KEY (request_dr_id) REFERENCES doctor (doctor_id);
ALTER TABLE item_treatment ADD CONSTRAINT FK_item_treatment_item FOREIGN KEY (item_code) REFERENCES item (item_code);
ALTER TABLE admission ADD CONSTRAINT FK_admission_patient FOREIGN KEY (patient_id) REFERENCES patient (patient_id);
ALTER TABLE adm_prc ADD CONSTRAINT FK_adm_prc_medical_procedure FOREIGN KEY (proc_code) REFERENCES medical_procedure (proc_code);
ALTER TABLE doctor_speciality ADD CONSTRAINT FK_doctor_speciality_speciality FOREIGN KEY (spec_code) REFERENCES speciality (spec_code);

GO

--------------------------------------------------------
--  Sample DATA Monash Hospital
--------------------------------------------------------

-- Inserting sample data into medical_procedure
INSERT INTO medical_procedure (proc_code, proc_name, proc_description, proc_time, proc_std_cost) VALUES 
(12055, 'Appendectomy', 'Removal of appendix', 60, 250),
(15509, 'X-ray, Right knee', 'Right knee Bi-Lateral 2D Scan', 20, 75),
(15510, 'X-ray, Left knee', 'Left knee Bi-Lateral 2D Scan', 20, 75),
(15511, 'MRI', 'Imaging of brain', 90, 200),
(17122, 'Childbirth', 'Caesarean section', 80, 500),
(19887, 'Colonoscopy', 'Bowel examination', 25, 68),
(23432, 'Mental health', 'Counseling for children', 60, 98),
(27459, 'Corneal replacement', 'Replacement of cornea', 60, 633),
(29844, 'Tonsillectomy', 'Removal of tonsils', 45, 109.28),
(32266, 'Hemoglobin concentration', 'Measuring oxygen carrying protein in blood', 15, 76),
(33335, 'Eye test', 'Test for eye problems', 40, 70.45),
(40099, 'Scratch test', 'Allergy test on skin surface', 15, 40),
(40100, 'Skin surgery', 'Removal of mole', 20, 33.5),
(43111, 'Angiogram', 'Insertion of catheter into artery', 180, 355),
(43112, 'Thoracic surgery', 'Removal of lung tumor', 180, 399),
(43114, 'Heart surgery', 'Insertion of a pacemaker', 45, 120.66),
(43556, 'Vascular surgery', 'Removal of varicose veins', 120, 243.1),
(49518, 'Total replacement, Right knee', 'Right knee replacement by artificial joint', 180, 350),
(54132, 'Plastic surgery', 'Burn surgery to repair skin', 170, 244),
(65554, 'Blood screen', 'Full blood test', 10, 30),
(71432, 'Genetic testing', 'Screening for genetically carried diseases', 15, 65.2);

-- Inserting sample data into speciality
INSERT INTO speciality (spec_code, spec_description) VALUES 
('ALLERG', 'Allergy and immunology'),
('CARDIO', 'Cardiovascular disease'),
('DERMAT', 'Dermatology'),
('GENETI', 'Medical genetics'),
('HEMATO', 'Hematology and oncology'),
('NEUROL', 'Neurological surgery'),
('OBSTET', 'Obstetrics and gynecology'),
('OPHTHA', 'Ophthalmology'),
('ORTHOP', 'Orthopedic surgery'),
('OTOLAR', 'Otolaryngology'),
('PATHOL', 'Pathology'),
('PEDIAT', 'Pediatrics'),
('PLASTI', 'Plastic surgery'),
('PULMON', 'Pulmonary disease and critical care medicine'),
('RADIOL', 'Radiology'),
('THORAC', 'Thoracic surgery'),
('VASCUL', 'Vascular surgery');

-- Inserting sample data into doctor
INSERT INTO doctor (doctor_id, doctor_title, doctor_fname, doctor_lname, doctor_phone) VALUES 
(1005, 'Mr', 'Erich', 'Argabrite', '1755428382'),
(1012, 'Dr', 'Tedi', 'Jeeves', '9188264756'),
(1018, 'Dr', 'Caresa', 'Cornilleau', '1334007521'),
(1027, 'Mr', 'Mikaela', 'Leyban', '9296294312'),
(1028, 'Ms', 'Cherilyn', 'Bray', '7359457889'),
(1033, 'Dr', 'Sawyer', 'Haisell', '3914928134'),
(1048, 'Dr', 'Steffane', 'Banstead', '9466787825'),
(1056, 'Ms', 'Minnnie', 'Udey', '8158285073'),
(1060, 'Dr', 'Decca', 'Blankhorn', '4942993995'),
(1061, 'Mr', 'Jere', 'Digman', '1281091935'),
(1064, 'Mr', 'Rudolph', 'Jowett', '9873380817'),
(1069, 'Ms', 'Corry', 'Walrond', '3531087771'),
(1084, 'Ms', 'Rollie', 'Whayman', '5649708242'),
(1095, 'Dr', 'Bonnibelle', 'Misk', '1289776540'),
(1099, 'Ms', 'Irv', 'Tourner', '5689696759'),
(1298, 'Mr', 'Graham', 'Brown', '1234567899'),
(2459, 'Dr', 'Robert', 'Lu', '1515141312'),
(7890, 'Dr', 'Mary', 'Wei', '6655443377'),
(7900, 'Dr', 'Juixan', 'Wei', '6622544311');

-- Inserting sample data into doctor_speciality
INSERT INTO doctor_speciality (spec_code, doctor_id) VALUES 
('ALLERG', 1012),
('CARDIO', 1005),
('DERMAT', 1028),
('GENETI', 1033),
('HEMATO', 1061),
('NEUROL', 1048),
('OBSTET', 1056),
('OPHTHA', 1060),
('ORTHOP', 1298),
('ORTHOP', 2459),
('ORTHOP', 7890),
('OTOLAR', 1064),
('PATHOL', 1061),
('PATHOL', 1069),
('PEDIAT', 1027),
('PLASTI', 1084),
('PLASTI', 1095),
('PULMON', 1033),
('RADIOL', 1060),
('THORAC', 1060),
('VASCUL', 1005),
('ORTHOP', 7900);

-- Inserting sample data into costcentre
INSERT INTO costcentre (cc_code, cc_title, cc_manager_name) VALUES 
('CC001', 'Administration', 'Alexa Kitson'),
('CC002', 'Cleaning', 'Leonid Barlace'),
('CC003', 'Dietary and Cafeteria', 'Belinda Domnick'),
('CC004', 'Ancillary Supplies', 'Delia Le Brun'),
('CC005', 'Operating Theatre', 'Leigh Lenox'),
('CC006', 'Anaesthesiology', 'Bette McLleese'),
('CC007', 'Labor and Delivery', 'Shay Upton'),
('CC008', 'Radiology', 'Glenine Eymor'),
('CC009', 'Laboratory Supplies', 'Francyne Ordidge'),
('CC010', 'Inhalation Therapy', 'Fletch Carriage'),
('CC011', 'Physical Therapy', 'Talya Townsley'),
('CC012', 'Pharmacy', 'Aurelie Clemensen');


-- Inserting sample data into item

INSERT INTO item (item_code, item_description, item_stock, item_cost, cc_code) VALUES
('NE001', 'Needle Spinal 22g X 5" Becton Dickinson', 20, 3.45, 'CC004'),
('CA002', 'Catheter i.V. Optiva 22g X 25mm', 50, 2.25, 'CC004'),
('OV001', 'Interlink Vial Access Cannula', 30, 4.28, 'CC004'),
('TE001', 'Tube Extension Terumo 75cm', 50, 1.72, 'CC004'),
('AN002', 'Std Anaesthetic Pack', 25, 182.33, 'CC004'),
('SS006', 'Stainless Steel Pins', 100, 15.1, 'CC004'),
('KN056', 'Right Knee Brace', 10, 123, 'CC004'),
('PS318', 'Pump Suction Askir Liner Disp for cam31843', 100, 4.76, 'CC009'),
('ST252', 'Sigmoidoscope Tube Heine Disposable 25s 250x20mm', 100, 0.72, 'CC009'),
('AT258', 'Anoscope Tubes Heine Disposable 25s 85x20mm', 50, 1.14, 'CC009'),
('TN010', 'Thermometer Nextemp Disposable', 500, 0.45, 'CC009'),
('LB250', 'Laryngoscope Blade Heine Mcintosh F/Opt', 50, 215.1, 'CC009'),
('CE001', 'Chloromycetin Eye Ointment 4g', 20, 3.98, 'CC012'),
('EA030', 'Epipen Adult 0.30mg. Adrenalin', 20, 110.15, 'CC012'),
('CE010', 'Chlorsig Eye Oint. 1%', 25, 3.98, 'CC012'),
('EA030','Epipen Adult 0.30mg. Adrenalin',20,110.15,'CC012'),
('CE010','Chlorsig Eye Oint. 1%',25,3.98,'CC012'),
('AP050','Amethocaine 0.5% 20s Prev Tetracaine 0.5%',25,81.2,'CC012'),
('BI500','Bupivacaine Inj .5% 10ml Steriamp',10,365.48,'CC012'),
('CF050','Cophenylcaine Forte Nasal Spray 50ml',10,62.04,'CC012');
