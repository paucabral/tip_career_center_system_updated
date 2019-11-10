from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.views import View
from django.db import connection
from django.contrib.auth.hashers import make_password, check_password
from operator import itemgetter

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
        with connection.cursor() as cursor:
            sqlcheck = "SELECT count(session_key) FROM django_session"
            cursor.execute(sqlcheck)
            resultcheck = dictfetchall(cursor)[0]
        
        print ("RESULT OF USERNAME")
        print (resultcheck)
        print ("EXTRACTED")
        getval = resultcheck.get('count(session_key)')
        print(getval)
        if getval == 0:
            return render(request,template_name='account_management/login.html',context={})
        else:
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
                return render(request,template_name='account_management/login.html',context={})

            if (session_id == current_sesh and resultAdmin == {'isAdmin': 1}):
                return redirect('/company-management/administrator/')
            elif (session_id == current_sesh and resultAdmin == {'isAdmin': 0}):
                return redirect('/company-management/ojt/')
            else:
                return render(request,template_name='account_management/login.html',context={})
           # else:
            #    return render(request,template_name='account_management/login.html',context={})
            #elif (session_id != current_sesh):
               # with connection.cursor() as cursor:
                #    sql = "DELETE FROM django_session"
                 #   cursor.execute(sql)
                #return render(request,template_name='account_management/login.html',context={})

    def post(self, request, *args, **kwargs):
        username = request.POST.get("username") 
        password = request.POST.get("password")
        session_id = request.session.session_key
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

                getPass = "SELECT password FROM accounts WHERE username ='{}'".format(username)
                cursor.execute(getPass)
                resultPass = dictfetchall(cursor)[0]

                allPass = "SELECT password FROM accounts"
                cursor.execute(allPass)
                resultAllPass = dictfetchall(cursor)

                sqlSessions = "SELECT COUNT(*) FROM django_session"
                cursor.execute(sqlSessions)
                resultAllSessions = dictfetchall(cursor)
                print(resultAllSessions)

        except (IndexError, ValueError):
            result = None
        
        if result is None:
            return redirect ('/')

        elif not (check_password(password,result['password'])):
            return redirect ('/')

        else:
            with connection.cursor() as cursor:
                sql = "DELETE FROM django_session WHERE session_key not in (SELECT session_id FROM accounts)"
                cursor.execute(sql)
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
            return redirect ("http://127.0.0.1:8000/register/")
            
        else:
            hashed_pass = make_password(password)
            with connection.cursor() as cursor:
                sql = "INSERT INTO accounts(first_name,last_name,email,username, password, isAdmin) VALUES ('{}','{}','{}','{}','{}','{}')".format(first_name,last_name, email, username,hashed_pass,isAdmin)
                cursor.execute(sql)
                connection.commit()
            return redirect('/')

class AdminViewActivityLogs(View):
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
                cursor.execute("SELECT * FROM activity_log")
                result = dictfetchall(cursor)
            #     for i in result:
            #         print(i['company_id'])
            #         print("First")
            # print(result[0]['company_id'])
            return render(request,template_name='account_management/adminview_activitylogs.html',context={'activity_log':result})
        else:
            return redirect ('/')

class AdminManageAccounts(View):
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
                cursor.execute("SELECT id, username, password FROM accounts")
                result = dictfetchall(cursor)
            return render(request,template_name='account_management/adminManage_Accounts.html',context={'accounts':result})
        else:
            return redirect ('/')

    def post(self, request, *args, **kwargs):
        User_idDel = request.POST['DeleteID']
        print ("DELETE ID: ", User_idDel)
        action = request.POST['ActionBTN']
        print ("ACTION ID: ", action)
        newsername =  request.POST.get("changeuser_{}".format(User_idDel))
        newpassword = request.POST.get("changepassword_{}".format(User_idDel))
        newhashedpass = make_password(newpassword)
       
        if action == '1':
            with connection.cursor() as cursor:
                cursor.execute("DELETE FROM accounts WHERE id={}".format(User_idDel))
       
        else:
            print("USERNAME: ", newsername)
            print ("HASHEDPASS: ", newhashedpass)
            with connection.cursor() as cursor:
                cursor.execute("UPDATE accounts set username ='{}', password='{}' WHERE id='{}'".format(newsername, newhashedpass, User_idDel))

        return redirect('/account-management/manage-accounts/') 
