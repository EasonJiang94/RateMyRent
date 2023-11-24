from django.urls import path
from . import views
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('', views.housebook_app, name='housebook_home'),
    path('dashboard/', views.dashboard, name='dashboard'),
    path('edit_property/<int:property_id>/', views.edit_property, name='edit_property'),
]+ static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
