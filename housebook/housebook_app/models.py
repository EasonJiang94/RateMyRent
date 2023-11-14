from django.db import models

# Create your models here.
class Label(models.Model):
    label_id = models.IntegerField(primary_key=True)
    label = models.CharField(max_length=50, blank=True, null=True)
    label_description = models.CharField(max_length=50, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Label'


class Agent(models.Model):
    agent_id = models.IntegerField(primary_key=True)
    user = models.ForeignKey('Users', models.DO_NOTHING, blank=True, null=True)
    create_datetime = models.DateTimeField(blank=True, null=True)
    delete_datetime = models.DateTimeField(blank=True, null=True)
    is_delete = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'agent'


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
    state = models.CharField(max_length=10, blank=True, null=True)
    zipcode = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'userAddress'


class Users(models.Model):
    user_id = models.IntegerField(primary_key=True)
    first_name = models.CharField(max_length=50, blank=True, null=True)
    middle_name = models.CharField(max_length=50, blank=True, null=True)
    last_name = models.CharField(max_length=50, blank=True, null=True)
    organization_name = models.CharField(max_length=150, blank=True, null=True)
    user_gender = models.CharField(max_length=10, blank=True, null=True)
    user_address = models.ForeignKey(Useraddress, models.DO_NOTHING, db_column='user_address', blank=True, null=True)
    user_phone = models.CharField(max_length=50, blank=True, null=True)
    user_email = models.CharField(max_length=100, blank=True, null=True)
    user_account = models.CharField(max_length=50, blank=True, null=True)
    passward = models.CharField(max_length=50, blank=True, null=True)
    create_datetime = models.DateTimeField(blank=True, null=True)
    delete_datetime = models.DateTimeField(blank=True, null=True)
    is_delete = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'users'


# A Test table used for testing
class Test(models.Model):
    test_id=models.CharField(primary_key=True, max_length=20)
    test_text=models.CharField(max_length=30)

    class Meta:
        db_table='Test' 