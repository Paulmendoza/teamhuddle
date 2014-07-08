from django.conf.urls import patterns, include, url
from teamhuddle import views

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    # index
    url(r'^$', views.index, name='index'),

    # for login
    url(r'^login/$', views.login, name='login'),

    # django-allauth
    url(r'^accounts/', include('allauth.urls')),
)
