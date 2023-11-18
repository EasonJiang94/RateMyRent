from django.shortcuts import render
from django.http import HttpResponse
from django.template import loader
from .models import Users
from .models import Salesman
from .models import Transactions
from django.db.models import Count

def housebook_app(request):
    # code below filters the list of salesman
    salesman_id=Salesman.objects.values_list('user_id')
    salesman_list=Users.objects.filter(user_id__in=salesman_id)
    # Return the salesman's names, email and transaction count. Order by transaction count ranking.
    # Only pick top 6 salesman
    salesman_transactions = (
    Salesman.objects
    .annotate(transaction_count=Count('transactions'))  # Count related transactions
    .order_by('-transaction_count')  # Order by count, descending (most first)
    .values(
        'user__first_name',  # Assuming User model has a field 'first_name'
        'user__last_name',   # Assuming User model has a field 'last_name'
        'user__user_email',  # Assuming User model has a field 'user_email'
        'transaction_count',
      )[:6]
    )
    # -------------------------
    template = loader.get_template('index.html')
    context = {
    'salesman_list': salesman_list,
    'salesman_transactions': salesman_transactions,
  }
    return HttpResponse(template.render(context, request))

def dashboard(request):
    template = loader.get_template('dashboard.html')
    return HttpResponse(template.render())
    