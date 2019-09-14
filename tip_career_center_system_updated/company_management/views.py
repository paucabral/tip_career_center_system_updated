from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.views import View
from django.db import connection

# Create your views here.
def dictfetchall(cursor): 
    "Returns all rows from a cursor as a dict" 
    desc = cursor.description 
    return [
            dict(zip([col[0] for col in desc], row)) 
            for row in cursor.fetchall() 
    ]

class Administrator(View):
    def get(self, request, *args, **kwargs):
        return render(request,template_name='company_management/administrator.html',context={})

class AddCompanyAsAdmin(View):#Made some changes here. ##contactperson --> contact_person
    def get(self, request, *args, **kwargs):
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM industry_type")
            industry = dictfetchall(cursor)
        return render(request,template_name='company_management/add_company_AsAdmin.html',context={"industry_type":industry})
    def post(self, request, *args, **kwargs):
        print("POST Function reached")
        # Company
        company_name = request.POST["company_name"]
        company_address = request.POST["company_address"]
        Industry_Type_industry_type_id = request.POST["Industry_Type_industry_type_id"]
        print(company_name)
        print(Industry_Type_industry_type_id)
        # Contact Person
        contactperson_fname = request.POST["contactperson_fname"]
        contactperson_lname = request.POST["contactperson_lname"]
        contactperson_position = request.POST["contactperson_position"]
        contactperson_email = request.POST["contactperson_email"]
        contactperson_number = request.POST["contactperson_number"]

        seccontactperson_fname = request.POST["2contactperson_fname"]
        seccontactperson_lname = request.POST["2contactperson_lname"]
        seccontactperson_position = request.POST["2contactperson_position"]
        seccontactperson_email = request.POST["2contactperson_email"]
        seccontactperson_number = request.POST["2contactperson_number"]
        with connection.cursor() as cursor:
            cursor.execute("INSERT INTO company(company_name,company_address,company_engagement_score,Industry_Type_industry_type_id) VALUES ('{}','{}',0,'{}')".format(company_name,company_address,Industry_Type_industry_type_id))
            print("Company inserted")

            cursor.execute("SELECT company_id FROM company ORDER BY company_id DESC LIMIT 1")#Moved this here so I get company_id. Needed it in inserting the contact persons...
            compny_id=cursor.fetchone()[0]
            print("COMPANY ID IS HERE")
            print(compny_id)

            cursor.execute("INSERT INTO company_has_activity VALUES({},1,0), ({},2,0), ({},3,0), ({},4,0), ({},5,0), ({},6,0), ({},7,0)".format(compny_id,compny_id,compny_id,compny_id,compny_id,compny_id,compny_id))

            cursor.execute("INSERT INTO contact_person(contact_person_fname,contact_person_lname,contact_person_position,contact_person_email,contact_person_no,contact_person_priority,Company_company_id) VALUES ('{}','{}','{}','{}','{}','PRIMARY','{}')".format(contactperson_fname,contactperson_lname,contactperson_position,contactperson_email,contactperson_number,compny_id))
            print("contact 1 inserted")
            cursor.execute("INSERT INTO contact_person(contact_person_fname,contact_person_lname,contact_person_position,contact_person_email,contact_person_no,contact_person_priority,Company_company_id) VALUES ('{}','{}','{}','{}','{}','SECONDARY','{}')".format(seccontactperson_fname,seccontactperson_lname,seccontactperson_position,seccontactperson_email,seccontactperson_number,compny_id))
            print("contact 2 inserted")
 #           connection.commit()

#company_has_contact_person is removed in our new database.
#            cursor.execute("SELECT contact_person_id FROM contact_person WHERE contact_person_priority='PRIMARY' ORDER BY contact_person_id DESC LIMIT 1")
#            contact_id=cursor.fetchone()[0]

#            cursor.execute("SELECT contact_person_id FROM contact_person WHERE contact_person_priority='SECONDARY' ORDER BY contact_person_id DESC LIMIT 1")
#            contact_id2=cursor.fetchone()[0]

#            cursor.execute("INSERT INTO company_has_contact_person VALUES('{}','{}')".format(compny_id,contact_id))
#            cursor.execute("INSERT INTO company_has_contact_person VALUES('{}','{}')".format(compny_id,contact_id2))

            connection.commit()
            print("VALUES INSERTED")
        return redirect('/company-management/administrator/manage-companies/')

class EditCompanyAsAdmin(View):
    def get(self, request, *args, **kwargs):
        print(self.kwargs['company_id'])
        company_id = self.kwargs['company_id']
        
        with connection.cursor() as cursor:
            cursor.execute("SELECT contact_person_id FROM contact_person WHERE (Company_company_id='{}' AND contact_person_priority='PRIMARY') ORDER BY contact_person_id DESC LIMIT 1".format(company_id))
            contact_id=cursor.fetchone()[0]

            cursor.execute("SELECT contact_person_id FROM contact_person WHERE (Company_company_id='{}' AND contact_person_priority='SECONDARY') ORDER BY contact_person_id DESC LIMIT 1".format(company_id))
            contact_id2=cursor.fetchone()[0]

            print('contact ID is here!')
            print(contact_id)

        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM company WHERE company_id={}".format(company_id))
            result1=dictfetchall(cursor)[0]
            cursor.execute("SELECT * FROM contact_person WHERE contact_person_id={}".format(contact_id))
            result2=dictfetchall(cursor)[0]
            cursor.execute("SELECT * FROM contact_person WHERE contact_person_id={}".format(contact_id2))
            result3=dictfetchall(cursor)[0]
            cursor.execute("SELECT * FROM industry_type")
            industry = dictfetchall(cursor)
            print(result1)
        return render(request,template_name='company_management/edit_company_AsAdmin.html',context={"company":result1,"contact_person":result2,"2contact_person":result3,"industry_type":industry})
    def post(self, request, *args, **kwargs):
        print("POST Function reached")
        company_id = self.kwargs['company_id']
        company_name = request.POST["company_name"]
        company_address = request.POST["company_address"]
        Industry_Type_industry_type_id = request.POST["Industry_Type_industry_type_id"]
        print(company_name)
        # Contact Person
        contactperson_fname = request.POST["contactperson_fname"]
        contactperson_lname = request.POST["contactperson_lname"]
        contactperson_position = request.POST["contactperson_position"]
        contactperson_email = request.POST["contactperson_email"]
        contactperson_number = request.POST["contactperson_number"]

        seccontactperson_fname = request.POST["2contactperson_fname"]
        seccontactperson_lname = request.POST["2contactperson_lname"]
        seccontactperson_position = request.POST["2contactperson_position"]
        seccontactperson_email = request.POST["2contactperson_email"]
        seccontactperson_number = request.POST["2contactperson_number"]
        print(company_name)

        with connection.cursor() as cursor:
            cursor.execute("SELECT contact_person_id FROM contact_person WHERE (Company_company_id='{}' AND contact_person_priority='PRIMARY') ORDER BY contact_person_id DESC LIMIT 1".format(company_id))
            contact_id=cursor.fetchone()[0]

            cursor.execute("SELECT contact_person_id FROM contact_person WHERE (Company_company_id='{}' AND contact_person_priority='SECONDARY') ORDER BY contact_person_id DESC LIMIT 1".format(company_id))
            contact_id2=cursor.fetchone()[0]

            print('contact ID is here!')
            print(contact_id2)
        
        with connection.cursor() as cursor:
            cursor.execute("UPDATE company SET company_name='{}',company_address='{}', Industry_Type_industry_type_id='{}' WHERE company_id={}".format(company_name,company_address,Industry_Type_industry_type_id,company_id))
            cursor.execute("UPDATE contact_person SET contact_person_fname='{}',contact_person_lname='{}',contact_person_position='{}',contact_person_email='{}',contact_person_no='{}' WHERE contact_person_id='{}' AND contact_person_priority='PRIMARY'".format(contactperson_fname,contactperson_lname,contactperson_position,contactperson_email,contactperson_number,contact_id))
            cursor.execute("UPDATE contact_person SET contact_person_fname='{}',contact_person_lname='{}',contact_person_position='{}',contact_person_email='{}',contact_person_no='{}' WHERE contact_person_id='{}' AND contact_person_priority='SECONDARY'".format(seccontactperson_fname,seccontactperson_lname,seccontactperson_position,seccontactperson_email,seccontactperson_number,contact_id2))
            
            connection.commit()
            print("VALUES INSERTED")
        return redirect('/company-management/administrator/manage-companies')

class ManageCompaniesAsAdmin(View):
    def post(self, request, *args, **kwargs):

        # companies=cursor.fetchall()

        # for i in companies:
        #     print(i[0])
        #     print("First")

        company_id = request.POST["company_id"]
        with connection.cursor() as cursor:
            cursor.execute("DELETE FROM contact_person WHERE Company_company_id='{}'".format(company_id))
            
            cursor.execute("DELETE FROM company_has_activity WHERE Company_company_id='{}'".format(company_id))
            cursor.execute("DELETE FROM intership WHERE Company_company_id='{}'".format(company_id))
            cursor.execute("DELETE FROM externship WHERE Company_company_id='{}'".format(company_id))
            cursor.execute("DELETE FROM scholarship WHERE Company_company_id='{}'".format(company_id))
            cursor.execute("DELETE FROM on_campus_recruitment WHERE Company_company_id='{}'".format(company_id))
            cursor.execute("DELETE FROM career_development_training WHERE Company_company_id='{}'".format(company_id))
            cursor.execute("DELETE FROM career_fair WHERE Company_company_id='{}'".format(company_id))
            cursor.execute("DELETE FROM mock_job_interview WHERE Company_company_id='{}'".format(company_id))

            cursor.execute("DELETE FROM company WHERE company_id='{}'".format(company_id))
            
        #         cursor.execute("DELETE FROM company WHERE company_id='{}'".format(cmlen[i]))
        #     cmlen={}
        #     j=0

        # for i in companies:
        #     print(i['company_id'])
        #     cmlen[j]=i['company_id']
        #     j+=1

        #     cmcom=[]

        # for i in cmlen:
        #     print(cmlen[i])
        #     with connection.cursor() as cursor:
        #         cursor.execute("DELETE FROM contact_person WHERE Company_company_id='{}'".format(cmlen[i]))
        #         cursor.execute("DELETE FROM company WHERE company_id='{}'".format(cmlen[i]))
        #         break

            result = dictfetchall(cursor)
        print(result)
        return redirect('/company-management/administrator/manage-companies')
    def get(self, request, *args, **kwargs):
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM company")
            result = dictfetchall(cursor)
        #     for i in result:
        #         print(i['company_id'])
        #         print("First")
        # print(result[0]['company_id'])
        return render(request,template_name='company_management/manage_companies_AsAdmin.html',context={'companies':result})

class ViewCompanyAsAdmin(View):
    def get(self, request, *args, **kwargs):
        print(self.kwargs['company_id'])
        company_id = self.kwargs['company_id']
        

        with connection.cursor() as cursor:
            cursor.execute("SELECT contact_person_id FROM contact_person WHERE (Company_company_id='{}' AND contact_person_priority='PRIMARY') ORDER BY contact_person_id DESC LIMIT 1".format(company_id))
            contact_id=cursor.fetchone()[0]

            cursor.execute("SELECT contact_person_id FROM contact_person WHERE (Company_company_id='{}' AND contact_person_priority='SECONDARY') ORDER BY contact_person_id DESC LIMIT 1".format(company_id))
            contact_id2=cursor.fetchone()[0]

            print('contact ID is here!')
            print(contact_id)

        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM company WHERE company_id={}".format(company_id))
            result1=dictfetchall(cursor)[0]
            cursor.execute("SELECT * FROM contact_person WHERE contact_person_id={}".format(contact_id))
            result2=dictfetchall(cursor)[0]
            cursor.execute("SELECT * FROM contact_person WHERE contact_person_id={}".format(contact_id2))
            result3=dictfetchall(cursor)[0]
            print(result1)
            cursor.execute("SELECT * FROM company_has_activity WHERE Company_company_id={}".format(company_id))
            actResults=dictfetchall(cursor)
            print(actResults)

            cursor.execute("SELECT*FROM activity")
            activities=dictfetchall(cursor)
            print(activities[0])
        return render(request,template_name='company_management/company_profile_AsAdmin.html',context={"company":result1,"contact_person":result2,"2contact_person":result3, "companyActs":actResults, "activities":activities})
    def post(self, request, *args, **kwargs):
        company_id = self.kwargs['company_id']
        activity_id = request.POST['activity_id']

        print("Activity ID: ",activity_id)

        #INTERNSHIP
        internship_student_name = request.POST['internship_student_name']
        internship_program = request.POST['internship_program']
        internship_course = request.POST['internship_course']
        internship_school_year = request.POST['internship_school_year']
        internship_semester = request.POST['internship_semester']
        
        #EXTERNSHIP
        externship_student_name = request.POST['externship_student_name']
        externship_program = request.POST['externship_program']
        externship_course = request.POST['externship_course']
        externship_school_year = request.POST['externship_school_year']
        externship_semester = request.POST['externship_semester']

        #SCHOLARSHIP
        scholarship_student_name = request.POST['scholarship_student_name']
        scholarship_program = request.POST['scholarship_program']
        scholarship_course = request.POST['scholarship_course']
        scholarship_school_year = request.POST['scholarship_school_year']
        scholarship_semester = request.POST['scholarship_semester']
        scholarship_amount = request.POST['scholarship_amount']

        #CAREER FAIR
        career_fair_title = request.POST['career_fair_title']
        career_fair_date = request.POST['career_fair_date']
        career_fair_participants = request.POST['career_fair_participants']

        #ON-CAMPUS RECRUITMENT
        on_campus_recruitment_name = request.POST['on_campus_recruitment_name']
        on_campus_recruitment_date = request.POST['on_campus_recruitment_date']
        on_campus_recruitment_participants = request.POST['on_campus_recruitment_participants']

        #CAREER DEVELOPMENT TRAINING
        career_development_training_name = request.POST['career_development_name']
        career_development_training_date = request.POST['career_development_date']
        career_development_training_participants = request.POST['career_development_participants']

        #MOCK JOB INTERVIEW
        mock_job_interview_date = request.POST['mock_job_interview_date']
        mock_job_interview_participants = request.POST['mock_job_interview_participants']

        with connection.cursor() as cursor:
            quantity=0
            if activity_id=='1':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=1".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(5)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=1".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO intership(internship_student_name,intership_program,intership_course,intership_school_year,internship_semester,Company_company_id,internship_date_added) VALUES('{}','{}','{}','{}','{}','{}',CURRENT_TIMESTAMP)".format(internship_student_name,internship_program,internship_course,internship_school_year,internship_semester,company_id))
            elif activity_id=='2':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=2".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(6)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=2".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO externship(externship_student_name,externship_program,externship_course,externship_school_year,externship_semester,Company_company_id,externship_date_added) VALUES('{}','{}','{}','{}','{}','{}',CURRENT_TIMESTAMP)".format(externship_student_name,externship_program,externship_course,externship_school_year,externship_semester,company_id))
            elif activity_id=='3':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=3".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(7)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=3".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO scholarship(scholarship_student_name,sholarship_program,scholarship_course,scholarship_school_year,scholarship_semester,scholarship_amount,Company_company_id,scholarship_date_added) VALUES('{}','{}','{}','{}','{}','{}','{}',CURRENT_TIMESTAMP)".format(scholarship_student_name,scholarship_program,scholarship_course,scholarship_school_year,scholarship_semester,scholarship_amount,company_id))
            elif activity_id=='4':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=4".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(8)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=4".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO career_fair(career_fair_title,career_fair_date,career_fair_participants,Company_company_id,career_fair_date_added) VALUES('{}','{}','{}','{}',CURRENT_TIMESTAMP)".format(career_fair_title,career_fair_date,career_fair_participants,company_id))
            elif activity_id=='5':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=5".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(9)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=5".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO on_campus_recruitment(on_campus_recruitment_name,on_campus_recruitment_date,on_campus_recruitment_participants,Company_company_id,on_campus_recruitment_date_added) VALUES('{}','{}','{}','{}',CURRENT_TIMESTAMP)".format(on_campus_recruitment_name,on_campus_recruitment_date,on_campus_recruitment_participants,company_id))
            elif activity_id=='6':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=6".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(10)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=6".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO career_development_training(career_development_training_name,career_development_training_date,career_development_training_participants,Company_company_id,career_development_training_date_added) VALUES('{}','{}','{}','{}',CURRENT_TIMESTAMP)".format(career_development_training_name,career_development_training_date,career_development_training_participants,company_id))
            elif activity_id=='7':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=7".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(11)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=7".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO mock_job_interview(mock_job_interview_date,mock_job_interview_participants,Company_company_id,mock_job_interviewcol_date_added) VALUES('{}','{}','{}',CURRENT_TIMESTAMP)".format(mock_job_interview_date,mock_job_interview_participants,company_id))
            quantity=0
        return redirect('/company-management/administrator/company-profile/{}'.format(company_id))
            