from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.views import View
from django.db import connection
from django.contrib.auth.hashers import make_password, check_password

# Create your views here.
def dictfetchall(cursor): 
    "Returns all rows from a cursor as a dict" 
    desc = cursor.description 
    return [
            dict(zip([col[0] for col in desc], row)) 
            for row in cursor.fetchall() 
    ]

class Login(View):
    def get(self, request, *args, **kwargs):
        return render(request,template_name='account_management/login.html',context={})
     
    def post(self, request, *args, **kwargs):
        username = request.POST.get("username") 
        password = request.POST.get("password")

        try:
            with connection.cursor() as cursor:
                sql = "SELECT username, password FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sql)
                result = dictfetchall(cursor)[0]
                print("PRINTING RESULT")
                print(result)

                sqlAdmin = "SELECT isAdmin FROM accounts WHERE username='{}'".format(username)
                cursor.execute(sqlAdmin)
                resultAdmin = dictfetchall(cursor)[0]
        except IndexError:
            result = None
        
        if result is None:
            return redirect ('/')

        else:
            print(check_password(password,result['password']))
            if check_password(password,result['password']) and resultAdmin == {'isAdmin': 1}:
                request.session["current_user"] = {"username":username}
                return redirect('/company-management/administrator/')                   

            elif check_password(password,result['password']) and resultAdmin == {'isAdmin': 0}:
                request.session["current_user"] = {"username":username}
                return redirect('/company-management/ojt')
                
class Register(View):    
    def get(self, request, *args, **kwargs):
        with connection.cursor() as cursor:
            sql = "SELECT count(session_key) FROM django_session"
            cursor.execute(sql)
            result = dictfetchall(cursor)[0]
            print("PRINTED RESULTS FROM COUNT")
            print(result)

         
            print("REGISTER REQUEST USER ADMIN")
            print(request.user)
            return render(request,template_name='account_management/signup.html',context={})
           
    def post(self, request, *args, **kwargs):
        first_name = request.POST.get("first_name")
        last_name = request.POST.get ("last_name")
        username = request.POST.get("username") 
        password = request.POST.get("password")
        email = request.POST.get("email")
        isAdmin = request.POST.get("isAdmin")

        with connection.cursor() as cursor:
            sql = "SELECT username FROM accounts ".format(username)
            cursor.execute(sql)
            result = dictfetchall(cursor)
        if {'username':username} in result:
            print ("Username exists")
            return redirect ("http://127.0.0.1:8000/registerAdmin/")
            
        else:
            hashed_pass = make_password(password)
            with connection.cursor() as cursor:
                sql = "INSERT INTO accounts(first_name,last_name,email,username, password, isAdmin) VALUES ('{}','{}','{}','{}','{}','{}')".format(first_name,last_name, email, username,hashed_pass,isAdmin)
                cursor.execute(sql)
                connection.commit()
            return redirect('/')