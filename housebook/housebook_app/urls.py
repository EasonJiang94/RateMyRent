from django.urls import path
from . import views
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('', views.housebook_app, name='housebook_home'),
<<<<<<< HEAD
    path('dashboard/', views.dashboard, name='dashboard'),
=======
    path('Dashboard/', views.dashboard, name='dashboard'),
>>>>>>> dev
    path('login/', views.login, name='login'),
    path('signup/', views.signup, name='signup'),
    path('property_details/<int:argument>/', views.property_details, name='property_details'),
    path('edit_property/<int:property_id>/', views.edit_property, name='edit_property'),
    path('delete_property/<int:property_id>/', views.delete_property, name='delete_property'),
]+ static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
