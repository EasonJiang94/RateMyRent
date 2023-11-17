from django.shortcuts import render
from django.http import HttpResponse
from django.template import loader
from .models import Users
from .models import Salesman

def housebook_app(request):
    # code below filters the list of salesman
    salesman_id=Salesman.objects.values_list('user_id')
    salesman_list=Users.objects.filter(user_id__in=salesman_id)
    template = loader.get_template('index.html')
    context = {
    'salesman_list': salesman_list,
  }
    return HttpResponse(template.render(context, request))

def dashboard(request):
    template = loader.get_template('dashboard.html')
    return HttpResponse(template.render())
    