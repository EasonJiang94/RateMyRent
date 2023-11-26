from audioop import reverse
from django.shortcuts import get_object_or_404, render, redirect
from django.http import HttpResponse
from django.db.models import F
from django.db.models import Subquery
from django.template import loader
from .models import Users
from .models import Salesman
from .models import Propertyaddress
from .models import Propertyitem
from .models import Propertyitemimages
from .models import Property, Propertyitem, Propertyitemfeatures2, Propertyitemimages, Propertyitemlabel, Propertyitempayment, Property, Transactions
from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.db.models import Count
from .forms import LoginForm
from .models import Property
from django.db.models import Count, Prefetch
from django.db import transaction
import time
def housebook_app(request):
    # Return the salesman's names, email and transaction count. Order by transaction count.
    # Only pick top 6 salesman
    salesman_transactions = (
    Salesman.objects
    .annotate(transaction_count=Count('transactions'))  # Count related transactions
    .order_by('-transaction_count')  # Order by count, descending (most first)
    .values(
        'user__first_name',  
        'user__last_name',   
        'user__user_email',  
        'transaction_count',
      )[:6]
    )
    
    # Retrieve table that Property inner join Propertyitem
    property_items = Propertyitem.objects.select_related('property').all()[:3]

    template = loader.get_template('index.html')
    context = {
    'salesman_transactions': salesman_transactions,
    'property_items':property_items,
  }
    return HttpResponse(template.render(context, request))

def property_details(request, argument):
    # receive argument from template
    # find a property that fit property_id=argument from template
    p = Property.objects.get(property_id=argument)

    # get property item & property address
    p_item = Propertyitem.objects.get(property=argument)
    p_address = Propertyaddress.objects.get(address_id=argument)

    # get propertyitem's item_id
    item_ids = Propertyitem.objects.filter(property__property_id=F('property')).values_list('item_id', flat=True)

    # get Propertyitemimages
    # First, we create a queryset for the subquery
    subquery = Propertyitem.objects.filter(
        property__property_id=F('property')  # This assumes `property` is a ForeignKey to Property
    ).values('item_id')
    # Now, we use that subquery within the __in lookup for the main query
    property_item_images = Propertyitemimages.objects.filter(
        item_id__in=Subquery(subquery)
    )

    context = {
        'property':p,
        'property_item':p_item,
        'property_address':p_address,
        'property_item_images':property_item_images,
    }
    
    return render(request, 'property_details.html', context)

    
def login(request):
    template = loader.get_template('login.html')
    return HttpResponse(template.render())

def signup(request):
    template = loader.get_template('signup.html')
    return HttpResponse(template.render())


def dashboard(request):
    #property_data = Property.objects.select_related('itme_id')

    properties = Property.objects.prefetch_related(
        Prefetch(
            'propertyitem_set',
            queryset=Propertyitem.objects.prefetch_related('propertyitemimages_set')
        ),
        'propertyitem_set__address'
    ).all()
    time.sleep(0.001) # wait for the sql database loading
    # for property in properties:
    #     print(f"Property Id: {property.property_id}, Property Name: {property.property_name}, Type: {property.property_type}")
    #     for item in property.propertyitem_set.all():
    #         print(f"  Item Type: {item.item_type}, Bedrooms: {item.item_bedroom}, Bathrooms: {item.item_bathroom}")
    #         print(f"  Address: {item.address.address1}, {item.address.city}")
    #         for image in item.propertyitemimages_set.all():
    #             print(f"    Image ID: {image.image_id}, Image Path: {image.image}")

    context = {
        'properties': properties,
    }
    
    return render(request, 'dashboard.html', context)



def add_property(request):
    if request.method == 'POST':
        add_property = Property(
            property_id=request.POST['property_id'],
            property_name=request.POST['property_name'],
            property_type=request.POST['property_type'],
            zipcode=request.POST['zipcode'],
            city=request.POST['city'],
            state=request.POST['state'],
        )
        add_property.save()  # Save the new Property to the database
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

def delete_property(request, property_id):
    if request.method == "POST":
        with transaction.atomic():
            # Retrieve the property
            property_to_delete = get_object_or_404(Property, property_id=property_id)

            # Retrieve all related PropertyItem records
            property_items = Propertyitem.objects.filter(property_id=property_id)

            # For each PropertyItem, delete related records in other tables
            for item in property_items:
                Propertyitemfeatures2.objects.filter(item_id=item.item_id).delete()
                Propertyitemimages.objects.filter(item_id=item.item_id).delete()
                Propertyitemlabel.objects.filter(item_id=item.item_id).delete()
                Propertyitempayment.objects.filter(item_id=item.item_id).delete()
                item.delete()  # Delete the PropertyItem itself

            # Finally, delete the Property
            property_to_delete.delete()


        return redirect(reverse('dashboard'))  # Redirect to the list of properties
