from django.shortcuts import render
from django.http import HttpResponse
from django.template import loader
from .models import Users
from .models import Salesman
from .models import Property
from django.shortcuts import render, redirect
from django.http import HttpResponse

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

def add_property(request):
    if request.method == 'POST':
        new_property = Property(
            property_id=request.POST['property_id'],
            property_name=request.POST['property_name'],
            property_type=request.POST['property_type'],
            zipcode=request.POST['zipcode'],
            city=request.POST['city'],
            state=request.POST['state'],
        )
        new_property.save()  # Save the new Property to the database
        return redirect('dashboard')
    else:
        return render(request, 'add_property.html')

