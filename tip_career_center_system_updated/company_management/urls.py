from django.urls import path, include
from . import views

urlpatterns = [
    path('administrator/',views.Administrator.as_view(),name='administrator'),
    path('administrator/manage-companies/',views.ManageCompaniesAsAdmin.as_view(),name="manage_companies_as_admin"),
    path('administrator/add-company/',views.AddCompanyAsAdmin.as_view(),name="add_company_as_admin"),
    path('administrator/edit-company/<int:company_id>/', views.EditCompanyAsAdmin.as_view(),name="edit_company_as_admin"),
]