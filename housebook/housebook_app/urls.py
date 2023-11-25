from django.urls import path
from . import views
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('', views.housebook_app, name='housebook_home'),
    path('Dashboard/', views.dashboard, name='dashboard'),
    path('Login/', views.login, name='login'),
]+ static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)