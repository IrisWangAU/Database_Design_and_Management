
/* SQLINES DEMO *** ces for patient id and admission number 
(both start at 200000 and increment by 10)
*/


DROP SEQUENCE patient_id_seq;
CREATE SEQUENCE patient_id_seq START WITH 200000 INCREMENT BY 10;

DROP SEQUENCE adm_no_seq;
CREATE SEQUENCE adm_no_seq START WITH 200000 INCREMENT BY 10;

/* SQLINES DEMO *** patient Peter Xiue into patient and admission table
*/

-- SQLINES LICENSE FOR EVALUATION USE ONLY
INSERT INTO patient VALUES(
    'Peter',
    'Xiue',
    '14 Narrow Lane, Caulfield VIC 3162',
    CONVERT(DATETIME, '1-Oct-1981'),
    '0123456789'
);

-- SQLINES LICENSE FOR EVALUATION USE ONLY
INSERT INTO admission VALUES(
    CONVERT(DATETIME, '1-Jun-2022 13:00', 'DD-Mon-YYYY HH24:MI'),
    NULL,
    patient_id_seq.CURRVAL,
    (SELECT doctor_id 
        FROM doctor 
        WHERE 
        doctor_title = 'Dr'
        AND lower(doctor_fname) = lower('Sawyer') 
        AND lower(doctor_lname) = lower('HAISELL'))
);

COMMIT;

/* SQLINES DEMO *** or specialisation
*/

UPDATE doctor_speciality
SET spec_code = 
    (SELECT spec_code 
     FROM speciality 
     WHERE lower(spec_description) = lower('Vascular surgery'))
WHERE doctor_id = 
      (SELECT doctor_id
       FROM doctor
       WHERE doctor_title = 'Dr'
        AND lower(doctor_fname) = lower('Decca')
        AND lower(doctor_lname) = lower('BLANKHORN'))
      AND spec_code = 
        (SELECT spec_code 
         FROM speciality 
         WHERE lower(spec_description) = lower('Thoracic surgery'));
COMMIT;

      
/* SQLINES DEMO *** cal genetics" specialisation 
and corresponding doctor specialisation records
*/

DELETE FROM doctor_speciality
WHERE spec_code = 
        (SELECT spec_code 
         FROM speciality 
         WHERE lower(spec_description) = lower('Medical genetics'));

DELETE FROM speciality
WHERE lower(spec_description) = lower('Medical genetics');

COMMIT;






