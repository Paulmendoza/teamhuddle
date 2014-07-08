from django.http import request, HttpResponseRedirect
from django.shortcuts import render
from django.contrib.auth import authenticate

# renders login page (home page)
def index(request):
    return render(request, 'login.html')

def login(request):
    data = {}
    # TODO make secure(use forms?)
    user = authenticate(username=request.POST.__getitem__('username'), password=request.POST.__getitem__('password'))
    if user is not None:
        if user.is_active:
            # success
            # redirect
            
            return HttpResponseRedirect('/profile')
        else:
            # failure
            # disabled account message
            data['error'] = "Your account has been disabled"
            return render(request, 'login.html', data)
    else:
        # incorrect username and pass
        # reload with error message
        data['error'] = "Email and password combination incorrect"
        return render(request, 'login.html', data)

def profile(request):
    return render(request, 'profile.html')
    
    