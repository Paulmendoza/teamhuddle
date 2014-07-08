from django.contrib.auth.models import User
from django.db.models.signals import post_save

# This will create a userprofile each time a user is saved if it is created. You can then use
# user.get_profile().whatever

class UserProfile(models.Model):  
    user = models.OneToOneField(User)  
    #other fields here

    def __str__(self):  
          return "%s's profile" % self.user  

    def create_user_profile(sender, instance, created, **kwargs):  
        if created:  
           profile, created = UserProfile.objects.get_or_create(user=instance)  

post_save.connect(create_user_profile, sender=User) 