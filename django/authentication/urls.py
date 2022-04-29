# -*- encoding: utf-8 -*-
"""
Copyright (c) 2019 - present AppSeed.us
"""

from django.urls import include, path
from .views import login_view, UserAddView , UserDisplayView, UserViewView, UserEditView ,UserEditProfileView, UserDeleteView #, UserRegisterView
from .views import tollfree_render_pdf_view , tollFreeListView , home_view
from .views import CompanyListView , CompanyEditView , CompanyDisplayView , CompanyAddView, CompanyDeleteView
# , mrktg_calldis , oprt_shortcall , oprt_timeofday , custserv_answsum , 
# custserv_misscal , custserv_missopp , custserv_topview , dwnld_report , settings #password_reset_request
from django.contrib.auth.views import LogoutView
from django.contrib.auth import views as auth_views
from . import views

tf_patterns = ([
     path('<pk>/', tollfree_render_pdf_view, name='tollfree-pdf-view'),
], 'tollfree')


urlpatterns = [
    #path('forgot-password/', password_reset_request, name="forgotpassword"),
    #path("home/", home_view, name="home"),
    path('login/', login_view, name="login"),
    path("logout/", LogoutView.as_view(), name="logout"),

    #path("info", views.info, name="info"),
    #path("home", views.home, name="home"),
    path("dashboard", views.dashboard, name="dashboard"),
    path("download/monthlyreport", views.fileList, name="monthlyReport"),
    path("faq", views.faq, name="faq"),
    path("homepage", views.homepage, name="homepage"),
    path("downloadAdhoc", views.downloadAdhoc, name="downloadAdhoc"),
    path("monthlyReport_detail", views.MonthlyReportDetail, name="MonthlyReportDetail"),

    #path("company/list", CompanyListView.as_view(), name="list_company"),
    path("company/list", views.CompanySearchView, name="list_company"),
    path("company/detail/<int:pk>", CompanyDisplayView.as_view(), name="detail_company"),
    path('company/add', CompanyAddView.as_view(), name="add_company"),
    path("company/edit/<int:pk>", CompanyEditView.as_view(), name="edit_company"),
    path("company/delete/<int:pk>", CompanyDeleteView.as_view(), name="delete_company"),

    #path("profile/list", views.UserSearchView, name="settings"),
    path("profile/list", views.UserSearchView, name="list_profile"),
    #path('profile/add', UserAddView, name="register"),
    path('profile/add', UserAddView, name="add_profile"),
    #path('profile/add', UserAddView.as_view(), name="add_profile"),
    path("profile/view", UserViewView.as_view(), name="view_profile"),
    path("profile/detail/<int:pk>", UserDisplayView.as_view(), name="detail_profile"),
    #path("profile/edit/<int:pk>", UserEditView.as_view(), name="edit_profile"),
    path('profile/edit/<int:pk>', UserEditProfileView, name="edit_profile"),
    path("profile/delete/<int:pk>", UserDeleteView.as_view(), name="delete_profile"),
    
    path('password_change/done/', auth_views.PasswordChangeDoneView.as_view(template_name='registration/password_change_done.html'), name='password_change_done'),
    path('password_change/', auth_views.PasswordChangeView.as_view(template_name='registration/password_change.html'), name='password_change'),
    path('password_reset/done/', auth_views.PasswordResetCompleteView.as_view(template_name='accounts/password_reset_done.html'), name='password_reset_done'),
    path('reset/<uidb64>/<token>/', auth_views.PasswordResetConfirmView.as_view(), name='password_reset_confirm'),
    path('password_reset/', auth_views.PasswordResetView.as_view(template_name='accounts/password_reset_form.html'), name='password_reset'),
    path('reset/done/', auth_views.PasswordResetCompleteView.as_view(template_name='accounts/password_reset_complete.html'), name='password_reset_complete'),

 #   path("testpdf/", render_pdf_view, name="test-pdf"),
    path("testdisplay/", tollFreeListView.as_view(), name="test-view"),
    path("testpdf/", include(tf_patterns)),
    path("textfile", views.tollfree_textfile, name="testtextfile"),
    path("csvfile", views.tollfree_csvfile, name="testcsvfile"),
    path("pdffile", views.tollfree_pdffile, name="testpdffile"),

    path("marketing/calldistribution", views.mrktg_calldis, name="callDis"),
    path("operations/shortcall", views.oprt_shortcall, name="shortCall"),
    path("operations/timeofdaychart", views.oprt_timeofday, name="timeOfDay"),
    path("customerservices/answerpointsummary", views.custserv_answsum, name="answerpointSum"),
    path("customerservices/missedcall", views.custserv_misscal, name="missedCall"),
    path("customerservices/missedopportunities", views.custserv_missopp, name="missedOpp"),
    path("customerservices/topview", views.custserv_topview, name="topView"),

 
]
