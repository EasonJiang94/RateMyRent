from django.shortcuts import render
from django.http import HttpResponse
from django.template import loader
from .models import Users
from .models import Salesman
from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.db.models import Count
<<<<<<< HEAD
from .forms import LoginForm
=======
from .models import Property
>>>>>>> dev

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
    template = loader.get_template('dashboard.html')
    return HttpResponse(template.render())
<<<<<<< HEAD
    
def login(request):
    template = loader.get_template('login.html')
    return HttpResponse(template.render())

def signup(request):
    template = loader.get_template('signup.html')
    return HttpResponse(template.render())
=======



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

>>>>>>> dev
