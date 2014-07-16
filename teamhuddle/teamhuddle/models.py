from django.db import models
from django.contrib.auth.models import User
from allauth.account.models import EmailAddress
from allauth.socialaccount.models import SocialAccount
from django.db.models.signals import post_save
import hashlib



# This will create a userprofile each time a user is saved if it is created. You can then use
# user.get_profile().whatever

class UserProfile(models.Model):  
    user = models.OneToOneField(User)  
    #other fields here (samples for now)
    favorite_sport = models.CharField(max_length=20)

    def __str__(self):  
          return "%s's profile" % self.user  

    def account_verified(self):
        if self.user.is_authenticated:
            result = EmailAddress.objects.filter(email=self.user.email)
            if len(result):
                return result[0].verified
        return False

    def profile_image_url(self):
        fb_uid = SocialAccount.objects.filter(user_id=self.user.id, provider='facebook')
 
        if len(fb_uid):
            return "http://graph.facebook.com/{}/picture?width=40&height=40".format(fb_uid[0].uid)
 
        return "http://www.gravatar.com/avatar/{}?s=40".format(hashlib.md5(self.user.email).hexdigest())


# renames accessing a users profile to user.profile.something
User.profile = property(lambda u: UserProfile.objects.get_or_create(user=u)[0])