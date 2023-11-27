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
    property_items = Property.objects.prefetch_related(
        Prefetch(
            'propertyitem_set',
            queryset=Propertyitem.objects.prefetch_related('propertyitemimages_set'),
            to_attr='filtered_propertyitems'
        ),
        'propertyitem_set__address'
    ).all()[:3]


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

    # join Property, Propertyitem, Propertyitemimages
    # property_item_images = Propertyitemimages.objects.select_related('item__property').all()

    property_item_images = Propertyitemimages.objects.filter(item__item_id=argument).select_related('item__property')

    properties = Property.objects.prefetch_related(
        Prefetch(
            'propertyitem_set',
            queryset=Propertyitem.objects.filter(item_id=argument).prefetch_related('propertyitemimages_set'),
            to_attr='filtered_propertyitems'
        ),
        'propertyitem_set__address'
    ).all()

    context = {
        'property':p,
        'property_item':p_item,
        'property_address':p_address,
        'property_item_images':property_item_images,
        'properties':properties,
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
    #print(f"Item Id: {propertyitem_data.item_id}, Property ID: {propertyitem_data.property_id}, Address Id: {propertyitem_data.address_id}")

    property_data = Property.objects.get(property_id=property_id)
    propertyitem_data = Propertyitem.objects.get(property_id=property_id)
    propertyaddress_data =  Propertyaddress.objects.get(address_id=propertyitem_data.address_id)

    if request.method == 'POST':
        #print(request.POST.keys())
        property_data = Property(
            property_id=request.POST['property_id'],
            property_name=request.POST['property_name'],
            property_type=request.POST['property_type'],
            zipcode=request.POST['zipcode'],
            city=request.POST['city'],
            state=request.POST['state'],
        )
        property_data.save()  # Edit Property

        propertyitem_data = Propertyitem(
            item_id=request.POST['item_id'],
            property_id=request.POST['property_id'],
            address_id=request.POST['address_id'],
            item_type=request.POST['item_type'],
            capacity=request.POST['capacity'],
            item_bedroom=request.POST['item_bedroom'],
            item_bathroom=request.POST['item_bathroom'],
        )
        propertyitem_data.save()  # Edit Propertyitem

        propertyaddress_data = Propertyaddress(
            address_id=request.POST['address_id'],
            address1=request.POST['address1'],
            address2=request.POST['address2'],
            city=request.POST['city'],
            zipcode=request.POST['zipcode'],
            state=request.POST['state'],
        )
        propertyaddress_data.save()  # Edit Propertyaddress

        return redirect('dashboard')
    
    context = {
        'property': property_data,
        'propertyitem': propertyitem_data,
        'propertyaddress': propertyaddress_data,
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
    
def ourTeam(request):   
    team_list = Users.objects.raw('''select * from users u inner join administrator a on u.user_id=a.user_id left join userPhoto up on u.user_id=up.user_id where u.user_role=\'ADMIN\'''')
    #imgUrl=os.path.join(settings.MEDIA_URL, 'Users', photo)
    return render(request, 'ourTeam.html', { 'team_list': team_list })
    #return HttpResponse(template.render(context, request))

