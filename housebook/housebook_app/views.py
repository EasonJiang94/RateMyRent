from django.shortcuts import render
from django.http import HttpResponse
from django.db.models import F
from django.db.models import Subquery
from django.template import loader
from .models import Users
from .models import Salesman
from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.db.models import Count
from .models import Property
from .models import Propertyaddress
from .models import Propertyitem
from .models import Propertyitemimages

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

