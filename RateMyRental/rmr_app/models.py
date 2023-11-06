from django.db import models


# create tables
# please run "python3 manage.py makemigrations rmr_app"
# please run "python3 manage.py migrate rmr_app"
# when changes to database are made, please run the codes above in terminal

# if Error1050 appears, please run "python manage.py migrate --fake rmr_app"
class Account(models.Model):
    account_id = models.AutoField(primary_key=True)
    account_username = models.CharField(max_length=30, blank=True, null=True)
    account_password = models.CharField(max_length=30, blank=True, null=True)
    signup_email = models.CharField(max_length=75, blank=True, null=True)
    user = models.ForeignKey('User', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        db_table = 'Account'


class Address(models.Model):
    address_id = models.AutoField(primary_key=True)
    address1 = models.CharField(max_length=50, blank=True, null=True)
    address2 = models.CharField(max_length=50, blank=True, null=True)
    city = models.CharField(max_length=30, blank=True, null=True)
    state = models.CharField(max_length=10, blank=True, null=True)
    zipcode = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Address'


class Building(models.Model):
    building_id = models.AutoField(primary_key=True)
    building_type = models.CharField(max_length=10, blank=True, null=True)
    building_name = models.CharField(max_length=45, blank=True, null=True)
    building_region = models.CharField(max_length=45, blank=True, null=True)
    building_location = models.CharField(max_length=45, blank=True, null=True)
    building_zipcode = models.IntegerField(blank=True, null=True)
    landload_type = models.CharField(max_length=30, blank=True, null=True)
    landload = models.CharField(max_length=30, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Building'


class Comments(models.Model):
    comment_id = models.AutoField(primary_key=True)
    user = models.ForeignKey('User', models.DO_NOTHING, blank=True, null=True)
    item = models.ForeignKey('Item', models.DO_NOTHING, blank=True, null=True)
    comment = models.TextField(blank=True, null=True)
    create_date = models.DateTimeField(blank=True, null=True)
    delete_date = models.DateTimeField(blank=True, null=True)
    is_delete = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Comments'


class Favorite(models.Model):
    favorite_id = models.AutoField(primary_key=True)
    user = models.ForeignKey('User', models.DO_NOTHING, blank=True, null=True)
    item = models.ForeignKey('Item', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Favorite'


class Feature(models.Model):
    feature_type = models.CharField(max_length=30, blank=True, null=True)
    item = models.ForeignKey('Item', models.DO_NOTHING, blank=True, null=True)
    feature_name = models.CharField(max_length=50, blank=True, null=True)
    feature_content = models.CharField(max_length=200, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Feature'


class Grant(models.Model):
    user = models.ForeignKey('User', models.DO_NOTHING, blank=True, null=True)
    role = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Grant'


class Item(models.Model):
    item_id = models.AutoField(primary_key=True)
    building = models.ForeignKey(Building, models.DO_NOTHING, db_column='building', blank=True, null=True)
    item_type = models.CharField(max_length=50, blank=True, null=True)
    capacity = models.IntegerField(blank=True, null=True)
    item_bedroom = models.CharField(max_length=20, blank=True, null=True)
    item_bathroom = models.CharField(max_length=20, blank=True, null=True)
    monthly_rent = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Item'


class Itemlabel(models.Model):
    label_id = models.AutoField(primary_key=True)
    item = models.ForeignKey(Item, models.DO_NOTHING, blank=True, null=True)
    label = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'ItemLabel'


class Like(models.Model):
    like_id = models.AutoField(primary_key=True)
    user = models.ForeignKey('User', models.DO_NOTHING, blank=True, null=True)
    item = models.ForeignKey(Item, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Like'


class Lookup(models.Model):
    category = models.CharField(max_length=255, blank=True, null=True)
    type = models.CharField(max_length=50, blank=True, null=True)
    content1 = models.IntegerField(blank=True, null=True)
    content2 = models.CharField(max_length=100, blank=True, null=True)
    content3 = models.TextField(blank=True, null=True)
    description = models.CharField(max_length=200, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Lookup'


class Rent(models.Model):
    rent_id = models.AutoField(primary_key=True)
    tenant = models.ForeignKey('User', models.DO_NOTHING, blank=True, null=True)
    item = models.ForeignKey(Item, models.DO_NOTHING, db_column='item', blank=True, null=True)
    rating = models.IntegerField(blank=True, null=True)
    rent_start_date = models.DateField(blank=True, null=True)
    rent_end_date = models.DateField(blank=True, null=True)
    is_delete = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Rent'


class Storeimages(models.Model):
    image_id = models.AutoField(primary_key=True)
    item = models.ForeignKey(Item, models.DO_NOTHING, blank=True, null=True)
    image = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'StoreImages'


class User(models.Model):
    user_id = models.AutoField(primary_key=True)
    user_first_name = models.CharField(max_length=255, blank=True, null=True)
    user_middle_name = models.CharField(max_length=255, blank=True, null=True)
    user_last_name = models.CharField(max_length=255, blank=True, null=True)
    user_gender = models.CharField(max_length=10, blank=True, null=True)
    current_address = models.ForeignKey(Address, models.DO_NOTHING, db_column='current_address', blank=True, null=True)
    user_phone = models.CharField(max_length=20, blank=True, null=True)
    user_email = models.CharField(max_length=255, blank=True, null=True)
    account_id = models.IntegerField(blank=True, null=True)
    create_date = models.DateTimeField(blank=True, null=True)
    delete_date = models.DateTimeField(blank=True, null=True)
    is_delete = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'User'


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

# The two tables below are for testing
class Test(models.Model):
    test_id=models.CharField(primary_key=True, max_length=20)
    test_text=models.CharField(max_length=30)

    class Meta:
        db_table='Test'

class Test2(models.Model):
    test_id=models.CharField(primary_key=True, max_length=20)
    test_text=models.CharField(max_length=30)

    class Meta:
        db_table='Test2'

#--------- Demo of How to interact with data ---------

# save data to table "Test"
# t=Test(test_id="002", test_text="tester2")
# t.save()
