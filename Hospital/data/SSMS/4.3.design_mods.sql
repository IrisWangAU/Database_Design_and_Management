
/* SQLINES DEMO *** ents*/

ALTER TABLE doctor ADD
    (admission_num SMALLINT DEFAULT 0 NOT NULL);

EXECUTE sp_addextendedproperty 'MS_Description',
    'Number of admissions the doctor supervises', 'user', user_name(), 'table', doctor, 'column', admission_num;

UPDATE doctor 
SET admission_num = (SELECT COUNT(*)
                     FROM admission
                     WHERE admission.doctor_id = doctor.doctor_id);

COMMIT;

-- SQLINES LICENSE FOR EVALUATION USE ONLY
SELECT * FROM doctor;
  
/* SQLINES DEMO *** on Feedback*/

-- SQLINES DEMO *** into admission table for daily bed charge
ALTER TABLE admission ADD
(daily_bed_charge SMALLINT DEFAULT 321 NOT NULL);

EXECUTE sp_addextendedproperty 'MS_Description',
    'daily bed charge rate for the admission', 'user', user_name(), 'table', admission, 'column', daily_bed_charge;


-- SQLINES DEMO *** tion of invoice
DROP TABLE invoice CASCADE CONSTRAINTS;

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE TABLE invoice (
    inv_no          INT     NOT NULL,
    adm_no          INT     NOT NULL,
    total_adm_cost  DECIMAL(6,2)     NOT NULL,
    total_bed_cost  DECIMAL(6,2)     NOT NULL,
    paid            VARCHAR(3)      DEFAULT 'NO'
);

EXECUTE sp_addextendedproperty 'MS_Description',
    'Invoice number (PK)', 'user', user_name(), 'table', invoice, 'column', inv_no;
EXECUTE sp_addextendedproperty 'MS_Description',
    'Admission number (PK)', 'user', user_name(), 'table', invoice, 'column', adm_no;
EXECUTE sp_addextendedproperty 'MS_Description',
    'Total procedure costs for the admission (including patient procedure and item costs', 'user', user_name(), 'table', invoice, 'column', total_adm_cost;
EXECUTE sp_addextendedproperty 'MS_Description',
    'Total hospital bed coosts for the admission', 'user', user_name(), 'table', invoice, 'column', total_bed_cost;
EXECUTE sp_addextendedproperty 'MS_Description',
    'An indictor to show if the invoice has been paid', 'user', user_name(), 'table', invoice, 'column', paid;

ALTER TABLE invoice ADD CONSTRAINT invoice_pk PRIMARY KEY ( inv_no );

ALTER TABLE invoice ADD CONSTRAINT invoice_nk UNIQUE ( adm_no );

ALTER TABLE invoice 
    ADD CONSTRAINT invoice_admission FOREIGN KEY ( adm_no )
        REFERENCES admission ( adm_no );

ALTER TABLE invoice ADD CONSTRAINT invoice_check 
    CHECK (paid IN ('YES', 'NO'));

-- SQLINES DEMO ***  for invoice number
DROP SEQUENCE inv_no_seq;
CREATE SEQUENCE inv_no_seq START WITH 100 INCREMENT BY 1;

-- SQLINES DEMO *** voice data
-- SQLINES LICENSE FOR EVALUATION USE ONLY
INSERT INTO invoice (inv_no, adm_no, total_adm_cost, total_bed_cost)
SELECT
    inv_no_seq.NEXTVAL,
    adm_no,
    total_adm_prc_cost,
    total_bed_cost
FROM
    (SELECT DISTINCT
        a.adm_no AS adm_no,
        (SELECT SUM(adprc_pat_cost + adprc_items_cost)
         FROM adm_prc ad1
         WHERE ad1.adm_no = a.adm_no) AS total_adm_prc_cost,
        (SELECT daily_bed_charge * round(adm_discharge - adm_date_time, 0)
         FROM admission a1
         WHERE a1.adm_no = a.adm_no) AS total_bed_cost
     FROM
        admission a
        JOIN adm_prc ap
        ON a.adm_no = ap.adm_no
     WHERE
        a.adm_discharge IS NOT NULL
     ORDER BY
        adm_no) s;

COMMIT;

-- SQLINES DEMO *** paid invoice    
UPDATE invoice
SET paid = 'YES'
WHERE inv_no IN (100,103,105,106,107,110,115,116,117,120,121,122,125);

COMMIT;

-- SQLINES DEMO *** n and invoice details
-- SQLINES LICENSE FOR EVALUATION USE ONLY
SELECT * FROM admission;
-- SQLINES LICENSE FOR EVALUATION USE ONLY
SELECT * FROM invoice;


















