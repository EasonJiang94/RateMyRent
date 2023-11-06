from django.shortcuts import render
from django.http import HttpResponse

def housebook_app(request):
    return HttpResponse("Hello world!")