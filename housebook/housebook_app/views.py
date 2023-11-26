from audioop import reverse
from django.shortcuts import get_object_or_404, render, redirect
from django.http import HttpResponse
from django.template import loader
from django.db.models import Count, Prefetch
from .models import Propertyitem, Propertyitemfeatures2, Propertyitemimages, Propertyitemlabel, Propertyitempayment, Users, Property, Transactions, Salesman
from django.db import transaction

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
    
    # Retrieve property info
    property_basic_info=Property.objects.all()[:3]

    template = loader.get_template('index.html')
    context = {
    'salesman_transactions': salesman_transactions,
    'property_basic_info':property_basic_info,
  }
    return HttpResponse(template.render(context, request))

def property_details(request, argument):
    # receive argument from template
    # find a property that fit property_id=argument from template
    p = Property.objects.get(property_id=argument)

    context = {
        'property':p,
    }
    
    return render(request, 'property_details.html', context)


def dashboard(request):

    #property_data = Property.objects.select_related('itme_id')

    properties = Property.objects.prefetch_related(
        Prefetch(
            'propertyitem_set',
            queryset=Propertyitem.objects.prefetch_related('propertyitemimages_set')
        ),
        'propertyitem_set__address'
    ).all()

    for property in properties:
        print(f"Property Id: {property.property_id}, Property Name: {property.property_name}, Type: {property.property_type}")
        for item in property.propertyitem_set.all():
            print(f"  Item Type: {item.item_type}, Bedrooms: {item.item_bedroom}, Bathrooms: {item.item_bathroom}")
            print(f"  Address: {item.address.address1}, {item.address.city}")
            for image in item.propertyitemimages_set.all():
                print(f"    Image ID: {image.image_id}, Image Path: {image.image}")

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