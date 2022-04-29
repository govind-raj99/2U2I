from os import replace
from django import template
import datetime


register = template.Library()

@register.simple_tag(name='minustwo')
def minustwo(value):
    return ((value) - 2)


@register.simple_tag(name='minusone')
def minusone(value):
    return ((value) - 1)

import calendar

@register.filter
def month_name(month_number):
    return calendar.month_name[month_number]

@register.simple_tag(name='monthToNum')
def monthToNum(shortMonth):
    return {
            'jan': 1,
            'feb': 2,
            'mar': 3,
            'apr': 4,
            'may': 5,
            'jun': 6,
            'jul': 7,
            'aug': 8,
            'sep': 9, 
            'oct': 10,
            'nov': 11,
            'dec': 12
    }[shortMonth]

@register.filter(name='cutfilename')
def cutfilename(value, arg):
    return value.replace(arg, '')

@register.filter(name='get_len')
def get_len(value):
    return value.replace('.pdf','')

@register.filter(name='get_length')
def get_length(value):
    return len(value)
