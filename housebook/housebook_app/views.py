from django.shortcuts import render
from django.http import HttpResponse
from django.template import loader
from .models import Users
from .models import Salesman
from .models import Transactions
from .models import Property
from django.db.models import Count
from .forms import LoginForm

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
    template = loader.get_template('dashboard.html')
    return HttpResponse(template.render())
    
def login(request):
    template = loader.get_template('login.html')
    return HttpResponse(template.render())

def signup(request):
    template = loader.get_template('signup.html')
    return HttpResponse(template.render())