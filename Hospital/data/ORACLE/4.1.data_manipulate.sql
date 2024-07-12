/* ITO4132 MO 2022 TP3 Assignment 2 Task 1 Part B ANSWERS
   Student Name: Iris Wang
   Student ID: 33236364

   Comments to your marker:
   
*/

/* (i)
Create sequences for patient id and admission number 
(both start at 200000 and increment by 10)
*/


DROP SEQUENCE patient_id_seq;
CREATE SEQUENCE patient_id_seq START WITH 200000 INCREMENT BY 10;

DROP SEQUENCE adm_no_seq;
CREATE SEQUENCE adm_no_seq START WITH 200000 INCREMENT BY 10;

/* (ii) 
Insert new patient Peter Xiue into patient and admission table
*/

INSERT INTO patient VALUES(
    patient_id_seq.NEXTVAL,
    'Peter',
    'Xiue',
    '14 Narrow Lane, Caulfield VIC 3162',
    TO_DATE('1-Oct-1981', 'DD-Mon-YYYY'),
    '0123456789'
);

INSERT INTO admission VALUES(
    adm_no_seq.NEXTVAL,
    TO_DATE('1-Jun-2022 13:00', 'DD-Mon-YYYY HH24:MI'),
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

/* (iii)
Update doctor specialisation
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

      
/* (iv)
delete "Medical genetics" specialisation 
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






