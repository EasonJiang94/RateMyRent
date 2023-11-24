from django.shortcuts import get_object_or_404, render
from django.http import HttpResponse
from django.template import loader
from .models import Users
from .models import Salesman
from .models import Transactions
from .models import Property
from django.db.models import Count
from .models import Property
from django.shortcuts import render, redirect
from django.http import HttpResponse

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
