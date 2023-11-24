from django.shortcuts import get_object_or_404, render
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

    property_data = Property.objects.raw("""
        SELECT property_id,
               property_name,
               property_type,
               zipcode,
               city,
               state,
               image
        FROM property p1
        LEFT JOIN propertyItemImages p2 ON p1.property_id = p2.item_id
    """)
    
    return render(request, 'dashboard.html', { 'property_data': property_data })

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
    
def edit_property(request, property_id):

    property_data = Property.objects.get(property_id=property_id)

    if request.method == 'POST':
        property_data = Property(
            property_id=request.POST['property_id'],
            property_name=request.POST['property_name'],
            property_type=request.POST['property_type'],
            zipcode=request.POST['zipcode'],
            city=request.POST['city'],
            state=request.POST['state'],
        )
        property_data.save()  # Save the new Property to the database

        return redirect('dashboard')
    
    context = {
        'property':property_data,
    }
            
    return render(request, 'edit_property.html' , context)

 # property_data = Property.objects.raw("""
        #         SELECT property_id,
        #             property_name,
        #             property_type,
        #             zipcode,
        #             city,
        #             state,
        #             image
        #         FROM property p1
        #         JOIN propertyItemImages p2 ON p1.property_id = p2.item_id
        #         WHERE p1.property_id = %s """, [pty_id])