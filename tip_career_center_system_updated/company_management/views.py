from django.shortcuts import render, redirect
from django.http import HttpResponse, HttpResponseRedirect
from django.views import View
from django.db import connection
#for FilSystemsStorage
from django.core.files.storage import FileSystemStorage
from django.conf import settings
# from django.utils.datastructures import MultiValueDictError
import os

# ------------------------- For PDF Generation ---------------------------------
import copy
from django.views.generic.base import TemplateResponseMixin, ContextMixin, View
from .PDFrendering import render_to_pdf_response
# -----------------------------------------------------------------------------

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
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                giveSesh = "UPDATE accounts SET session_id='{}' WHERE isAdmin = 1 AND username = '{}'".format(session_id,username)
                cursor.execute(giveSesh) 
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            return render(request,template_name='company_management/administrator.html',context={})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            return redirect('/company-management/ojt/')
        else:
            return redirect('/')

class AddCompanyAsAdmin(View):#Made some changes here. ##contactperson --> contact_person
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM industry_type")
                industry = dictfetchall(cursor)
            return render(request,template_name='company_management/add_company_AsAdmin.html',context={"industry_type":industry})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            return redirect ('/company-management/ojt/add-company/')
        else:
            return redirect('/')

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

        picture = request.FILES.get("Profile")
        banner = request.FILES.get("Banner")
        moa = request.FILES.get("Memorandum_Agreement")

        fs = FileSystemStorage()
        
        pictureFileName = None
        bannerFileName = None
        moaFileName = None

        if picture is not None:
            picfiledir = str(company_name)+"/"+picture.name
            pfn = fs.save(picfiledir, picture)
            pictureFileName = fs.url(pfn)
        else:
            pictureFileName = "/static/img/profile.png"
        if banner is not None:
            bannerfiledir = str(company_name)+"/"+banner.name
            bfn = fs.save(bannerfiledir, banner)
            bannerFileName = fs.url(bfn)
        else:
            bannerFileName = "/static/img/Banner.jpg"
        
        if moa is not None:
            moafiledir= str(company_name)+"/"+moa.name
            mfn = fs.save(moafiledir, moa)
            moaFileName = fs.url(mfn)
        else:
            moaFileName = "static/defaultPDF.pdf"

        print(pictureFileName)
        print(bannerFileName)

        # fs = FileSystemStorage()
        # filename = fs.save(stpicture.name, stpicture)<-gets name of file
        # picurl = fs.url(filename)<-gets url of file
        # print(picurl)

        with connection.cursor() as cursor:
            cursor.callproc('uspAddCompany', [company_name, company_address, Industry_Type_industry_type_id, pictureFileName, bannerFileName, moaFileName])
            print("Company inserted")

            cursor.execute("SELECT company_id FROM company ORDER BY company_id DESC LIMIT 1")#Moved this here so I get company_id. Needed it in inserting the contact persons...
            compny_id=cursor.fetchone()[0]
            print("COMPANY ID IS HERE")
            print(compny_id)

            cursor.execute("INSERT INTO company_has_activity VALUES({},1,0), ({},2,0), ({},3,0), ({},4,0), ({},5,0), ({},6,0), ({},7,0)".format(compny_id,compny_id,compny_id,compny_id,compny_id,compny_id,compny_id))

            cursor.callproc('uspInsertContact', [contactperson_fname,contactperson_lname,contactperson_position,contactperson_email,contactperson_number,'PRIMARY',compny_id])
            print("contact 1 inserted")
            cursor.callproc('uspInsertContact', [contactperson_fname,contactperson_lname,contactperson_position,contactperson_email,contactperson_number,'SECONDARY',compny_id])
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
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
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
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            return redirect ('/company-management/ojt/edit-company/')
        else:
            return redirect('/')

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

        picture = request.FILES.get("Profile")
        banner = request.FILES.get("Banner")
        moa = request.FILES.get("Memorandum_Agreement")

        fs = FileSystemStorage()
        
        pictureFileName = None
        bannerFileName = None
        moaFileName = None


        with connection.cursor() as cursor:
            cursor.execute("SELECT contact_person_id FROM contact_person WHERE (Company_company_id='{}' AND contact_person_priority='PRIMARY') ORDER BY contact_person_id DESC LIMIT 1".format(company_id))
            contact_id=cursor.fetchone()[0]

            cursor.execute("SELECT contact_person_id FROM contact_person WHERE (Company_company_id='{}' AND contact_person_priority='SECONDARY') ORDER BY contact_person_id DESC LIMIT 1".format(company_id))
            contact_id2=cursor.fetchone()[0]

            print('contact ID is here!')
            print(contact_id2)

            cursor.execute("SELECT banner_image FROM company WHERE (company_id='{}') LIMIT 1".format(company_id))
            banner_image=cursor.fetchone()[0]

            cursor.execute("SELECT profile_image FROM company WHERE (company_id='{}') LIMIT 1".format(company_id))
            profile_image=cursor.fetchone()[0]

            cursor.execute("SELECT company_attachment FROM company WHERE (company_id='{}') LIMIT 1".format(company_id))
            moaFile=cursor.fetchone()[0]

        print(profile_image)

        if picture is not None:
            picfiledir = str(company_name)+"/"+picture.name
            pfn = fs.save(picfiledir, picture)
            pictureFileName = fs.url(pfn)
        else:
            pictureFileName = profile_image
        
        if banner is not None:
            bannerfiledir = str(company_name)+"/"+banner.name
            bfn = fs.save(bannerfiledir, banner)
            bannerFileName = fs.url(bfn)
        else:
            bannerFileName = banner_image
        if moa is not None:
            moafiledir = str(company_name)+"/"+moa.name
            mfn = fs.save(moafiledir, moa)
            moaFileName = fs.url(mfn)
        else:
            moaFileName = moaFile

        with connection.cursor() as cursor:
            cursor.callproc('uspUpdateCompany',[company_name, company_address, Industry_Type_industry_type_id, pictureFileName, bannerFileName, moaFileName,company_id])
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
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM company")
                result = dictfetchall(cursor)
            #     for i in result:
            #         print(i['company_id'])
            #         print("First")
            # print(result[0]['company_id'])
            return render(request,template_name='company_management/manage_companies_AsAdmin.html',context={'companies':result})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            return redirect('/company-management/ojt/manage-companies/')
        else:
            return redirect ('/')

class ViewCompanyAsAdmin(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
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
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            return redirect('/company-management/ojt/manage-companies/')
        else: 
            return redirect ('/')

    def post(self, request, *args, **kwargs):
        company_id = self.kwargs['company_id']
        company_name = None
        activity_id = request.POST['activity_id']

        print("Activity ID: ",activity_id)

        #INTERNSHIP
        internship_student_name = request.POST['internship_student_name']
        internship_program = request.POST['internship_program']
        internship_school_year = request.POST['internship_school_year']
        internship_semester = request.POST['internship_semester']
        
        #EXTERNSHIP
        externship_student_name = request.POST['externship_student_name']
        externship_program = request.POST['externship_program']
        externship_school_year = request.POST['externship_school_year']
        externship_semester = request.POST['externship_semester']

        #SCHOLARSHIP
        scholarship_student_name = request.POST['scholarship_student_name']
        scholarship_program = request.POST['scholarship_program']
        scholarship_school_year = request.POST['scholarship_school_year']
        scholarship_semester = request.POST['scholarship_semester']
        scholarship_amount = request.POST['scholarship_amount']

        #CAREER FAIR
        career_fair_title = request.POST['career_fair_title']
        career_fair_date = request.POST['career_fair_date']
        career_fair_participants = request.POST['career_fair_participants']
        career_fair_attachment = request.FILES.get('career_fair_attachment')

        #ON-CAMPUS RECRUITMENT
        on_campus_recruitment_name = request.POST['on_campus_recruitment_name']
        on_campus_recruitment_date = request.POST['on_campus_recruitment_date']
        on_campus_recruitment_participants = request.POST['on_campus_recruitment_participants']
        on_campus_recruitment_attachment = request.FILES.get("on_campus_recruitment_attachment")

        #CAREER DEVELOPMENT TRAINING
        career_development_training_name = request.POST['career_development_name']
        career_development_training_date = request.POST['career_development_date']
        career_development_training_participants = request.POST['career_development_participants']
        career_development_training_attachments = request.FILES.get("career_development_attachments")

        #MOCK JOB INTERVIEW
        mock_job_interview_date = request.POST['mock_job_interview_date']
        mock_job_interview_participants = request.POST['mock_job_interview_participants']

        fs = FileSystemStorage()
        cfa_path = None #career fair attachment path
        ocr_path = None #on campus recruitment attachment path
        cdt_path = None #career development training attachment path
        with connection.cursor() as cursor:
            cursor.execute("SELECT company_name FROM company where company_id = {}".format(company_id))
            result = dictfetchall(cursor)
            company_name = str(result[0].get("company_name"))
            print("HAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
            print(company_name)
            print(company_id)
            if career_fair_attachment is not None:
                cfadir = company_name+"/"+career_fair_attachment.name
                cfa_filename = fs.save(cfadir, career_fair_attachment)
                cfa_path = fs.url(cfa_filename)

            if on_campus_recruitment_attachment is not None:
                ocrdir = company_name+"/"+on_campus_recruitment_attachment.name
                ocr_filename = fs.save(ocrdir, on_campus_recruitment_attachment)
                ocr_path = fs.url(ocr_filename)
            
            if career_development_training_attachments is not None:
                cdtdir = company_name+"/"+career_development_training_attachments.name
                cdt_filename = fs.save(cdtdir, career_development_training_attachments)
                cdt_path = fs.url(cdt_filename)

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
                cursor.execute("INSERT INTO intership(internship_student_name,intership_program,intership_school_year,internship_semester,Company_company_id,internship_date_added) VALUES('{}','{}','{}','{}','{}',CURRENT_TIMESTAMP)".format(internship_student_name,internship_program,internship_school_year,internship_semester,company_id))
            elif activity_id=='2':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=2".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(5)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=2".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO externship(externship_student_name,externship_program,externship_school_year,externship_semester,Company_company_id,externship_date_added) VALUES('{}','{}','{}','{}','{}',CURRENT_TIMESTAMP)".format(externship_student_name,externship_program,externship_school_year,externship_semester,company_id))
            elif activity_id=='3':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=3".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(10)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=3".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO scholarship(scholarship_student_name,sholarship_program,scholarship_school_year,scholarship_semester,scholarship_amount,Company_company_id,scholarship_date_added) VALUES('{}','{}','{}','{}','{}','{}',CURRENT_TIMESTAMP)".format(scholarship_student_name,scholarship_program,scholarship_school_year,scholarship_semester,scholarship_amount,company_id))
            elif activity_id=='4':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=4".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(3)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=4".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO career_fair(career_fair_title,career_fair_date,career_fair_participants,Company_company_id,career_fair_date_added,career_fair_attachment) VALUES('{}','{}','{}','{}',CURRENT_TIMESTAMP,'{}')".format(career_fair_title,career_fair_date,career_fair_participants,company_id,cfa_path))
            elif activity_id=='5':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=5".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(3)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=5".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO on_campus_recruitment(on_campus_recruitment_name,on_campus_recruitment_date,on_campus_recruitment_participants,Company_company_id,on_campus_recruitment_date_added,on_campus_recruitment_attachment) VALUES('{}','{}','{}','{}',CURRENT_TIMESTAMP,'{}')".format(on_campus_recruitment_name,on_campus_recruitment_date,on_campus_recruitment_participants,company_id,ocr_path))
            elif activity_id=='6':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=6".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(3)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=6".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO career_development_training(career_development_training_name,career_development_training_date,career_development_training_participants,Company_company_id,career_development_training_date_added,career_development_training_attachment) VALUES('{}','{}','{}','{}',CURRENT_TIMESTAMP,'{}')".format(career_development_training_name,career_development_training_date,career_development_training_participants,company_id,cdt_path))
            elif activity_id=='7':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=7".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(3)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=7".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO mock_job_interview(mock_job_interview_date,mock_job_interview_participants,Company_company_id,mock_job_interviewcol_date_added) VALUES('{}','{}','{}',CURRENT_TIMESTAMP)".format(mock_job_interview_date,mock_job_interview_participants,company_id))
            quantity=0
        return redirect('/company-management/administrator/company-profile/{}'.format(company_id))
    
class ViewCompanyInternshipAsAdmin(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            print(self.kwargs['company_id'])
            company_id = self.kwargs['company_id']

            with connection.cursor() as cursor:
                cursor.execute("SELECT*FROM intership WHERE Company_company_id={}".format(company_id))
                internships=dictfetchall(cursor)
            return render(request,template_name='company_management/company_profile_internships_AsAdmin.html',context={"internships":internships})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            return redirect('/company-management/ojt/manage-companies/')
        else:
            return redirect ('/')

class ViewCompanyExternshipAsAdmin(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            print(self.kwargs['company_id'])
            company_id = self.kwargs['company_id']
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT*FROM externship WHERE Company_company_id={}".format(company_id))
                externships=dictfetchall(cursor)
            return render(request,template_name='company_management/company_profile_externships_AsAdmin.html',context={"externships":externships})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            return redirect('/company-management/ojt/manage-companies/')
        else:
            return redirect ('/')

class ViewCompanyScholarshipAsAdmin(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            print(self.kwargs['company_id'])
            company_id = self.kwargs['company_id']
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT*FROM scholarship WHERE Company_company_id={}".format(company_id))
                scholarships=dictfetchall(cursor)
            return render(request,template_name='company_management/company_profile_scholarships_AsAdmin.html',context={"scholarships":scholarships})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            return redirect('/company-management/ojt/manage-companies/')
        else:
            return redirect('/')

class ViewCompanyCareerFairAsAdmin(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            print(self.kwargs['company_id'])
            company_id = self.kwargs['company_id']
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT*FROM career_fair WHERE Company_company_id={}".format(company_id))
                career_fairs=dictfetchall(cursor)
            
            careerfair=career_fairs[0]
            replace=careerfair['career_fair_attachment']
            print(replace.decode("utf-8"))

            career_fairs[0]['career_fair_attachment']=replace.decode("utf-8")
            
            return render(request,template_name='company_management/company_profile_career_fairs_AsAdmin.html',context={"career_fairs":career_fairs})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            return redirect('/company-management/ojt/manage-companies/')
        else:
            return redirect('/')

class ViewCompanyOnCampusRecruitmentAsAdmin(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            print(self.kwargs['company_id'])
            company_id = self.kwargs['company_id']
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT*FROM on_campus_recruitment WHERE Company_company_id={}".format(company_id))
                on_campus_recruitments=dictfetchall(cursor)
            oncamp=on_campus_recruitments[0]
            replace=oncamp['on_campus_recruitment_attachment']
            print(replace.decode("utf-8"))

            on_campus_recruitments[0]['on_campus_recruitment_attachment']=replace.decode("utf-8")

            return render(request,template_name='company_management/company_profile_on_campus_recruitments_AsAdmin.html',context={"on_campus_recruitments":on_campus_recruitments})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            return redirect('/company-management/ojt/manage-companies/')
        else:
            return redirect('/')

class ViewCompanyCareerDevelopmentTrainingAsAdmin(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            print(self.kwargs['company_id'])
            company_id = self.kwargs['company_id']
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT*FROM career_development_training WHERE Company_company_id={}".format(company_id))
                career_development_trainings=dictfetchall(cursor)

            
            career_dev=career_development_trainings[0]
            replace=career_dev['career_development_training_attachment']
            print(replace.decode("utf-8"))
            
            career_development_trainings[0]['career_development_training_attachment']=replace.decode("utf-8")

            return render(request,template_name='company_management/company_profile_career_development_trainings_AsAdmin.html',context={"career_development_trainings":career_development_trainings})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            return redirect('/company-management/ojt/manage-companies/')
        else:
            return redirect('/')
            
class ViewCompanyMockJobInterviewAsAdmin(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            print(self.kwargs['company_id'])
            company_id = self.kwargs['company_id']
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT*FROM mock_job_interview WHERE Company_company_id={}".format(company_id))
                mock_job_interviews=dictfetchall(cursor)
            return render(request,template_name='company_management/company_profile_mock_job_interviews_AsAdmin.html',context={"mock_job_interviews":mock_job_interviews})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            return redirect('/company-management/ojt/manage-companies/')
        else:
            return redirect ('/')
            
class ViewCompanyAsOJT(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
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
            return render(request,template_name='company_management/company_profile_AsOJT.html',context={"company":result1,"contact_person":result2,"2contact_person":result3, "companyActs":actResults, "activities":activities})
        else:
            return redirect('/')
    
    def post(self, request, *args, **kwargs):
        company_id = self.kwargs['company_id']
        activity_id = request.POST['activity_id']

        print("Activity ID: ",activity_id)

        #INTERNSHIP
        internship_student_name = request.POST['internship_student_name']
        internship_program = request.POST['internship_program']
        internship_school_year = request.POST['internship_school_year']
        internship_semester = request.POST['internship_semester']
        
        #EXTERNSHIP
        externship_student_name = request.POST['externship_student_name']
        externship_program = request.POST['externship_program']
        externship_school_year = request.POST['externship_school_year']
        externship_semester = request.POST['externship_semester']

        #SCHOLARSHIP
        scholarship_student_name = request.POST['scholarship_student_name']
        scholarship_program = request.POST['scholarship_program']
        scholarship_school_year = request.POST['scholarship_school_year']
        scholarship_semester = request.POST['scholarship_semester']
        scholarship_amount = request.POST['scholarship_amount']

        #CAREER FAIR
        career_fair_title = request.POST['career_fair_title']
        career_fair_date = request.POST['career_fair_date']
        career_fair_participants = request.POST['career_fair_participants']
        career_fair_attachment = request.FILES.get('career_fair_attachment')

        #ON-CAMPUS RECRUITMENT
        on_campus_recruitment_name = request.POST['on_campus_recruitment_name']
        on_campus_recruitment_date = request.POST['on_campus_recruitment_date']
        on_campus_recruitment_participants = request.POST['on_campus_recruitment_participants']
        on_campus_recruitment_attachment = request.FILES.get("on_campus_recruitment_attachment")

        #CAREER DEVELOPMENT TRAINING
        career_development_training_name = request.POST['career_development_name']
        career_development_training_date = request.POST['career_development_date']
        career_development_training_participants = request.POST['career_development_participants']
        career_development_training_attachments = request.FILES.get("career_development_attachments")

        #MOCK JOB INTERVIEW
        mock_job_interview_date = request.POST['mock_job_interview_date']
        mock_job_interview_participants = request.POST['mock_job_interview_participants']

        fs = FileSystemStorage()
        cfa_path = None #career fair attachment path
        ocr_path = None #on campus recruitment attachment path
        cdt_path = None #career development training attachment path
        with connection.cursor() as cursor:
            cursor.execute("SELECT company_name FROM company where company_id = {}".format(company_id))
            result = dictfetchall(cursor)
            company_name = str(result[0].get("company_name"))
            print("HAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
            print(company_name)
            print(company_id)
            if career_fair_attachment is not None:
                cfadir = company_name+"/"+career_fair_attachment.name
                cfa_filename = fs.save(cfadir, career_fair_attachment)
                cfa_path = fs.url(cfa_filename)

            if on_campus_recruitment_attachment is not None:
                ocrdir = company_name+"/"+on_campus_recruitment_attachment.name
                ocr_filename = fs.save(ocrdir, on_campus_recruitment_attachment)
                ocr_path = fs.url(ocr_filename)
            
            if career_development_training_attachments is not None:
                cdtdir = company_name+"/"+career_development_training_attachments.name
                cdt_filename = fs.save(cdtdir, career_development_training_attachments)
                cdt_path = fs.url(cdt_filename)

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
                cursor.execute("INSERT INTO intership(internship_student_name,intership_program,intership_school_year,internship_semester,Company_company_id,internship_date_added) VALUES('{}','{}','{}','{}','{}',CURRENT_TIMESTAMP)".format(internship_student_name,internship_program,internship_school_year,internship_semester,company_id))
            elif activity_id=='2':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=2".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(5)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=2".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO externship(externship_student_name,externship_program,externship_school_year,externship_semester,Company_company_id,externship_date_added) VALUES('{}','{}','{}','{}','{}',CURRENT_TIMESTAMP)".format(externship_student_name,externship_program,externship_school_year,externship_semester,company_id))
            elif activity_id=='3':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=3".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(10)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=3".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO scholarship(scholarship_student_name,sholarship_program,scholarship_school_year,scholarship_semester,scholarship_amount,Company_company_id,scholarship_date_added) VALUES('{}','{}','{}','{}','{}','{}',CURRENT_TIMESTAMP)".format(scholarship_student_name,scholarship_program,scholarship_school_year,scholarship_semester,scholarship_amount,company_id))
            elif activity_id=='4':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=4".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(3)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=4".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO career_fair(career_fair_title,career_fair_date,career_fair_participants,Company_company_id,career_fair_date_added,career_fair_attachment) VALUES('{}','{}','{}','{}',CURRENT_TIMESTAMP,'{}')".format(career_fair_title,career_fair_date,career_fair_participants,company_id,cfa_path))
            elif activity_id=='5':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=5".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(3)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=5".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO on_campus_recruitment(on_campus_recruitment_name,on_campus_recruitment_date,on_campus_recruitment_participants,Company_company_id,on_campus_recruitment_date_added,on_campus_recruitment_attachment) VALUES('{}','{}','{}','{}',CURRENT_TIMESTAMP,'{}')".format(on_campus_recruitment_name,on_campus_recruitment_date,on_campus_recruitment_participants,company_id,ocr_path))
            elif activity_id=='6':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=6".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(3)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=6".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO career_development_training(career_development_training_name,career_development_training_date,career_development_training_participants,Company_company_id,career_development_training_date_added,career_development_training_attachment) VALUES('{}','{}','{}','{}',CURRENT_TIMESTAMP,'{}')".format(career_development_training_name,career_development_training_date,career_development_training_participants,company_id,cdt_path))
            elif activity_id=='7':
                cursor.execute("SELECT company_engagement_score FROM company WHERE company_id={}".format(company_id))
                company_engagement_score=cursor.fetchone()[0]
                cursor.execute("SELECT quantity FROM company_has_activity WHERE Company_company_id={} AND Activity_activity_id=7".format(company_id))
                quantity=cursor.fetchone()[0]
                quantity+=1
                company_engagement_score+=(3)
                cursor.execute("UPDATE company_has_activity SET quantity={} WHERE Company_company_id={} AND Activity_activity_id=7".format(quantity,company_id))
                cursor.execute("UPDATE company SET company_engagement_score={} WHERE company_id={}".format(company_engagement_score,company_id))
                cursor.execute("INSERT INTO mock_job_interview(mock_job_interview_date,mock_job_interview_participants,Company_company_id,mock_job_interviewcol_date_added) VALUES('{}','{}','{}',CURRENT_TIMESTAMP)".format(mock_job_interview_date,mock_job_interview_participants,company_id))
            quantity=0
        return redirect('/company-management/ojt/company-profile/{}'.format(company_id))

class OJT(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                giveSesh = "UPDATE accounts SET session_id='{}' WHERE isAdmin = 0 AND username = '{}'".format(session_id,username)
                cursor.execute(giveSesh) 
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            return render(request,template_name='company_management/ojt.html',context={})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            return redirect('/company-management/administrator/')
        else:
            return redirect('/')

class AddCompanyAsOJT(View):#Made some changes here. ##contactperson --> contact_person
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM industry_type")
                industry = dictfetchall(cursor)
            return render(request,template_name='company_management/add_company_AsOJT.html',context={"industry_type":industry})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            return redirect ('/company-management/administrator/add-company')
        else:
            return redirect('/')

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

        picture = request.FILES.get("Profile")
        banner = request.FILES.get("Banner")
        moa = request.FILES.get("Memorandum_Agreement")

        fs = FileSystemStorage()
        
        pictureFileName = None
        bannerFileName = None
        moaFileName = None

        if picture is not None:
            picfiledir = str(company_name)+"/"+picture.name
            pfn = fs.save(picfiledir, picture)
            pictureFileName = fs.url(pfn)
        else:
            pictureFileName = "/static/img/profile.png"
        if banner is not None:
            bannerfiledir = str(company_name)+"/"+banner.name
            bfn = fs.save(bannerfiledir, banner)
            bannerFileName = fs.url(bfn)
        else:
            bannerFileName = "/static/img/Banner.jpg"
        
        if moa is not None:
            moafiledir= str(company_name)+"/"+moa.name
            mfn = fs.save(moafiledir, moa)
            moaFileName = fs.url(mfn)
        else:
            moaFileName = "static/defaultPDF.pdf"

        print(pictureFileName)
        print(bannerFileName)

        # fs = FileSystemStorage()
        # filename = fs.save(stpicture.name, stpicture)<-gets name of file
        # picurl = fs.url(filename)<-gets url of file
        # print(picurl)

        with connection.cursor() as cursor:
            cursor.callproc('uspAddCompany', [company_name, company_address, Industry_Type_industry_type_id, pictureFileName, bannerFileName, moaFileName])
            cursor.execute("SELECT company_id FROM company ORDER BY company_id DESC LIMIT 1")#Moved this here so I get company_id. Needed it in inserting the contact persons...
            compny_id=cursor.fetchone()[0]
            print("COMPANY ID IS HERE")
            print(compny_id)

            cursor.execute("INSERT INTO company_has_activity VALUES({},1,0), ({},2,0), ({},3,0), ({},4,0), ({},5,0), ({},6,0), ({},7,0)".format(compny_id,compny_id,compny_id,compny_id,compny_id,compny_id,compny_id))
 #           connection.commit()
            cursor.callproc('uspInsertContact', [contactperson_fname,contactperson_lname,contactperson_position,contactperson_email,contactperson_number,'PRIMARY',compny_id])
            print("contact 1 inserted")
            cursor.callproc('uspInsertContact', [contactperson_fname,contactperson_lname,contactperson_position,contactperson_email,contactperson_number,'SECONDARY',compny_id])
            print("contact 2 inserted")
#company_has_contact_person is removed in our new database.
#            cursor.execute("SELECT contact_person_id FROM contact_person WHERE contact_person_priority='PRIMARY' ORDER BY contact_person_id DESC LIMIT 1")
#            contact_id=cursor.fetchone()[0]

#            cursor.execute("SELECT contact_person_id FROM contact_person WHERE contact_person_priority='SECONDARY' ORDER BY contact_person_id DESC LIMIT 1")
#            contact_id2=cursor.fetchone()[0]

#            cursor.execute("INSERT INTO company_has_contact_person VALUES('{}','{}')".format(compny_id,contact_id))
#            cursor.execute("INSERT INTO company_has_contact_person VALUES('{}','{}')".format(compny_id,contact_id2))

            connection.commit()
            print("VALUES INSERTED")
        return redirect('/company-management/ojt/manage-companies/')

class EditCompanyAsOJT(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/') 

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
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
            return render(request,template_name='company_management/edit_company_AsOJT.html',context={"company":result1,"contact_person":result2,"2contact_person":result3,"industry_type":industry})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            return redirect ('/company-management/ojt/edit-company/')
        else:
            return redirect ('/')

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

        picture = request.FILES.get("Profile")
        banner = request.FILES.get("Banner")
        moa = request.FILES.get("Memorandum_Agreement")

        fs = FileSystemStorage()
        
        pictureFileName = None
        bannerFileName = None
        moaFileName = None


        with connection.cursor() as cursor:
            cursor.execute("SELECT contact_person_id FROM contact_person WHERE (Company_company_id='{}' AND contact_person_priority='PRIMARY') ORDER BY contact_person_id DESC LIMIT 1".format(company_id))
            contact_id=cursor.fetchone()[0]

            cursor.execute("SELECT contact_person_id FROM contact_person WHERE (Company_company_id='{}' AND contact_person_priority='SECONDARY') ORDER BY contact_person_id DESC LIMIT 1".format(company_id))
            contact_id2=cursor.fetchone()[0]

            print('contact ID is here!')
            print(contact_id2)

            cursor.execute("SELECT banner_image FROM company WHERE (company_id='{}') LIMIT 1".format(company_id))
            banner_image=cursor.fetchone()[0]

            cursor.execute("SELECT profile_image FROM company WHERE (company_id='{}') LIMIT 1".format(company_id))
            profile_image=cursor.fetchone()[0]

            cursor.execute("SELECT company_attachment FROM company WHERE (company_id='{}') LIMIT 1".format(company_id))
            moaFile=cursor.fetchone()[0]

        print(profile_image)

        if picture is not None:
            picfiledir = str(company_name)+"/"+picture.name
            pfn = fs.save(picfiledir, picture)
            pictureFileName = fs.url(pfn)
        else:
            pictureFileName = profile_image
        
        if banner is not None:
            bannerfiledir = str(company_name)+"/"+banner.name
            bfn = fs.save(bannerfiledir, banner)
            bannerFileName = fs.url(bfn)
        else:
            bannerFileName = banner_image
        if moa is not None:
            moafiledir = str(company_name)+"/"+moa.name
            mfn = fs.save(moafiledir, moa)
            moaFileName = fs.url(mfn)
        else:
            moaFileName = moaFile

        with connection.cursor() as cursor:
            cursor.callproc('uspUpdateCompany',[company_name, company_address, Industry_Type_industry_type_id, profile_image, banner_image, company_attachment])
            cursor.execute("UPDATE contact_person SET contact_person_fname='{}',contact_person_lname='{}',contact_person_position='{}',contact_person_email='{}',contact_person_no='{}' WHERE contact_person_id='{}' AND contact_person_priority='PRIMARY'".format(contactperson_fname,contactperson_lname,contactperson_position,contactperson_email,contactperson_number,contact_id))
            cursor.execute("UPDATE contact_person SET contact_person_fname='{}',contact_person_lname='{}',contact_person_position='{}',contact_person_email='{}',contact_person_no='{}' WHERE contact_person_id='{}' AND contact_person_priority='SECONDARY'".format(seccontactperson_fname,seccontactperson_lname,seccontactperson_position,seccontactperson_email,seccontactperson_number,contact_id2))
            
            connection.commit()
            print("VALUES INSERTED")
        return redirect('/company-management/ojt/manage-companies')

class ManageCompaniesAsOJT(View):
    def post(self, request, *args, **kwargs):

        # companies=cursor.fetchall()

        # for i in companies:
        #     print(i[0])
        #     print("First")

        company_id = request.POST["company_id"]
            
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
        return redirect('/company-management/ojt/manage-companies')
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM company")
                result = dictfetchall(cursor)
            #     for i in result:
            #         print(i['company_id'])
            #         print("First")
            # print(result[0]['company_id'])
            return render(request,template_name='company_management/manage_companies_AsOJT.html',context={'companies':result})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            return redirect('/company-management/administrator/manage-companies/')
        else:
            return redirect ('/')
class ViewCompanyCareerDevelopmentTrainingAsOJT(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            print(self.kwargs['company_id'])
            company_id = self.kwargs['company_id']
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT*FROM career_development_training WHERE Company_company_id={}".format(company_id))
                career_development_trainings=dictfetchall(cursor)

            career_dev=career_development_trainings[0]
            replace=career_dev['career_development_training_attachment']
            print(replace.decode("utf-8"))

            career_development_trainings[0]['career_development_training_attachment']=replace.decode("utf-8")
            
            return render(request,template_name='company_management/company_profile_career_development_trainings_AsOJT.html',context={"career_development_trainings":career_development_trainings})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            return redirect('/company-management/administrator/manage-companies/')
        else:
            return redirect ('/')

class ViewCompanyCareerFairAsOJT(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            print(self.kwargs['company_id'])
            company_id = self.kwargs['company_id']
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT*FROM career_fair WHERE Company_company_id={}".format(company_id))
                career_fairs=dictfetchall(cursor)
            
            careerfair=career_fairs[0]
            replace=careerfair['career_fair_attachment']
            print(replace.decode("utf-8"))

            careerfair[0]['career_fair_attachment']=replace.decode("utf-8")
            career_fairs[0]['career_fair_attachment']=replace.decode("utf-8")

            return render(request,template_name='company_management/company_profile_career_fairs_AsOJT.html',context={"career_fairs":career_fairs})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            return redirect('/company-management/administrator/manage-companies/')
        else:
            return redirect ('/')

class ViewCompanyExternshipAsOJT(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            print(self.kwargs['company_id'])
            company_id = self.kwargs['company_id']
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT*FROM externship WHERE Company_company_id={}".format(company_id))
                externships=dictfetchall(cursor)
            return render(request,template_name='company_management/company_profile_externships_AsOJT.html',context={"externships":externships})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            return redirect('/company-management/administrator/manage-companies/')
        else:
            return redirect('/')

class ViewCompanyInternshipAsOJT(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            print(self.kwargs['company_id'])
            company_id = self.kwargs['company_id']

            with connection.cursor() as cursor:
                cursor.execute("SELECT*FROM intership WHERE Company_company_id={}".format(company_id))
                internships=dictfetchall(cursor)
            return render(request,template_name='company_management/company_profile_internships_AsOJT.html',context={"internships":internships})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            return redirect('/company-management/administrator/manage-companies/')
        else: 
            return redirect ('/')
class ViewCompanyMockJobInterviewAsOJT(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            print(self.kwargs['company_id'])
            company_id = self.kwargs['company_id']
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT*FROM mock_job_interview WHERE Company_company_id={}".format(company_id))
                mock_job_interviews=dictfetchall(cursor)
            return render(request,template_name='company_management/company_profile_mock_job_interviews_AsOJT.html',context={"mock_job_interviews":mock_job_interviews})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            return redirect('/company-management/administrator/manage-companies/')
        else:
            return redirect ('/')
class ViewCompanyOnCampusRecruitmentAsOJT(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            print(self.kwargs['company_id'])
            company_id = self.kwargs['company_id']
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT*FROM on_campus_recruitment WHERE Company_company_id={}".format(company_id))
                on_campus_recruitments=dictfetchall(cursor)
            
            oncamp=on_campus_recruitments[0]
            replace=oncamp['on_campus_recruitment_attachment']
            print(replace.decode("utf-8"))

            on_campus_recruitments[0]['on_campus_recruitment_attachment']=replace.decode("utf-8")

            return render(request,template_name='company_management/company_profile_on_campus_recruitments_AsOJT.html',context={"on_campus_recruitments":on_campus_recruitments})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            return redirect('/company-management/administrator/manage-companies/')
        else:
            return redirect('/')

class ViewCompanyScholarshipAsOJT(View):
    def get(self, request, *args, **kwargs):
        try:
            session_id = request.session.session_key
            uname_dict = request.session["current_user"] 
            username = uname_dict.get('username')
            with connection.cursor() as cursor:
                checkSesh = "SELECT session_id FROM accounts WHERE username = '{}'".format(username)
                cursor.execute(checkSesh) 
                checkSeshResult = dictfetchall(cursor)[0]
                current_sesh = checkSeshResult.get('session_id')
                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except KeyError:
            return redirect('/')

        if (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
            print(self.kwargs['company_id'])
            company_id = self.kwargs['company_id']
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT*FROM scholarship WHERE Company_company_id={}".format(company_id))
                scholarships=dictfetchall(cursor)
            return render(request,template_name='company_management/company_profile_scholarships_AsOJT.html',context={"scholarships":scholarships})
        elif (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
            return redirect('/company-management/administrator/manage-companies/')
        else:
            return redirect ('/')

# --- New views ~Zeus ---

class PDFTemplateResponseMixin(TemplateResponseMixin):
    pdf_kwargs = None
    def get_pdf_kwargs(self):
        if self.pdf_kwargs is None:
            return {}
        return copy.copy(self.pdf_kwargs)

    def get_pdf_response(self, context, **response_kwargs):
        return render_to_pdf_response(
            request=self.request,
            template=self.get_template_names(),
            context=context,
            using=self.template_engine,
            **self.get_pdf_kwargs()
        )

    def render_to_response(self, context, **response_kwargs):
        return self.get_pdf_response(context, **response_kwargs)

class PDFTemplateView(PDFTemplateResponseMixin, ContextMixin, View):
    template_name = 'PDF/profilePDF.html'

    def get(self, request, *args, **kwargs):
        context = self.get_context_data(**kwargs)
        return self.render_to_response(context)
