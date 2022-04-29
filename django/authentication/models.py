# -*- encoding: utf-8 -*-
"""
Copyright (c) 2019 - present AppSeed.us
"""
from core.settings import CORE_DIR
from django.db import models
from django.db import connections
from django.urls import reverse
from django.contrib.auth.models import AbstractBaseUser, User
from django.http import HttpRequest
from django.utils import timezone

# # Create your models here.
# class settings(models.Model):
#     pass

# Create your models here.
class company(models.Model):
    name        = models.CharField(max_length=250)
    code        = models.CharField(max_length=50, blank=True, null=True)
    address     = models.TextField(max_length=250, blank=True, null=True)
    poscode      = models.CharField(max_length=5, blank=True, null=True)
    state       = models.CharField(max_length=50, blank=True, null=True)

    def __str__(self):
       return self.name + ' [' + self.code +']'

    def get_absolute_url(self):
        return reverse('list_company')
        #return reverse('detail_company', args=(str(self.id)) )

class userprofile(models.Model):
    user    = models.OneToOneField(User, blank=True, null=True, on_delete=models.CASCADE)
    compName     = models.ForeignKey(company, blank=True, null=True, default=None, on_delete=models.CASCADE)

    def __str__(self):
       return str(self.user) + ' [' + str(self.compName) +']'

    def get_absolute_url(self):
        return reverse('list_company')
        #return reverse('detail_company', args=(str(self.id)) )

class profile(models.Model):
   first_name = models.CharField(max_length=30)
   last_name = models.CharField(max_length=30)
   birthday = models.CharField(max_length=30)
   gender = models.CharField(max_length=30)
   email = models.EmailField(max_length=30)
   phone = models.CharField(max_length=30)
   address = models.CharField(max_length=30)
   number = models.CharField(max_length=30)
   city = models.CharField(max_length=30)
   zipcode = models.CharField(max_length=30)
   position = models.CharField(max_length=30)
   role = models.CharField(max_length=30)

   def __str__(self):
       return self.first_name + ' ' + self.last_name

class tollfree(models.Model):
    startdatetime	= models.CharField('Start DateTime',max_length=50)
    tollfree	= models.CharField(max_length=12)
    answerpoint	= models.CharField(max_length=15)
    customer_name	= models.CharField(max_length=50)
    account_num	= models.CharField('Account Num',max_length=20)
    caller	= models.CharField(max_length=15)
    call_date	= models.CharField(max_length=30)
    call_time	= models.CharField(max_length=20)
    hr	= models.CharField(max_length=50)
    dy	= models.CharField(max_length=20)
    area	= models.CharField(max_length=50)
    state	= models.CharField(max_length=50)
    region	= models.CharField(max_length=50)
    calls	= models.IntegerField()
    callsless60sec	= models.IntegerField()
    duration	= models.IntegerField()
    dduration	= models.CharField(max_length=50)
    cost	= models.DecimalField(max_digits=8, decimal_places=2)
    busy	= models.IntegerField()
    no_answer	= models.IntegerField()
    other	= models.IntegerField()
    incomplete	= models.IntegerField()
    complete	= models.IntegerField()
    dur_range	= models.CharField(max_length=50)
    reason	= models.CharField(max_length=100,blank=True)
    hr_id	= models.IntegerField()
    state_id	= models.IntegerField()
    dur_range_id	= models.IntegerField()
    billing	= models.CharField(max_length=20)

    def __str__(self):
        return self.startdatetime + ' ' + self.account_num




