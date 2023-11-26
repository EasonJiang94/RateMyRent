from django.urls import path
from . import views
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('', views.housebook_app, name='housebook_home'),
    path('Dashboard/', views.dashboard, name='dashboard'),
    path('property_details/<int:argument>/', views.property_details, name='property_details'),
]+ static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)