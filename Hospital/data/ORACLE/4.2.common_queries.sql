/* ITO4132 MO 2022 TP3 Assignment 2 Task 2 ANSWERS
   Student Name: Iris Wang
   Student ID: 33236364

   Comments to your marker:
   
*/

/* (i) */

SELECT 
    d.doctor_title,
    d.doctor_fname,
    d.doctor_lname,
    d.doctor_phone
FROM 
    doctor_speciality s
    JOIN doctor d ON s.doctor_id = d.doctor_id
WHERE
    s.spec_code = 
        (SELECT spec_code 
        FROM speciality 
        WHERE lower(spec_description) = lower('ORTHOPEDIC SURGERY'))
ORDER BY 
    d.doctor_lname,
    d.doctor_fname;


/* (ii) */

SELECT
    i.item_code,
    i.item_description,
    i.item_stock,
    c.cc_title
FROM
    item i
    JOIN costcentre c
    ON i.cc_code = c.cc_code
WHERE
    i.item_stock > 50
    AND lower(i.item_description) LIKE '%disposable%'
ORDER BY i.item_code;

    
/* (iii) */

SELECT 
    p.patient_id AS Patient_ID,
    p.patient_fname ||' '|| p.patient_lname AS Patient_Name,
    TO_CHAR(a.adm_date_time, 'DD-Mon-YYYY HH24:MI') AS Admission_DateTime,
    d.doctor_title ||' '|| d.doctor_fname ||' '|| d.doctor_lname AS Doctor_Name
FROM
    admission a
    JOIN patient p
    ON a.patient_id = p.patient_id
    JOIN doctor d
    ON d.doctor_id = a.doctor_id
WHERE
    TO_CHAR (a.adm_date_time, 'DD-Mon-YYYY') = '01-Jun-2022'
ORDER BY 
    a.adm_date_time,
    p.patient_id;

/* (iv) */

SELECT 
    proc_code AS "procedure code", 
    proc_name AS "procedure name", 
    proc_description AS "description",
    LPAD(TO_CHAR(proc_std_cost, '$990.99'),13,' ') AS "standard cost"
FROM
    procedure
WHERE
    proc_std_cost < 
       (SELECT AVG(proc_std_cost)
        FROM procedure)
ORDER BY 
    proc_std_cost DESC,
    proc_code;

 
/* (v) */

SELECT
    a.patient_id,
    p.patient_lname,
    p.patient_fname,
    TO_CHAR(p.patient_dob,'DD-Mon-YYYY') AS DOB,
    COUNT(*) AS numberadmissions
FROM
    patient p
    JOIN admission a
    ON p.patient_id = a.patient_id
GROUP BY
    a.patient_id,
    p.patient_lname,
    p.patient_fname,
    TO_CHAR(p.patient_dob,'DD-Mon-YYYY')
HAVING
    COUNT(*) > 2
ORDER BY
    numberadmissions DESC,
    TO_DATE(DOB) ASC;

    
/* (vi) */
SELECT 
    a.adm_no,
    a.patient_id,
    p.patient_fname,
    p.patient_lname,
    LPAD(TO_CHAR(FLOOR(a.adm_discharge - a.adm_date_time),'99') ||' days '|| 
    TO_CHAR(MOD((a.adm_discharge-a.adm_date_time)*24,24),'90.9')||' hrs',20,' ')
    AS stay_length
FROM
    admission a
    JOIN patient p
    ON a.patient_id = p.patient_id
WHERE
    a.adm_discharge IS NOT NULL
    AND a.adm_discharge-a.adm_date_time > 
        (SELECT AVG(adm_discharge-adm_date_time)
         FROM admission
         WHERE adm_discharge IS NOT NULL);

    
/* (vii) */

SELECT DISTINCT
    a.proc_code,
    p.proc_name,
    p.proc_description,
    p.proc_time,
    LPAD(TO_CHAR(
            (SELECT AVG(adprc_pat_cost)
             FROM adm_prc a1
             WHERE a1.proc_code = a.proc_code)
             - proc_std_cost,
             '990.99'),17) 
         AS price_differential
FROM
    adm_prc a
    JOIN procedure p
    ON a.proc_code = p.proc_code
ORDER BY
    proc_code;

    
/* (viii)*/

SELECT DISTINCT
    p.proc_code,
    p.proc_name,
    NVL(i.item_code,'---') AS item_code,
    NVL(i.item_description,'---') AS item_description,
    LPAD(NVL(TO_CHAR((SELECT MAX(it_qty_used)
                      FROM item_treatment i1
                      WHERE i1.adprc_no = a.adprc_no)),'---'),12) 
    AS max_qty_used
FROM
    adm_prc a
    JOIN item_treatment it
    ON it.adprc_no = a.adprc_no
    JOIN item i
    ON i.item_code = it.item_code
    RIGHT JOIN procedure p
    ON a.proc_code = p.proc_code
ORDER BY
    proc_name,
    item_code;
    
