from django.urls import path
from . import views

urlpatterns = [
    path('', views.housebook_app, name='housebook_home'),
]