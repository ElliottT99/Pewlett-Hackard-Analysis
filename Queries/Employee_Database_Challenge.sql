--Deliverable 1

--Creating a table for employees sorted by titles
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
--INTO retirement_titles
FROM employees AS e
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

--Retrieving counts of retirees based on titles
SELECT COUNT(title), title
--INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;

--Deliverable 2

--Creating table for retirees eligibile for mentorship
SELECT DISTINCT ON (e.emp_no)
	e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
--INTO mentorship_eligibilty
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no=de.emp_no)
INNER JOIN titles as t
ON (e.emp_no=t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no, t.title;

--Deliverable 3 (Additional Queries Used)

--total current retires (addon from Deliverable 1 refactored)
SELECT SUM(count) FROM current_retiring_titles;
--Retrieving counts of retirees based on mentorship eligibilty
SELECT COUNT(title), title
--INTO mentorship_eligibilty_counts
FROM mentorship_eligibilty
GROUP BY title
ORDER BY COUNT(title) DESC;

--compares empty positions that will need filling vs available mentors
SELECT crt.title,
	crt.total_retiring,
	mec.total_mentors,
	(crt.total_retiring/mec.total_mentors) AS "Positions to fill per Available Mentor"
--INTO retires_vs_mentors
FROM current_retiring_titles AS crt
INNER JOIN mentorship_eligibilty_counts AS mec
ON (crt.title=mec.title)
GROUP BY crt.title, crt.total_retiring, mec.total_mentors;

--Retrieving counts of retirees based on mentorship eligibilty
SELECT COUNT(title) AS "total_mentors", title
--INTO mentorship_eligibilty_counts
FROM mentorship_eligibilty
GROUP BY title
ORDER BY COUNT(title) DESC;

--Deliverable 1 refactored

--Creating a table for employees sorted by titles
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	t.title,
	t.from_date,
	t.to_date
--INTO current_retirement_titles
FROM current_emp AS ce
INNER JOIN titles as t
ON (ce.emp_no = t.emp_no)
INNER JOIN employees as e
ON (ce.emp_no = e.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (t.to_date = '9999-01-01')
ORDER BY e.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
--INTO current_unique_titles
FROM current_retirement_titles
ORDER BY emp_no, to_date DESC;

--Retrieving counts of retirees based on titles
SELECT COUNT(title) AS "total_retiring", title
--INTO current_retiring_titles
FROM current_unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;