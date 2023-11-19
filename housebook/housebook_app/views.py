from django.shortcuts import render
from django.http import HttpResponse
from django.template import loader
from .models import Users
from .models import Salesman

def housebook_app(request):
    # code below filters the list of salesman
    salesman_id=Salesman.objects.values_list('user_id')
    salesman_list=Users.objects.filter(user_id__in=salesman_id)
    template = loader.get_template('index.html')
    context = {
    'salesman_list': salesman_list,
  }
    return HttpResponse(template.render(context, request))

def ourTeam(request):
   # salesman_id=Salesman.objects.values_list('user_id')
   # salesman_list=Users.objects.filter(user_id__in=salesman_id)
   # template=loader.get_template('ourTeam.html')
   # context = { 'salesman_list': salesman_list,}
    team_list = Users.objects.raw('''select * from users u inner join administrator a on u.user_id=a.user_id left join userPhoto up on u.user_id=up.user_id where u.user_role=\'ADMIN\'''')
    #imgUrl=os.path.join(settings.MEDIA_URL, 'Users', photo)
    return render(request, 'ourTeam.html', { 'team_list': team_list })
    #return HttpResponse(template.render(context, request))

