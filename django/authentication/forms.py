# -*- encoding: utf-8 -*-
"""
Copyright (c) 2019 - present AppSeed.us
"""

from django import forms
from django.contrib.auth.forms import UserCreationForm, UserChangeForm
from django.contrib.auth.models import User
from django.db.models import fields 
from django.forms import ModelForm
from .models import profile , userprofile, company
#from .import models

#----------------------------------------------------------------
# User
#----------------------------------------------------------------
#Create a profile form
class ProfileForm(ModelForm):
    class Meta:
        model = profile
        #fields= "__all__"
        fields = ('first_name', 'last_name', 'birthday', 'gender', 'email', 'phone', 'address', 'number', 'city', 'zipcode', 'position', 'role')

#Add profile form
class AddProfileForm(UserCreationForm):
    username = forms.CharField(
        widget=forms.TextInput(
            attrs={
                "placeholder" : "Username",                
                "class": "form-control"
            }
        ))
    first_name = forms.CharField(
        widget=forms.TextInput(
            attrs={
                "placeholder" : "First Name",                
                "class": "form-control"
            }
        ))
    last_name = forms.CharField(
        widget=forms.TextInput(
            attrs={
                "placeholder" : "Last Name",                
                "class": "form-control"
            }
        ))
    email = forms.EmailField(
        widget=forms.EmailInput(
            attrs={
                "placeholder" : "Email",                
                "class": "form-control"
            }
        ))
    password1 = forms.CharField(
        widget=forms.PasswordInput(
            attrs={
                "placeholder" : "Password",                
                "class": "form-control"
            }
        ))
    password2 = forms.CharField(
        widget=forms.PasswordInput(
            attrs={
                "placeholder" : "Password check",                
                "class": "form-control"
            }
        ))
    is_superuser = forms.BooleanField(initial=False,required=False, widget=forms.CheckboxInput(attrs={'onClick': 'myFunction();'}))
    is_staff = forms.BooleanField(initial=True)

    class Meta:
        model = User
        fields = ('username', 'first_name', 'last_name', 'email', 'password1', 'password2','is_superuser','is_staff')

#display profile
class DisplayProfileForm(UserChangeForm):
    username = forms.CharField( 
        widget= forms.TextInput(
            attrs={
                "class":"form-control"
                }
        ))
    first_name = forms.CharField( 
        widget= forms.TextInput(
            attrs={
                "class":"form-control"
                }
        ))
    last_name = forms.CharField(
        widget= forms.TextInput(
            attrs={
                "class":"form-control"
                }
        ))
    email = forms.EmailField(
        widget= forms.EmailInput(
            attrs={
                "class":"form-control"
                }
        ))
    username = forms.CharField(
        widget= forms.TextInput(
            attrs={
                "class":"form-control"
                }
        ))
    last_login = forms.CharField(
        widget= forms.TextInput(
            attrs={
                "class":"form-control"
                }
        ))
    date_joined = forms.CharField(
        widget= forms.TextInput(
            attrs={
                "class":"form-control"
                } 
            ))

    class Meta:
        model = User
        fields = ('username','first_name', 'last_name', 'email', 'last_login', 'date_joined')

#edit profile
class EditProfileForm(UserChangeForm):
    first_name = forms.CharField( 
        widget= forms.TextInput(
            attrs={
                "class":"form-control"
                }
        ))
    last_name = forms.CharField(
        widget= forms.TextInput(
            attrs={
                "class":"form-control"
                }
        ))
    email = forms.EmailField(
        widget= forms.EmailInput(
            attrs={
                "class":"form-control"
                }
        ))
    username = forms.CharField(
        widget= forms.TextInput(
            attrs={
                "class":"form-control"
                }
        ))
    is_superuser = forms.BooleanField(initial=False,required=False, widget=forms.CheckboxInput(attrs={'onClick': 'myFunction();'}))
    is_active = forms.BooleanField(initial=False,required=False)

    class Meta:
        model = User
        fields = ('username', 'first_name', 'last_name', 'email', 'is_superuser','is_active')

#----------------------------------------------------------------
# USER DETAILS
#----------------------------------------------------------------
class AddProfileDetailForm(forms.ModelForm):
    class Meta:
        model = userprofile
        fields = ('user','compName')

class EditProfileDetailForm(forms.ModelForm):
    class Meta:
        model = userprofile
        fields = ('user','compName')

#----------------------------------------------------------------
# COMPANY
#----------------------------------------------------------------
class EditCompanyForm(forms.ModelForm):
    class Meta:
        model = company
        fields = '__all__'

#----------------------------------------------------------------
# LOGIN
#----------------------------------------------------------------
class LoginForm(forms.Form):
    username = forms.CharField(
        widget=forms.TextInput(
            attrs={
                "placeholder" : "Username",                
                "class": "form-control"
            }
        ))
    password = forms.CharField(
        widget=forms.PasswordInput(
            attrs={
                "placeholder" : "Password",                
                "class": "form-control"
            }
        ))

