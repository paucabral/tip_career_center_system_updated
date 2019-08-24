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

class Login(View):
    def get(self, request, *args, **kwargs):
        return render(request,template_name='login/login.html',context={})

        
    def post(self, request, *args, **kwargs):
        pass 