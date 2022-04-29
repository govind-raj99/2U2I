# -*- encoding: utf-8 -*-
"""
Copyright (c) 2019 - present AppSeed.us
"""

from django.contrib import admin
from .models import tollfree
#from .models import profile
from .models import company
from .models import userprofile

# Register your models here.
admin.site.register(tollfree)
admin.site.register(userprofile)
admin.site.register(company)


