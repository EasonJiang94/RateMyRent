from django.urls import path
from . import views
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('', views.housebook_app, name='housebook_home'),
    path('Dashboard/', views.dashboard, name='dashboard'),
<<<<<<< HEAD
    path('login/', views.login, name='login'),
    path('signup/', views.signup, name='signup'),
=======
    path('property_details/<int:argument>/', views.property_details, name='property_details'),
>>>>>>> dev
]+ static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)