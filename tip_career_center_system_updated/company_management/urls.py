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

    path('ojt/company-profile/<int:company_id>/', views.ViewCompanyAsOJT.as_view(),name="view_company_as_ojt"),
    path('ojt/',views.OJT.as_view(),name='ojt'),
    path('ojt/add-company/',views.AddCompanyAsOJT.as_view(),name="add_company_as_ojt"),
    path('ojt/edit-company/<int:company_id>/', views.EditCompanyAsOJT.as_view(),name="edit_company_as_ojt"),
    path('ojt/manage-companies/',views.ManageCompaniesAsOJT.as_view(),name="manage_companies_as_ojt"),
    path('ojt/company-profile/<int:company_id>/6', views.ViewCompanyCareerDevelopmentTrainingAsOJT.as_view(),name="view_career_development_training_as_ojt"),
    path('ojt/company-profile/<int:company_id>/4', views.ViewCompanyCareerFairAsOJT.as_view(),name="view_company_career_fair_as_ojt"),
    path('ojt/company-profile/<int:company_id>/2', views.ViewCompanyExternshipAsOJT.as_view(),name="view_company_externship_as_ojt"),
    path('ojt/company-profile/<int:company_id>/1', views.ViewCompanyInternshipAsOJT.as_view(),name="view_company_internship_as_ojt"),
    path('ojt/company-profile/<int:company_id>/7', views.ViewCompanyMockJobInterviewAsOJT.as_view(),name="view_company_mock_job_interview_as_ojt"),
    path('ojt/company-profile/<int:company_id>/5', views.ViewCompanyOnCampusRecruitmentAsOJT.as_view(),name="view_on_campus_recruitment_as_ojt"),
    path('ojt/company-profile/<int:company_id>/3', views.ViewCompanyScholarshipAsOJT.as_view(),name="view_company_scholarship_as_ojt"),

    path('administrator/company-profile/<int:company_id>/PDF', views.GeneratePDF.as_view(), name='generate_pdf'),
    path('administrator/company-profile/<int:company_id>/PDF2', views.GeneratePDF2.as_view(), name='generate_pdf'),
]
