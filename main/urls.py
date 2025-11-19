from django.urls import path
from . import views

urlpatterns = [
    # We changed views.index to views.home to match your function
    path('', views.home, name='home'),
]