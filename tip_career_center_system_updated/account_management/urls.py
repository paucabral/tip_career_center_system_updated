from django.urls import path, include
from . import views

app_name = "account_management"

urlpatterns = [
    path('',views.Login.as_view(),name='login'),
    path('registerAdmin/',views.Register.as_view(), name='registerAdmin'),
]