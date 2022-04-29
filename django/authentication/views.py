# -*- encoding: utf-8 -*-
"""
Copyright (c) 2019 - present AppSeed.us
"""
# Create your views here.
from django.conf import settings as conf_settings
from django.shortcuts import render, redirect , get_object_or_404
from django.contrib.auth import authenticate, login 
from django.contrib.auth.models import User
from django.db.models import Q
from .models import company , userprofile
from django.forms.utils import ErrorList
from django.http import HttpResponse, request , response , FileResponse
from django.urls.base import reverse
from .forms import LoginForm
from .forms import AddProfileForm, AddProfileDetailForm , ProfileForm, DisplayProfileForm, EditProfileForm
from .forms import EditProfileDetailForm, EditCompanyForm
import csv
import io
import os

#for edit profile
from django.views import generic
from django.contrib.auth.forms import UserChangeForm
from django.urls import reverse_lazy
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger

#model
#from authentication.models import profile
from .models import tollfree 

from django.template.loader import get_template
from xhtml2pdf import pisa
from django.views.generic import ListView

from reportlab.lib import pagesizes
from reportlab.pdfgen import canvas
from reportlab.lib.units import inch
from reportlab.lib.pagesizes import letter , landscape
LIST_PER_PAGE=5
#----------------------------------------------------------------
# DOWNLOAD MONTHLY REPORT
#----------------------------------------------------------------
def fileList(request):
    #path = os.path.dirname(os.path.abspath(__file__))               #C:\myDev\django\authentication
    #path="C:\\myDev\\django\core\\static\\PDFFile"  # insert the path to your directory
    #file_list = os.listdir(path)
    file_list = os.listdir(conf_settings.PDFFILES_DIRS)
    # files = [os.path.splitext(filename)[0] for filename in os.listdir(conf_settings.PDFFILES_DIRS)]
    # context = {{'pdfFileList': file_list}, {'pdfFilename': files},}
    return render(request, 'monthlyReport.html',{'pdfFileList': file_list})
    #return render_to_response('monthlyReport.html',{'pdfFileList': file_list})

#def home(request):
    #return render(request, 'home.html')

def dashboard(request):
    return render(request, 'dashboard.html')

def faq(request):
    return render(request, 'faq.html')

def homepage(request):
    return render(request, 'homepage.html')

def profile(request):
    user_list = User.objects.all()
    page = request.GET.get ('page', 1)

    paginator = Paginator(user_list, LIST_PER_PAGE)
    try:
        users = paginator.page(page)
    except PageNotAnInteger:
        users = paginator.page(1)
    except EmptyPage:
        users = paginator.page(paginator.num_pages)

    return render(request, 'profile/profile_list.html',{'users':users})
    # users = User.objects.all()
    # return render(request, 'profile/profile_list.html',{'users':users})

def UserSearchView(request, *args, **kwargs):
    search_query=" "
    if request.method == "GET" and request.GET:
        if 'q' in request.GET:
            if 'q' in request.GET:
                search_query = request.GET.get("q",' ')
                if len(search_query)>0 and search_query!=" ":
                    lookup = Q(email__icontains=search_query)|Q(username__contains=search_query)|Q(first_name__icontains=search_query)|Q(last_name__icontains=search_query)
                    users=User.objects.filter(lookup).distinct()
                else:
                    users = User.objects.all()
    else:
        users = User.objects.all()

    #Paginating
    page = request.GET.get ('page', 1)

    user_paginator = Paginator(users, LIST_PER_PAGE)
    try:
        users = user_paginator.page(page)
    except PageNotAnInteger:
        users = user_paginator.page(LIST_PER_PAGE)
    except EmptyPage:
        users = user_paginator.page(user_paginator.num_pages)

    context={'users':users,'query':search_query}

    return render(request, 'profile/profile_list.html', context)

# view profile
class UserViewView(generic.UpdateView):
    form_class = DisplayProfileForm
    template_name = 'profile/profile_view.html'
    success_url = reverse_lazy('home')

    def get_object(self):
        return self.request.user

# view profile
class UserDisplayView(generic.DetailView):
    model = User
    template_name = 'profile/profile_view.html'

# delete profile
class UserDeleteView(generic.DeleteView):
    model = User
    template_name = 'profile/profile_delete.html'
    success_url = reverse_lazy('list_profile')

# class UserAddView(generic.CreateView):
#     model = userprofile
#     template_name = 'profile/profile_addDetails.html'
#     fields = '__all__'

# add profile/user
#def UserRegisterView(request):
def UserAddView(request):

    msg     = None
    success = False

    if request.method == "POST":
        form = AddProfileForm(request.POST)
        form_details = AddProfileDetailForm(request.POST)
        if form.is_valid():
            fuser = form.save()
            fdetails = form_details.save(commit=False)
            username = form.cleaned_data.get("username")
            raw_password = form.cleaned_data.get("password1")
            user = authenticate(username=username, password=raw_password)

            fdetails.user = fuser
            fdetails.save()

            msg     = 'User created.'
            success = True
            
            return redirect("list_profile")

        else:
            msg = 'Form is not valid'    
    else:
        form = AddProfileForm()
        form_details = AddProfileDetailForm()

    return render(request, "profile/profile_add.html", {"form" : form, "form_details" : form_details, "msg" : msg, "success" : success })

# view profile
class UserEditView(generic.UpdateView):
    model = User
    form_class = EditProfileForm
    template_name = 'profile/profile_edit.html'
    success_url = reverse_lazy('list_profile')



def UserEditProfileView(request,pk):
    # if this is a POST request we need to process the form data

    user = User.objects.get(pk=pk)
    uprofile = userprofile.objects.get(user_id=pk)

    if request.method == 'POST':
        # create a form instance and populate it with data from the request:
        form_user = EditProfileForm(instance=user,data=request.POST)
        form_userprofile = EditProfileDetailForm(instance=uprofile,data=request.POST)
        
        # check whether it's valid:
        if form_user.is_valid()and form_userprofile.is_valid():
            pass #sebab tak edit full form {{form_user}} and {{form_company}}  
        else:
            # edit selected field sahaja
            # Save User model fields
            user.first_name = request.POST['first_name']
            user.last_name = request.POST['last_name']
            user.email = request.POST['email']
            is_superuser = request.POST.get('is_superuser', False)
            if (is_superuser == 'on') or (is_superuser == True):
                is_superuser = True
            else:
                is_superuser = False
            user.is_superuser = is_superuser
            is_active = request.POST.get('is_active', False)
            if (is_active == 'on') or (is_active == True):
                is_active = True
            else:
                is_active = False
            user.is_active = is_active
            user.save()

            # Save Employee model fields
            # currently this part return error before form submit
            # we validate the company name as compulsory
            compNameID = request.POST['compName']
            if compNameID == '':
                compNameID = None
            uprofile.compName = company.objects.get(pk=compNameID)
            uprofile.save() 

            # redirect to the index page
            return redirect("list_profile")

    # if a GET (or any other method) we'll create a blank form
    else:
        form_user = EditProfileForm(instance=user)
        form_userprofile = EditProfileDetailForm(instance=uprofile)

    return render(request, "profile/profile_edit.html", {'form_user': form_user, 'form_userprofile': form_userprofile})


    #admin log

    

    




#----------------------------------------------------------------
# COMPANY
#----------------------------------------------------------------
def CompanySearchView(request, *args, **kwargs):
    search_query=" "
    if request.method == "GET" and request.GET:
        if 'q' in request.GET:
            if 'q' in request.GET:
                search_query = request.GET.get("q",' ')
                if len(search_query)>0 and search_query!=" ":
                    lookup = Q(name__icontains=search_query)|Q(code__icontains=search_query)|Q(address__icontains=search_query)|Q(state__icontains=search_query)
                    comps = company.objects.filter(lookup).distinct()
                else:
                    comps = company.objects.all()
    else:
        comps = company.objects.all()

    #Paginating
    page = request.GET.get ('page', 1)

    comp_paginator = Paginator(comps, LIST_PER_PAGE)
    try:
        comps = comp_paginator.page(page)
    except PageNotAnInteger:
        comps = comp_paginator.page(LIST_PER_PAGE)
    except EmptyPage:
        comps = comp_paginator.page(comp_paginator.num_pages)

    context={'comps':comps,'query':search_query}

    return render(request, 'profile/company_list.html', context)

#List of Company
class CompanyListView(generic.ListView):
    model = company
    template_name = "profile/company_list.html"

# edit company profile
class CompanyEditView(generic.UpdateView):
    model = company
    form_class = EditCompanyForm
    template_name = 'profile/company_edit.html'
    success_url = reverse_lazy('list_company')

# display profile
class CompanyDisplayView(generic.DetailView):
    model = company
    template_name = 'profile/company_view.html'

class CompanyAddView(generic.CreateView):
    model = company
    template_name = 'profile/company_add.html'
    fields = '__all__'

# view profile
class CompanyDeleteView(generic.DeleteView):
    model = company
    template_name = 'profile/company_delete.html'
    success_url = reverse_lazy('list_company')


#----------------------------------------------------------------
# LOGIN
#----------------------------------------------------------------
def login_view(request):
    form = LoginForm(request.POST or None)

    msg = None

    if request.method == "POST":

        if form.is_valid():
            username = form.cleaned_data.get("username")
            password = form.cleaned_data.get("password")
            user = authenticate(username=username, password=password)
            if user is not None:
                login(request, user)
                return redirect("/")
            else:    
                msg = 'Invalid credentials'    
        else:
            msg = 'Error validating the form'    

    return render(request, "accounts/login.html", {"form": form, "msg" : msg})


#----------------------------------------------------------------
# GENERATE FILE
#----------------------------------------------------------------
def display(request):
	data_List=tollfree.objects.all() # Collect all records from table 
	return render(request,'subMeu/05Download_monthlyReport.html',{'data_List':data_List})

#generate pdf file
def tollfree_pdffile(request):
    #create bytestream buffer
    buf = io.BytesIO()
    #create a canvas
    c = canvas.Canvas(buf, pagesize=landscape(letter), bottomup=0)
    #create a text object
    textobj = c.beginText()
    textobj.setTextOrigin(inch,inch)
    textobj.setFont("Helvetica",10)

    #add some line of text
    #lines = ["line 1","Line 3"]
    tfobject = tollfree.objects.all()
    #lines = ["This is line 1\n","This is line 3\n"]
    lines = []
    for tfrow in tfobject:
        lines.append(tfrow.startdatetime)
        lines.append(tfrow.tollfree)
        lines.append(tfrow.answerpoint)
        lines.append(tfrow.customer_name)
        lines.append("")

    #Loop
    for tfLine in lines:
        textobj.textLine(tfLine)

    #Finish up
    c.drawText(textobj)
    c.showPage()
    c.save()
    buf.seek(0)

    # Return something
    return FileResponse(buf, as_attachment=True, filename='tollfree.pdf')

#generate text file
def tollfree_csvfile(request):
    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition']='attachment; filename=tollfree.csv'

    #Create a csv writer
    writer = csv.writer(response)

    #Designate the model
    tfobject = tollfree.objects.all()

    #Add column headings to the csv file
    writer.writerow(['startdatetime','tollfree','answerpoint','customer_name','account_num','caller','call_date','call_time','hr','dy','area','state','region','calls','calls<60sec','duration','dduration','cost','busy','no_answer','other','incomplete','complete','dur_range','reason','hr_id','state_id','dur_range_id','billing'])

    #Loop the output
    lines = []
    for tfrow in tfobject:
        writer.writerow([tfrow.startdatetime,tfrow.tollfree,tfrow.answerpoint,tfrow.customer_name,tfrow.account_num,tfrow.caller,tfrow.call_date,tfrow.call_time,tfrow.hr,tfrow.dy,tfrow.area,tfrow.state,tfrow.region,tfrow.calls,tfrow.callsless60sec,tfrow.duration,tfrow.dduration,tfrow.cost,tfrow.busy,tfrow.no_answer,tfrow.other,tfrow.incomplete,tfrow.complete,tfrow.dur_range,tfrow.reason,tfrow.hr_id,tfrow.state_id, tfrow.dur_range_id, tfrow.billing])

    return response

#generate text file
def tollfree_textfile(request):
    response = HttpResponse(content_type='text/plain')
    response['Content-Disposition']='attachment; filename=tollfree.txt'
    #Designate the model
    tfobject = tollfree.objects.all()
    #lines = ["This is line 1\n","This is line 3\n"]
    lines = []
    #Add column headings to the csv file
    lines.append(f'startdatetime,tollfree,answerpoint,customer_name,account_num,caller,call_date,call_time,hr,dy,area,ustate,region,calls,calls<60sec,duration,dduration,cost,busy,no_answer,other,incomplete,complete,dur_range,reason,hr_id,state_id,dur_range_id,billing\n')
    for tfrow in tfobject:
        lines.append(f'{tfrow.startdatetime},{tfrow.tollfree},{tfrow.answerpoint},{tfrow.customer_name},{tfrow.account_num},{tfrow.caller},{tfrow.call_date},{tfrow.call_time},{tfrow.hr},{tfrow.dy},{tfrow.area},{tfrow.state},{tfrow.region},{tfrow.calls},{tfrow.callsless60sec},{tfrow.duration},{tfrow.dduration},{tfrow.cost},{tfrow.busy},{tfrow.no_answer},{tfrow.other},{tfrow.incomplete},{tfrow.complete},{tfrow.dur_range},{tfrow.reason},{tfrow.hr_id},{tfrow.state_id}, {tfrow.dur_range_id}, {tfrow.billing}\n')

    #write to textfile
    response.writelines(lines)
    return response

class tollFreeListView(ListView):
    model = tollfree
    template_name = 'subMenu/05Download_monthlyReportPDF.html'

def tollfree_render_pdf_view(request, *args, **kwargs):
    pk=kwargs.get('pk')
    tfDetails = get_object_or_404(tollfree, pk=pk)
    template_path = 'subMenu/05Download_monthlyReportPDFDetails.html'
    context = {'tfDetails': tfDetails}
    # Create a Django response object, and specify content_type as pdf
    response = HttpResponse(content_type='application/pdf')
    #if download
    # response['Content-Disposition'] = 'attachment; filename="report.pdf"'
    #if display pdf
    response['Content-Disposition'] = 'filename="report.pdf"'
    # find the template and render it.
    template = get_template(template_path)
    html = template.render(context)

    # create a pdf
    pisa_status = pisa.CreatePDF(
       html, dest=response)     #, link_callback=link_callback)
    # if error then show some funy view
    if pisa_status.err:
       return HttpResponse('We had some errors <pre>' + html + '</pre>')
    return response
#   return HttpResponse("working")

def render_pdf_view(request):
    template_path = '05Download_monthlyReportPDF.html'
    context = {'myvar': tollfree}
    # Create a Django response object, and specify content_type as pdf
    response = HttpResponse(content_type='application/pdf')
    #if download
    # response['Content-Disposition'] = 'attachment; filename="report.pdf"'
    #if display pdf
    response['Content-Disposition'] = 'filename="report.pdf"'
    # find the template and render it.
    template = get_template(template_path)
    html = template.render(context)

    # create a pdf
    pisa_status = pisa.CreatePDF(
       html, dest=response)     #, link_callback=link_callback)
    # if error then show some funy view
    if pisa_status.err:
       return HttpResponse('We had some errors <pre>' + html + '</pre>')
    return response

    

#----------------------------------------------------------------
# ORIGINAL SUBMENU
#----------------------------------------------------------------
def home_view(request):
    context = {'form': 'form',}
    return render(request, 'subMenu/home.html',context)

def mrktg_calldis(request):
    return render(request, 'subMenu/02Marketing_callDis.html')

def oprt_shortcall(request):
    return render(request, 'subMenu/03Operation_shortCall.html')

def oprt_timeofday(request):
    return render(request, 'subMenu/03Operation_timeOfDay.html')

def custserv_answsum(request):
    return render(request, 'subMenu/04CustomerService_answerpointSum.html')

def custserv_misscal(request):
    return render(request, 'subMenu/04CustomerService_missedCall.html')

def custserv_missopp(request):
    return render(request, 'subMenu/04CustomerService_missedOpp.html')
 
def custserv_topview(request):
    return render(request, 'subMenu/04CustomerService_topView.html')

def dwnld_report(request):
    return render(request, 'subMenu/05Download_monthlyReport.html')



def downloadAdhoc(request):
    data_table = request.POST.get('data_table')
    tollfree_num = request.POST.get('tollfree_num')
    from_date = request.POST.get('from_date')
    end_date = request.POST.get('end_date')
   # print("the data table ticcked is: ",data_table)
   # print("the tollfree number is: ",tollfree_num)
   # print("the from date is: ",from_date)
   # print("the end date is: ",end_date)

    context = {}
    context = {'data_table':data_table, 'tollfree_num':tollfree_num, 'from_date':from_date, 'end_date':end_date}
    context_str = str(context)
    
    # call adhoc_function to pass the data and to execute the pthon file to generate csv
    output = adhoc_function(context_str) 
    return render(request, 'downloadAdhoc.html', {
        'context': context,
        'output': output,
      })

    #output = run([sys.executable, 'Adhoc_Excel_Report.py', context], shell=False, stdout=PIPE)
    #return render(request, 'downloadAdhoc.html', context)

def adhoc_function(form_data):
    print(form_data) #just to test the data is successfully passed
    return subprocess.check_call(['adhoc_excel.py', form_data])

def MonthlyReportDetail(request,pk):
    comps = company.objects.get(pk=pk)
    file_list = os.listdir(conf_settings.PDFFILES_DIRS)

    return render(request, "monthlyReport_detail-l5.html", {'company':comps, 'pdfFileList':file_list})

def fileList(request, pk):        
    file_list = os.listdir(conf_settings.PDFFILES_DIRS)
    comps = company.objects.all()
    
    users = User.objects.get(pk=pk)
    accnumdetails = accnum_details.objects.filter( userDetails_email_contains=users.email )
    
    return render(request, 'monthlyReport2.html',{'pdfFileList': file_list, 'comps':comps, 'accnumdetails':accnumdetails})