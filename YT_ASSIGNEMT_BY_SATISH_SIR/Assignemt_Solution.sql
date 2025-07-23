-- Hospital Name	Location	Department	Doctors Count
-- Patients Count	Admission Date	Discharge Date	Medical Expenses

CREATE TABLE hospital_data (
    hospital_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    department VARCHAR(100),
    doctors_count INTEGER,
    patients_count INTEGER,
    admission_date DATE,
    discharge_date DATE,
    medical_expenses DECIMAL(10, 2)
);

COPY hospital_data(Hospital_Name, Location, Department,	
Doctors_Count,	Patients_Count,	Admission_Date,	Discharge_Date,	Medical_Expenses
)
FROM 'E:\Computer Programming\Data_Analysis_Project\YT_ASSIGNEMT_BY_SATISH_SIR\Hospital_Data.csv'
CSV HEADER;

SELECT * FROM hospital_data;

-- SINCE OVER DATA SET IS NOW SET UP LET'S MOVE NO TO THE NEXT STEP

-- QUERY 1 -> Write an SQL query to find the total number of patients across all hospitals.
SELECT SUM(patients_count) AS total_patients FROM hospital_data;

SELECT hospital_name , SUM(patients_count) AS total_patients FROM hospital_data
GROUP BY hospital_name;

-- QUERY 2 -> Retrieve the average count of doctors available in each hospital.
SELECT hospital_name , ROUND(AVG(doctors_count),0) AS Avg_doctor_available
FROM hospital_data
GROUP BY hospital_name ORDER BY Avg_doctor_available DESC;

-- QUERY 3 -> Find the top 3 hospital departments that have the highest number of patients.

SELECT  department , SUM(patients_count) as total_patients
FROM hospital_data 
GROUP BY department ORDER BY total_patients DESC LIMIT 3;

SELECT hospital_name , department , SUM(patients_count) as total_patients
FROM hospital_data 
GROUP BY hospital_name, department ORDER BY total_patients DESC LIMIT 3;

-- QUERY 4 -> Identify the hospital that recorded the highest medical expenses.
SELECT hospital_name , SUM(medical_expenses) as total_expenses
	FROM hospital_data GROUP BY hospital_name
	ORDER BY total_expenses DESC LIMIT 1;



SELECT hospital_name ,
	SUM(medical_expenses) AS total_medical_expenses,
	COUNT(*) AS record_count ,
	ROUND(SUM(medical_expenses) / SUM(patients_count), 2) AS cost_per_patient
	FROM hospital_data
	GROUP BY hospital_name
	ORDER BY total_medical_expenses DESC LIMIT 1;

-- QUERY 5 -> Calculate the average medical expenses per day for each hospital.

SELECT hospital_name , 
ROUND(SUM(medical_expenses) / NULLIF(
SUM(( discharge_date - admission_date)+1),0),2)
AS avg_expenses_per_day
FROM hospital_data
WHERE admission_date IS NOT NULL
AND discharge_date IS NOT NULL
AND discharge_date >= admission_date
GROUP BY hospital_name
ORDER BY avg_expenses_per_day DESC;

/* QUERY 6 -> Find the patient with the longest stay by calculating the difference
between Discharge Date and Admission Date. */

SELECT hospital_name ,
department , admission_date , discharge_date,
(discharge_date - admission_date) as stay_durtaion_days,
medical_expenses
FROM hospital_data
WHERE admission_date IS NOT NULL
AND discharge_date IS NOT NULL
AND discharge_date >= admission_date
ORDER BY stay_durtaion_days DESC LIMIT 1;



-- QUERY 7 -> Count the total number of patients treated in each city.

SELECT location , SUM(patients_count) AS total_patients_treated
FROM hospital_data
GROUP BY location ORDER BY total_patients_treated DESC;

-- QUERY 8 -> Calculate the average number of days patients spend in each department.

SELECT department,
ROUND(AVG(discharge_date - admission_date),1) AS avg_days_spend,
COUNT(*) AS patient_count,
MIN(discharge_date - admission_date) AS min_stay_days,
MAX(discharge_date - admission_date) AS max_stay_days
FROM hospital_data 
WHERE admission_date IS NOT NULL
AND discharge_date IS NOT NULL
AND discharge_date >= admission_date
GROUP BY department
ORDER BY avg_days_spend DESC;


-- QUERY 9 -> Find the department with the least number of patients.


SELECT department , SUM(patients_count) as total_patients
FROM hospital_data
GROUP BY department
ORDER BY total_patients LIMIT 1;


-- QUERY 10 -> Group the data by month and calculate the total medical expenses for each month.

SELECT 
DATE_TRUNC('month' , admission_date) as month,
TO_CHAR(DATE_TRUNC('month', admission_date),'YYYY-MM') AS month_name,
SUM(medical_expenses) AS total_expenses,
COUNT(*) AS admission_count,
ROUND(SUM(medical_expenses)/ COUNT(*),2) AS avg_expense_per_admission
FROM hospital_data
WHERE admission_date IS NOT NULL
AND medical_expenses IS NOT NULL
GROUP BY
DATE_TRUNC('month', admission_date)
ORDER BY month ASC;