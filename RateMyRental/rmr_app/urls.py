from django.urls import path
from . import views

urlpatterns = [
    path('', views.rmr_app, name='rmr_home'),
]