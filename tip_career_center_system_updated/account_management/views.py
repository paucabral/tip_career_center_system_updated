from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.views import View
from django.db import connection
from django.contrib.auth.hashers import make_password, check_password
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin

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

        with connection.cursor() as cursor:
            sql = "SELECT username, password FROM accounts WHERE username='{}'".format(username)
            cursor.execute(sql)
            result = dictfetchall(cursor)[0]
            print(result)
            if result == []:
                return redirect('/')
        print(check_password(password,result['password']))
        if check_password(password,result['password']):
            request.session["current_user"] = {"username":username}
            return redirect('/company-management/administrator/')
        else:    
            return redirect('/')

class Register(SuccessMessageMixin,View):
    #(test) login_url = '/' if LoginRequiredMixin used for restriction, add to parameter 
    #redirect_field_name = 'Login First'
    def get(self, request, *args, **kwargs):
        return render(request,template_name='account_management/signup.html',context={})

    def post(self, request, *args, **kwargs):
        first_name = request.POST.get("first_name")
        last_name = request.POST.get ("last_name")
        username = request.POST.get("username") 
        password = request.POST.get("password")
        password2 = request.POST.get("password2")
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
            #if password == password2:
                hashed_pass = make_password(password)
                with connection.cursor() as cursor:
                    sql = "INSERT INTO accounts(first_name,last_name,email,username, password, isAdmin) VALUES ('{}','{}','{}','{}','{}','{}')".format(first_name,last_name, email, username,hashed_pass,isAdmin)
                    cursor.execute(sql)
                    connection.commit()
                success_message = "%(username)s was created successfully"
                return redirect('/')
                
           # else:
               # print ("pass not match")
              #  return redirect ("http://127.0.0.1:8000/registerAdmin/")