from django.http import request, HttpResponseRedirect
from django.shortcuts import render
from django.contrib.auth import login as auth_login, logout as auth_logout
from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth.decorators import login_required

# renders login page (home page)
def index(request):
    if request.user.is_authenticated():
        return HttpResponseRedirect('/profile/')
    else:
        return render(request, 'login.html')

def login(request):
    data = {}
    if request.method == "POST":
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            auth_login(request, form.get_user())

            return HttpResponseRedirect('/profile/')
        else:
            # incorrect username and pass
            # reload with error message
            data['error'] = "Email and password combination incorrect"
            return render(request, 'login.html', data)

@login_required
def profile(request):
    data = {}
    data['user'] = request.user
    return render(request, 'profile.html', data)

@login_required
def logout(request):
    auth_logout(request)
    return HttpResponseRedirect('/') 
    
    