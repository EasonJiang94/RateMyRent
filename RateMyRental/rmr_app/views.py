from django.shortcuts import render
from django.http import HttpResponse

def rmr_app(request):
    return HttpResponse("Hello world!")