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

class AddCompanyAsAdmin(View):
    def get(self, request, *args, **kwargs):
        return render(request,template_name='company_management/add_company_AsAdmin.html',context={})
    def post(self, request, *args, **kwargs):
        print("POST Function reached")
        # Company
        company_name = request.POST["company_name"]
        company_address = request.POST["company_address"]
        Industry_Type_industrytype_id = request.POST["Industry_Type_industrytype_id"]
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
        with connection.cursor() as cursor:
            cursor.execute("INSERT INTO company(company_name,company_address,Industry_Type_industrytype_id) VALUES ('{}','{}','{}')".format(company_name,company_address,Industry_Type_industrytype_id))
            cursor.execute("INSERT INTO contact_person(contactperson_fname,contactperson_lname,contactperson_position,contactperson_email,contactperson_number,contactperson_priority) VALUES ('{}','{}','{}','{}','{}','PRIMARY')".format(contactperson_fname,contactperson_lname,contactperson_position,contactperson_email,contactperson_number))
            cursor.execute("INSERT INTO contact_person(contactperson_fname,contactperson_lname,contactperson_position,contactperson_email,contactperson_number,contactperson_priority) VALUES ('{}','{}','{}','{}','{}','SECONDARY')".format(seccontactperson_fname,seccontactperson_lname,seccontactperson_position,seccontactperson_email,seccontactperson_number))
            connection.commit()
            
            cursor.execute("SELECT company_id FROM company ORDER BY company_id DESC LIMIT 1")
            compny_id=cursor.fetchone()[0]
            print("COMPANY ID IS HERE")
            print(compny_id)

            cursor.execute("SELECT contactperson_id FROM contact_person WHERE contactperson_priority='PRIMARY' ORDER BY contactperson_id DESC LIMIT 1")
            contact_id=cursor.fetchone()[0]

            cursor.execute("SELECT contactperson_id FROM contact_person WHERE contactperson_priority='SECONDARY' ORDER BY contactperson_id DESC LIMIT 1")
            contact_id2=cursor.fetchone()[0]

            cursor.execute("INSERT INTO company_has_contact_person VALUES('{}','{}')".format(compny_id,contact_id))
            cursor.execute("INSERT INTO company_has_contact_person VALUES('{}','{}')".format(compny_id,contact_id2))

            connection.commit()
            print("VALUES INSERTED")
        return redirect('/company-management/administrator/manage-companies/')

class EditCompanyAsAdmin(View):
    def get(self, request, *args, **kwargs):
        print(self.kwargs['company_id'])
        company_id = self.kwargs['company_id']

        with connection.cursor() as cursor:
            cursor.execute("SELECT contactperson_id FROM contact_person WHERE contactperson_id IN (SELECT Contact_Person_contactperson_id FROM company_has_contact_person WHERE Company_company_id='{}') AND contactperson_priority='PRIMARY' ORDER BY contactperson_id DESC LIMIT 1".format(company_id))
            contact_id=cursor.fetchone()[0]

            cursor.execute("SELECT contactperson_id FROM contact_person WHERE contactperson_id IN (SELECT Contact_Person_contactperson_id FROM company_has_contact_person WHERE Company_company_id='{}') AND contactperson_priority='SECONDARY' ORDER BY contactperson_id DESC LIMIT 1".format(company_id))
            contact_id2=cursor.fetchone()[0]

            print('contact ID is here!')
            print(contact_id)

        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM company WHERE company_id={}".format(company_id))
            result1=dictfetchall(cursor)[0]
            cursor.execute("SELECT * FROM contact_person WHERE contactperson_id={}".format(contact_id))
            result2=dictfetchall(cursor)[0]
            cursor.execute("SELECT * FROM contact_person WHERE contactperson_id={}".format(contact_id2))
            result3=dictfetchall(cursor)[0]
            print(result1)
        return render(request,template_name='company_management/edit_company_AsAdmin.html',context={"company":result1,"contact_person":result2,"2contact_person":result3})
    def post(self, request, *args, **kwargs):
        print("POST Function reached")
        company_id = self.kwargs['company_id']
        company_name = request.POST["company_name"]
        company_address = request.POST["company_address"]
        Industry_Type_industrytype_id = request.POST["Industry_Type_industrytype_id"]
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
            cursor.execute("SELECT contactperson_id FROM contact_person WHERE contactperson_id IN (SELECT Contact_Person_contactperson_id FROM company_has_contact_person WHERE Company_company_id='{}') AND contactperson_priority='PRIMARY' ORDER BY contactperson_id DESC LIMIT 1".format(company_id))
            contact_id=cursor.fetchone()[0]

            cursor.execute("SELECT contactperson_id FROM contact_person WHERE contactperson_id IN (SELECT Contact_Person_contactperson_id FROM company_has_contact_person WHERE Company_company_id='{}') AND contactperson_priority='SECONDARY' ORDER BY contactperson_id DESC LIMIT 1".format(company_id))
            contact_id2=cursor.fetchone()[0]

            print('contact ID is here!')
            print(contact_id)
        
        with connection.cursor() as cursor:
            cursor.execute("UPDATE company SET company_name='{}',company_address='{}' WHERE company_id={}".format(company_name,company_address,company_id))
            cursor.execute("UPDATE contact_person SET contactperson_fname='{}',contactperson_lname='{}',contactperson_position='{}',contactperson_email='{}',contactperson_number='{}' WHERE contactperson_id='{}'".format(contactperson_fname,contactperson_lname,contactperson_position,contactperson_email,contactperson_number,contact_id))
            cursor.execute("UPDATE contact_person SET contactperson_fname='{}',contactperson_lname='{}',contactperson_position='{}',contactperson_email='{}',contactperson_number='{}' WHERE contactperson_id='{}'".format(seccontactperson_fname,seccontactperson_lname,seccontactperson_position,seccontactperson_email,seccontactperson_number,contact_id2))
            
            connection.commit()
            print("VALUES INSERTED")
        return redirect('/company-management/administrator/manage-companies')

class ManageCompaniesAsAdmin(View):
    def post(self, request, *args, **kwargs):
        company_id = request.POST["company_id"]
        with connection.cursor() as cursor:
            cursor.execute("SET FOREIGN_KEY_CHECKS = 0")
            cursor.execute("DELETE FROM contact_person WHERE contactperson_id IN (SELECT Contact_Person_contactperson_id FROM company_has_contact_person WHERE Company_company_id='{}')".format(company_id))
            cursor.execute("SET FOREIGN_KEY_CHECKS = 1")
            cursor.execute("DELETE FROM company_has_contact_person WHERE Company_company_id='{}'".format(company_id))
            cursor.execute("DELETE FROM company WHERE company_id='{}'".format(company_id))
            result = dictfetchall(cursor)
        print(result)
        return redirect('/company-management/administrator/manage-companies')
    def get(self, request, *args, **kwargs):
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM company")
            result = dictfetchall(cursor)
        print(result)
        return render(request,template_name='company_management/manage_companies_AsAdmin.html',context={'companies':result})

class ViewCompanyAsAdmin(View):
    def get(self, request, *args, **kwargs):
        print(self.kwargs['company_id'])
        company_id = self.kwargs['company_id']

        with connection.cursor() as cursor:
            cursor.execute("SELECT contactperson_id FROM contact_person WHERE contactperson_id IN (SELECT Contact_Person_contactperson_id FROM company_has_contact_person WHERE Company_company_id='{}') AND contactperson_priority='PRIMARY' ORDER BY contactperson_id DESC LIMIT 1".format(company_id))
            contact_id=cursor.fetchone()[0]

            cursor.execute("SELECT contactperson_id FROM contact_person WHERE contactperson_id IN (SELECT Contact_Person_contactperson_id FROM company_has_contact_person WHERE Company_company_id='{}') AND contactperson_priority='SECONDARY' ORDER BY contactperson_id DESC LIMIT 1".format(company_id))
            contact_id2=cursor.fetchone()[0]

            print('contact ID is here!')
            print(contact_id)

        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM company WHERE company_id={}".format(company_id))
            result1=dictfetchall(cursor)[0]
            cursor.execute("SELECT * FROM contact_person WHERE contactperson_id={}".format(contact_id))
            result2=dictfetchall(cursor)[0]
            cursor.execute("SELECT * FROM contact_person WHERE contactperson_id={}".format(contact_id2))
            result3=dictfetchall(cursor)[0]
            print(result1)
        return render(request,template_name='company_management/company_profile_AsAdmin.html',context={"company":result1,"contact_person":result2,"2contact_person":result3})
    def post(self, request, *args, **kwargs):
        pass