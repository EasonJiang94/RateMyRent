from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.utils import timezone
# Create your models here.
class Label(models.Model):
    label_id = models.IntegerField(primary_key=True)
    label = models.CharField(max_length=50, blank=True, null=True)
    label_description = models.CharField(max_length=50, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Label'


class Test(models.Model):
    test_id = models.CharField(primary_key=True, max_length=20)
    test_text = models.CharField(max_length=30)

    class Meta:
        managed = False
        db_table = 'Test'


class Agent(models.Model):
    agent_id = models.IntegerField(primary_key=True)
    user = models.ForeignKey('Users', models.DO_NOTHING, blank=True, null=True)
    create_datetime = models.DateTimeField(blank=True, null=True)
    delete_datetime = models.DateTimeField(blank=True, null=True)
    is_delete = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'agent'


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class Buyer(models.Model):
    buyer_id = models.IntegerField(primary_key=True)  # The composite primary key (buyer_id, user_id) found, that is not supported. The first column is selected.
    user = models.ForeignKey('Users', models.DO_NOTHING)
    create_datetime = models.DateTimeField(blank=True, null=True)
    delete_datetime = models.DateTimeField(blank=True, null=True)
    is_delete = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'buyer'
        unique_together = (('buyer_id', 'user'),)


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.PositiveSmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    id = models.BigAutoField(primary_key=True)
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class Property(models.Model):
    property_id = models.IntegerField(primary_key=True)
    property_name = models.CharField(max_length=30, blank=True, null=True)
    property_type = models.CharField(max_length=30, blank=True, null=True)
    zipcode = models.IntegerField(blank=True, null=True)
    city = models.CharField(max_length=30, blank=True, null=True)
    state = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'property'


class Propertyaddress(models.Model):
    address_id = models.IntegerField(primary_key=True)
    address1 = models.CharField(max_length=50, blank=True, null=True)
    address2 = models.CharField(max_length=50, blank=True, null=True)
    city = models.CharField(max_length=30, blank=True, null=True)
    state = models.CharField(max_length=10, blank=True, null=True)
    zipcode = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'propertyAddress'


class Propertyitem(models.Model):
    item_id = models.IntegerField(primary_key=True)
    property = models.ForeignKey(Property, models.DO_NOTHING)
    address = models.ForeignKey(Propertyaddress, models.DO_NOTHING)
    item_type = models.CharField(max_length=50, blank=True, null=True)
    capacity = models.IntegerField(blank=True, null=True)
    item_bedroom = models.FloatField(blank=True, null=True)
    item_bathroom = models.FloatField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'propertyItem'


class Propertyitemfeatures2(models.Model):
    feature_id = models.IntegerField(primary_key=True)  # The composite primary key (feature_id, item_id) found, that is not supported. The first column is selected.
    item = models.ForeignKey(Propertyitem, models.DO_NOTHING)
    featutre_type = models.CharField(max_length=50, blank=True, null=True)
    feature_name = models.CharField(max_length=50, blank=True, null=True)
    feature_value = models.CharField(max_length=50, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'propertyItemFeatures2'
        unique_together = (('feature_id', 'item'),)


class Propertyitemimages(models.Model):
    item = models.ForeignKey(Propertyitem, models.DO_NOTHING, blank=True, null=True)
    image_id = models.IntegerField(primary_key=True)
    image = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'propertyItemImages'


class Propertyitemlabel(models.Model):
    item = models.ForeignKey(Propertyitem, models.DO_NOTHING)
    label = models.OneToOneField(Label, models.DO_NOTHING, primary_key=True)  # The composite primary key (label_id, item_id) found, that is not supported. The first column is selected.

    class Meta:
        managed = False
        db_table = 'propertyItemLabel'
        unique_together = (('label', 'item'),)


class Propertyitempayment(models.Model):
    item = models.OneToOneField(Propertyitem, models.DO_NOTHING, primary_key=True)  # The composite primary key (item_id, payment_id) found, that is not supported. The first column is selected.
    payment_id = models.IntegerField()
    payment_name = models.CharField(max_length=50)
    payment_amount = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'propertyItemPayment'
        unique_together = (('item', 'payment_id'),)


class Salesman(models.Model):
    salesman_id = models.IntegerField(primary_key=True)  # The composite primary key (salesman_id, user_id) found, that is not supported. The first column is selected.
    user = models.ForeignKey('Users', models.DO_NOTHING)
    agent = models.ForeignKey(Agent, models.DO_NOTHING, blank=True, null=True)
    store = models.ForeignKey('Store', models.DO_NOTHING, blank=True, null=True)
    create_datetime = models.DateTimeField(blank=True, null=True)
    delete_datetime = models.DateTimeField(blank=True, null=True)
    is_delete = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'salesman'
        unique_together = (('salesman_id', 'user'),)


class Store(models.Model):
    store_id = models.IntegerField(primary_key=True)
    store_name = models.CharField(max_length=30, blank=True, null=True)
    store_region = models.CharField(max_length=30, blank=True, null=True)
    agent = models.ForeignKey(Agent, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'store'


class Transactions(models.Model):
    transaction_id = models.IntegerField(primary_key=True)
    buyer = models.ForeignKey(Buyer, models.DO_NOTHING)
    salesman = models.ForeignKey(Salesman, models.DO_NOTHING)
    propertyitem = models.ForeignKey(Propertyitem, models.DO_NOTHING, db_column='propertyItem_id')  # Field name made lowercase.
    transaction_datetime = models.DateTimeField(blank=True, null=True)
    delete_datetime = models.DateTimeField(blank=True, null=True)
    is_delete = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'transactions'


class Transactionsreview(models.Model):
    review_id = models.IntegerField(primary_key=True)
    transaction = models.ForeignKey(Transactions, models.DO_NOTHING)
    rating = models.IntegerField()
    review = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'transactionsReview'


class Useraddress(models.Model):
    address_id = models.IntegerField(primary_key=True)
    address1 = models.CharField(max_length=50, blank=True, null=True)
    address2 = models.CharField(max_length=50, blank=True, null=True)
    city = models.CharField(max_length=30, blank=True, null=True)
    state = models.CharField(max_length=30, blank=True, null=True)
    zipcode = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'userAddress'




class CustomUserManager(BaseUserManager):
    def create_user(self, user_email, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        user_email = self.normalize_email(email)
        user = self.model(user_email=user_email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, user_email, password, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')

        return self.create_user(user_email, password, **extra_fields)

class Users(AbstractBaseUser, PermissionsMixin):
    user_id = models.AutoField(primary_key=True)
    user_email = models.EmailField(unique=True)
    first_name = models.CharField(max_length=50, blank=True, null=True)
    middle_name = models.CharField(max_length=50, blank=True, null=True)
    last_name = models.CharField(max_length=50, blank=True, null=True)
    organization_name = models.CharField(max_length=150, blank=True, null=True)
    user_gender = models.CharField(max_length=10, blank=True, null=True)
    user_address = models.ForeignKey(Useraddress, models.DO_NOTHING, db_column='user_address', blank=True, null=True)
    user_phone = models.CharField(max_length=50, blank=True, null=True)
    user_account = models.CharField(max_length=50, blank=True, null=True)
    password = models.CharField(max_length=50, blank=True, null=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    create_datetime = models.DateTimeField(default=timezone.now)
    delete_datetime = models.DateTimeField(blank=True, null=True)
    last_login = models.DateTimeField(('last login'), blank=True, null=True)

    is_delete = models.BooleanField(default=False)

    objects = CustomUserManager()

    USERNAME_FIELD = 'user_email'
    REQUIRED_FIELDS = []

    class Meta:
        db_table = 'users'

    def __str__(self):
        return self.user_email

# A Test table used for testing
class Test(models.Model):
    test_id=models.CharField(primary_key=True, max_length=20)
    test_text=models.CharField(max_length=30)

    class Meta:
        db_table='Test' 
