from django.urls import path, include
from . import views

app_name = "account_management"

urlpatterns = [
    path('',views.Login.as_view(),name='login'),
    path('register/',views.Register.as_view(), name='registerAdmin'),
    path('view-activitylogs/',views.AdminViewActivityLogs.as_view(),name="view_sessions"),
    path('manage-accounts/',views.AdminManageAccounts.as_view(),name="view_sessions"),
]