/* ITO4132 MO 2022 TP3 Assignment 2 Task 3 ANSWERS
   Student Name: Iris Wang
   Student ID: 33236364

   Comments to your marker:
   
*/
/* (i) Tracking patients*/

ALTER TABLE doctor ADD
    (admission_num NUMBER(4,0) DEFAULT 0 NOT NULL);

COMMENT ON COLUMN doctor.admission_num IS
    'Number of admissions the doctor supervises';

UPDATE doctor 
SET admission_num = (SELECT COUNT(*)
                     FROM admission
                     WHERE admission.doctor_id = doctor.doctor_id);

COMMIT;

SELECT * FROM doctor;
  
/* (ii) Administration Feedback*/

-- Add a new column into admission table for daily bed charge
ALTER TABLE admission ADD
(daily_bed_charge NUMBER(4,0) DEFAULT 321 NOT NULL);

COMMENT ON COLUMN admission.daily_bed_charge IS
    'daily bed charge rate for the admission';


-- Create a new relation of invoice
DROP TABLE invoice CASCADE CONSTRAINTS;

CREATE TABLE invoice (
    inv_no          NUMBER(6,0)     NOT NULL,
    adm_no          NUMBER(6,0)     NOT NULL,
    total_adm_cost  NUMBER(6,2)     NOT NULL,
    total_bed_cost  NUMBER(6,2)     NOT NULL,
    paid            VARCHAR(3)      DEFAULT 'NO'
);

COMMENT ON COLUMN invoice.inv_no IS
    'Invoice number (PK)';
COMMENT ON COLUMN invoice.adm_no IS
    'Admission number (PK)';
COMMENT ON COLUMN invoice.total_adm_cost IS
    'Total procedure costs for the admission (including patient procedure and item costs';
COMMENT ON COLUMN invoice.total_bed_cost IS
    'Total hospital bed coosts for the admission';
COMMENT ON COLUMN invoice.paid IS
    'An indictor to show if the invoice has been paid';

ALTER TABLE invoice ADD CONSTRAINT invoice_pk PRIMARY KEY ( inv_no );

ALTER TABLE invoice ADD CONSTRAINT invoice_nk UNIQUE ( adm_no );

ALTER TABLE invoice 
    ADD CONSTRAINT invoice_admission FOREIGN KEY ( adm_no )
        REFERENCES admission ( adm_no );

ALTER TABLE invoice ADD CONSTRAINT invoice_check 
    CHECK (paid IN ('YES', 'NO'));

-- Create a sequence for invoice number
DROP SEQUENCE inv_no_seq;
CREATE SEQUENCE inv_no_seq START WITH 100 INCREMENT BY 1;

-- Insert current invoice data
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
        (SELECT daily_bed_charge * round(adm_discharge - adm_date_time)
         FROM admission a1
         WHERE a1.adm_no = a.adm_no) AS total_bed_cost
     FROM
        admission a
        JOIN adm_prc ap
        ON a.adm_no = ap.adm_no
     WHERE
        a.adm_discharge IS NOT NULL
     ORDER BY
        adm_no);

COMMIT;

-- Update status of paid invoice    
UPDATE invoice
SET paid = 'YES'
WHERE inv_no IN (100,103,105,106,107,110,115,116,117,120,121,122,125);

COMMIT;

-- Show all admission and invoice details
SELECT * FROM admission;
SELECT * FROM invoice;


















