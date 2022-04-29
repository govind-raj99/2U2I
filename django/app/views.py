# -*- encoding: utf-8 -*-
"""
Copyright (c) 2019 - present AppSeed.us
"""

from django.contrib.auth.decorators import login_required
from django.shortcuts import render, get_object_or_404, redirect
from django.template import loader
from django.http import HttpResponse
from django import template
import requests
import sys

@login_required(login_url="/login/")
def index(request):

    # tableauServer = "http://172.20.210.65:8080/"		#servername (e.g 'http://xxx/'  )
    # tableauUsername = request.user.username                          #"admin"	#user name (e.g. 'vijaytableau')  
    # #tableauUsername = "admin"	#user name (e.g. 'vijaytableau')  
    # workbookView = 'TollfreeDashboard/StoryCallerSample?:showAppBanner=false&:display_count=n&:showVizHome=n&:origin=viz_share_link&:embed=y' #'Superstore/Overview'
    # #statusTableau = ""
    
    # wgserverURL = tableauServer + 'trusted/'  
    # r = requests.post(wgserverURL, data={'username': tableauUsername})
    # #print("wgserverURL :",wgserverURL)
    # #print("username :",tableauUsername)
    # #print("ticketID :",r.text)
 
    # # status_code has the response code, text has the ticket string  
    # if r.status_code == 200:  
    #     if r.text != '-1':  
    #         ticketID = r.text  
    #         statusTableau = "SSO"
    #         #print("ticketID : ",ticketID)
    #     else:  
    #         ticketID = r.text  
    #         statusTableau = r.text
    #         #print("Tableau Server could not issue trusted ticket, for more information see \n")
    #         # print("ProgramData\Tableau\Tableau Server\data\tabsvc\logs\wgserver\production*.log and \n ...ProgramData\Tableau\")
    #         # print("Tableau Server\data\tabsvc\logs\vizqlserver\vizql*.log \nAlso check http://onlinehelp.tableau.com/current/server/en-us/trusted_auth_trouble_1return.htm")  
    #         #sys.exit()  
    # else:       
    #     print('Could not get trusted ticket with status code',str(r.status_code))  
    
    # url = wgserverURL + ticketID + '/views/' + workbookView
    # #print("statusTableau :",statusTableau)      
    # #print(url)      

    context = {}
    context['segment'] = 'index'
    #context={'segment':index,'tableauURL':url,'statusTableau':statusTableau,'ticketID':ticketID}

    # changes-YAN210306
    # remove the default landing page
    #html_template = loader.get_template( 'index.html' ) #original line
    html_template = loader.get_template( 'homepage.html' ) #210706 change line to make dashboard as landing page
   #html_template = loader.get_template( 'home.html' ) #the old one. changed on 18/1/22
    return HttpResponse(html_template.render(context, request))

@login_required(login_url="/login/")
def pages(request):
    context = {}
    # All resource paths end in .html.
    # Pick out the html file name from the url. And load that template.
    try:
        
        load_template      = request.path.split('/')[-1]
        context['segment'] = load_template
        
        html_template = loader.get_template( load_template )
        return HttpResponse(html_template.render(context, request))
        
    except template.TemplateDoesNotExist:

        html_template = loader.get_template( 'page-404.html' )
        return HttpResponse(html_template.render(context, request))

    except:
    
        html_template = loader.get_template( 'page-500.html' )
        return HttpResponse(html_template.render(context, request))
