from django.urls import path, include
from . import views

app_name = "login"

urlpatterns = [
    path('',views.Login.as_view(),name='login'),
    path('registerAdmin/',views.Register.as_view(), name='registerAdmin'),
]