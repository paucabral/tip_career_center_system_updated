from django.urls import path, include
from . import views

urlpatterns = [
    path('administrator/',views.Administrator.as_view(),name='administrator'),
    path('administrator/manage-companies/',views.ManageCompaniesAsAdmin.as_view(),name="manage_companies_as_admin"),
    path('administrator/add-company/',views.AddCompanyAsAdmin.as_view(),name="add_company_as_admin"),
    path('administrator/edit-company/<int:company_id>/', views.EditCompanyAsAdmin.as_view(),name="edit_company_as_admin"),
    path('administrator/company-profile/<int:company_id>/', views.ViewCompanyAsAdmin.as_view(),name="view_company_as_admin"),
    path('administrator/company-profile/<int:company_id>/1', views.ViewCompanyInternshipAsAdmin.as_view(),name="view_company_internship_as_admin"),
    path('administrator/company-profile/<int:company_id>/2', views.ViewCompanyExternshipAsAdmin.as_view(),name="view_company_externship_as_admin"),
    path('administrator/company-profile/<int:company_id>/3', views.ViewCompanyScholarshipAsAdmin.as_view(),name="view_company_scholarship_as_admin"),
    path('administrator/company-profile/<int:company_id>/4', views.ViewCompanyCareerFairAsAdmin.as_view(),name="view_company_career_fair_as_admin"),
    path('administrator/company-profile/<int:company_id>/5', views.ViewCompanyOnCampusRecruitmentAsAdmin.as_view(),name="view_on_campus_recruitment_as_admin"),
    path('administrator/company-profile/<int:company_id>/6', views.ViewCompanyCareerDevelopmentTrainingAsAdmin.as_view(),name="view_career_development_training_as_admin"),
    path('administrator/company-profile/<int:company_id>/7', views.ViewCompanyMockJobInterviewAsAdmin.as_view(),name="view_company_mock_job_interview_as_admin"),
]