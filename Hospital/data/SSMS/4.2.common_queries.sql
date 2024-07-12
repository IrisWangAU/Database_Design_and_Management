

/* (i) */

-- SQLINES LICENSE FOR EVALUATION USE ONLY
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

-- SQLINES LICENSE FOR EVALUATION USE ONLY
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

-- SQLINES LICENSE FOR EVALUATION USE ONLY
SELECT 
    p.patient_id AS Patient_ID,
    isnull(p.patient_fname, '') +' '+ isnull(p.patient_lname, '') AS Patient_Name,
    TO_CHAR(a.adm_date_time, 'DD-Mon-YYYY HH24:MI') AS Admission_DateTime,
    isnull(d.doctor_title, '') +' '+ isnull(d.doctor_fname, '') +' '+ isnull(d.doctor_lname, '') AS Doctor_Name
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

-- SQLINES LICENSE FOR EVALUATION USE ONLY
SELECT 
    proc_code AS "procedure code", 
    proc_name AS "procedure name", 
    proc_description AS "description",
    LPAD(FORMAT(proc_std_cost, 'N2'),13,' ') AS "standard cost"
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

-- SQLINES LICENSE FOR EVALUATION USE ONLY
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
    CONVERT(DATETIME, DOB) ASC;

    
/* (vi) */
-- SQLINES LICENSE FOR EVALUATION USE ONLY
SELECT 
    a.adm_no,
    a.patient_id,
    p.patient_fname,
    p.patient_lname,
    LPAD(ISNULL(FORMAT(FLOOR(a.adm_discharge - a.adm_date_time),'N0'), '') +' days '+ 
    ISNULL(FORMAT(((a.adm_discharge-a.adm_date_time)*24 %24),'N1'), '')+' hrs',20,' ')
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

-- SQLINES LICENSE FOR EVALUATION USE ONLY
SELECT DISTINCT
    a.proc_code,
    p.proc_name,
    p.proc_description,
    p.proc_time,
    LPAD(FORMAT(
            (SELECT AVG(adprc_pat_cost)
             FROM adm_prc a1
             WHERE a1.proc_code = a.proc_code)
             - proc_std_cost,
             'N2'),17) 
         AS price_differential
FROM
    adm_prc a
    JOIN procedure p
    ON a.proc_code = p.proc_code
ORDER BY
    proc_code;

    
/* (viii)*/

-- SQLINES LICENSE FOR EVALUATION USE ONLY
SELECT DISTINCT
    p.proc_code,
    p.proc_name,
    ISNULL(i.item_code,'---') AS item_code,
    ISNULL(i.item_description,'---') AS item_description,
    LPAD(ISNULL(CONVERT(VARCHAR, (SELECT MAX(it_qty_used)
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
    
