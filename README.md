<h1>TIP Career Center System</h1>

<h3>About</h3>
<p>This system is created for the Career Center of Technological Institute of the Philippines. Its core functionallity is to manage the company linkages for partner companies, and monitor their accomplished activities. The program is written in python using Django web framework.</p>

<h3>Developers</h3>
<p>This system is developed by the following collaborators:</p>
<ul>
  <li>Engr. Royce B. Chua</li>
  <li>Jose Paulo C. Cabral</li>
  <li>Tyrone Guevarra</li>
  <li>Joseph Guiyab</li>
  <li>Joshua Albert T. Lopez</li>
  <li>Jarod Augustus Austria</li>
  <li>Zeus James Baltazar</li>
</ul>

<h3>Program Requisites</h3>
<p>To ensure that the system works as intended, the following requisites are required in order to run the program.</p>
<ul>
  <li>Python Runtime Environment (Recommended: Python version 3.X)</li>
  <li>Django 2.1.4 (or latest)</li>
  <li>MySQLClient</li>
  <li>PyMySQL</li>
  <li>PyPDF2</li>
  <li>xhtml2pdf</li>
  <li>MySQL or XAMPP</li>
  <li>MySQL Workbench (optional)</li>
  <li>Git</li>
  <li>Web Browser</li>
  <li>Text Editor</li>
</ul>
  
<h3>System Migration</h3>
<p>These are the steps for migrating and running the system on another machine.</p>
<ol>
  <li>Install/pip install all requisites. (All requisities can be installed on a virtual environment. See "Program Requisities" above for the list of requirements)</li>
  <li>Connect to an instance of SQL Server using MySQL. (XAMPP or the official MySQL client can be used)</li>
  <li>Clone the repository on prefered location using git</li>
  <li>Create the database schema using the tip_career_center_system_updated.sql. The file can be executed using MySQL workbench. The database ERD can be viewed using MySQL Workbench by using the tip_career_center_system_db_erd</li>
  <li>Navigate to the folder location of mange.py file. Open CMD on this folder</li>
  <li>Run the script: "python manage.py migrate" (without quotation marks) to migrate required the Django entities on the database.</li>
  <li>Run the script: "python manage.py runserver" to run the program.</li>
  <li>On a web browser, enter "localhost:8000" (without quotation marks) on the address bar to go to the homepage.</li>
</ol>
