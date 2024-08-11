<div align="center">
  
  <div id="user-content-toc">
    <ul>
      <summary><h1 style="display: inline-block;"> Database Creation and Management</h1></summary>
    </ul>
  </div>
  
  <p>Create Database from scratch using Oracle SQL Developer and then manage with Microsoft SQL Manangement Studio (SSMS)</p>

  <a href="#">
    <img src="https://github.com/IrisWangAU/Database_SQL/blob/main/Hospital/assets/LogicalModel.PNG">
  </a>

  
</div>
<br>

## 📝 Table of Contents
1. [Introduction](#introduction)
2. [Key Entities and Relationships](#relationship)
3. [Database Design and Schema Creation](#db-create)  
  3.1. [Logical Model](#logical-model)  
  3.2. [Database Creation in SSMS](#ssms-db)  
4. [Database Management](#db-manage)
  4.1. [Data Manipulation](#db-manipulation)  
  4.2. [Common SQL queries](#db-queries) 
  4.3. [Design Modification](#db-mod) 
5. [Technology used](#technology)
6. [Contact](#contact)


<a name="introduction"></a>
## Project Introduction

This project is designed to develop a comprehensive and efficient database system to manage the diverse and extensive data needs of the Hospital. The primary goal is to create a robust database infrastructure that facilitates the storage, retrieval, and management of crucial hospital data, including patient information, medical procedures, doctor specializations, cost centers, and medical items. The conceptual and logical models are built using Oracle SQL Developer, and the corresponding schema is tranformed to be used by Microsoft SQL Management Studio for Database Creation and further Database Management.

By implementing this database, Monash Hospital aims to enhance its data management capabilities, streamline operations, improve data accessibility, and ensure data integrity and security.

<br>

<a name="#relationship"></a>
## Key Entities and Relationships

The Monash Hospital database will include several key entities, each representing a critical aspect of hospital operations:

- **Patients**: Storing patient information such as ID, name, address, date of birth, and contact details.
- **Doctors**: Managing doctor details, including ID, name, contact information, and specializations.
- **Medical Procedures**: Recording information about various medical procedures, their descriptions, durations, and costs.
- **Cost Centers**: Managing cost centers within the hospital, including codes, titles, and manager details.
- **Medical Items**: Tracking medical items, their descriptions, stock levels, costs, and associated cost centers.

Relationships between these entities will be established through foreign key constraints, ensuring data integrity and consistency. For example, each admission will be linked to a patient and a doctor, and each medical procedure will be associated with specific doctors and cost centers.

<br>

<a name="db-create"></a>
## Database Design and Schema Creation

<a name="db-create"></a>
### Logical Model
- Defining the database schema, including tables, columns, data types, and constraints to accurately represent the hospital's data requirements using the following logical model:

![logical_model](https://github.com/IrisWangAU/Database_SQL/blob/main/Hospital/assets/LogicalModel.PNG)

<br>

<a name="ssms-db"></a>
### Database Creation in SSMS
- Creating tables for various entities such as patients, doctors, medical procedures, cost centers, and medical items.
- Establishing relationships and constraints between tables to ensure data integrity and enforce business rules.
- Populating the database with initial sample data to validate the schema and demonstrate the system's capabilities.
- Providing comprehensive documentation, including the database schema, data dictionary, and user guides to support database management and usage.

> The following snaps are samples. Please refer to SQL files in Hospital directory for complete script.

![createT](https://github.com/IrisWangAU/Database_SQL/blob/main/Hospital/assets/createT.PNG)
![Relationships](https://github.com/IrisWangAU/Database_SQL/blob/main/Hospital/assets/relationship.PNG)
![datainsert](https://github.com/IrisWangAU/Database_SQL/blob/main/Hospital/assets/datainsert.PNG)

<br>

<a name="db-manage"></a>
## Database Management

<br>

<a name="db-manipulation"></a>
### Data Manipulation
- Insert Entries: Populate the Monash Hospital database with 10 patients, 15 admissions, 20 admission procudures and 15 item treatments.
- Perform data manipulation tasks using DML statements:
  1. Create sequences starting at 200000, incrementing by 10 for PATIENT, ADMISSION, and ADM_PRC tables.
  2. Add a new patient, Peter Xiue, with specified details and a supervising doctor, Dr. Sawyer HAISELL.
  3. Change Dr. Decca BLANKHORN's specialization from "Thoracic surgery" to "Vascular surgery".
  4. Remove the "Medical genetics" specialization from the database without altering the schema.

<br>

<a name="db-queries"></a>
### Common SQL queries
Execute a series of SQL queries to extract and manipulate data from the Monash Hospital database.
- List doctors specializing in "ORTHOPEDIC SURGERY".
- List items with stock > 50 and description containing 'disposable'.
- List patient admissions on June 1, 2022, include patient and doctor names.
- List procedures with standard cost less than average.
- List patients with more than 2 admissions.
- List admissions with length of stay longer than average.
- List procedure price differentials.
- List items used for each procedure and maximum quantity.

<br>

<a name="#db-mod"></a>
### Design Modifications
Modify the database design to accommodate new requirements.
- Add a column to track the number of patients supervised by each doctor, starting from zero.
- Initialize the column based on current admissions data.
- Add a daily bed charge to admissions with a default value of $321.
- Create an invoice system for completed admissions, including:
  - Invoice number (starting at 100).
  - Total admission procedure costs.
  - Total bed costs (full day rate for part days).
  - Payment status indicator (Yes/No).


<br>

<a name="technology"></a>
## 🛠️ Technology Used
- Conceptual and Logical Model: Orcale SQL developer
- Database Creation: Microsoft SQL Server and Microsoft SQL Management Studio (SSMS)
- Database Management: SSMS

<br>

<a name="contact"></a>

## 📨 Contact Me

[LinkedIn](https://www.linkedin.com/in/iriswangau/) •
[Gmail](iriswang.mel@gmail.com)


