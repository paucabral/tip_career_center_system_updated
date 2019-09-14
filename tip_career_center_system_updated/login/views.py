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
        return render(request,template_name='login/login.html',context={})

        
    def post(self, request, *args, **kwargs):
        username = request.POST.get("username") 
        password = request.POST.get("password")

        with connection.cursor() as cursor:
            sql = "SELECT username, password FROM adminAccount WHERE username='{}'".format(username)
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

class Register(View):
    def get(self, request, *args, **kwargs):
        return render(request,template_name='login/signup.html',context={})

        
    def post(self, request, *args, **kwargs):
        username = request.POST.get("username") 
        password = request.POST.get("password")

        hashed_pass = make_password(password)

        with connection.cursor() as cursor:
            sql = "INSERT INTO adminAccount(username, password) VALUES ('{}','{}')".format(username,hashed_pass)
            cursor.execute(sql)
            connection.commit()
        return redirect('/')

