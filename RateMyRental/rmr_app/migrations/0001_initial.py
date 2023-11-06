# Generated by Django 4.2.6 on 2023-11-06 21:54

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Address',
            fields=[
                ('address_id', models.AutoField(primary_key=True, serialize=False)),
                ('address1', models.CharField(blank=True, max_length=50, null=True)),
                ('address2', models.CharField(blank=True, max_length=50, null=True)),
                ('city', models.CharField(blank=True, max_length=30, null=True)),
                ('state', models.CharField(blank=True, max_length=10, null=True)),
                ('zipcode', models.IntegerField(blank=True, null=True)),
            ],
            options={
                'db_table': 'Address',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='AuthGroup',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=150, unique=True)),
            ],
            options={
                'db_table': 'auth_group',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='AuthGroupPermissions',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
            ],
            options={
                'db_table': 'auth_group_permissions',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='AuthPermission',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('codename', models.CharField(max_length=100)),
            ],
            options={
                'db_table': 'auth_permission',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='AuthUser',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128)),
                ('last_login', models.DateTimeField(blank=True, null=True)),
                ('is_superuser', models.IntegerField()),
                ('username', models.CharField(max_length=150, unique=True)),
                ('first_name', models.CharField(max_length=150)),
                ('last_name', models.CharField(max_length=150)),
                ('email', models.CharField(max_length=254)),
                ('is_staff', models.IntegerField()),
                ('is_active', models.IntegerField()),
                ('date_joined', models.DateTimeField()),
            ],
            options={
                'db_table': 'auth_user',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='AuthUserGroups',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
            ],
            options={
                'db_table': 'auth_user_groups',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='AuthUserUserPermissions',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
            ],
            options={
                'db_table': 'auth_user_user_permissions',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Building',
            fields=[
                ('building_id', models.AutoField(primary_key=True, serialize=False)),
                ('building_type', models.CharField(blank=True, max_length=10, null=True)),
                ('building_name', models.CharField(blank=True, max_length=45, null=True)),
                ('building_region', models.CharField(blank=True, max_length=45, null=True)),
                ('building_location', models.CharField(blank=True, max_length=45, null=True)),
                ('building_zipcode', models.IntegerField(blank=True, null=True)),
                ('landload_type', models.CharField(blank=True, max_length=30, null=True)),
                ('landload', models.CharField(blank=True, max_length=30, null=True)),
            ],
            options={
                'db_table': 'Building',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Comments',
            fields=[
                ('comment_id', models.AutoField(primary_key=True, serialize=False)),
                ('comment', models.TextField(blank=True, null=True)),
                ('create_date', models.DateTimeField(blank=True, null=True)),
                ('delete_date', models.DateTimeField(blank=True, null=True)),
                ('is_delete', models.IntegerField(blank=True, null=True)),
            ],
            options={
                'db_table': 'Comments',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='DjangoAdminLog',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('action_time', models.DateTimeField()),
                ('object_id', models.TextField(blank=True, null=True)),
                ('object_repr', models.CharField(max_length=200)),
                ('action_flag', models.PositiveSmallIntegerField()),
                ('change_message', models.TextField()),
            ],
            options={
                'db_table': 'django_admin_log',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='DjangoContentType',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('app_label', models.CharField(max_length=100)),
                ('model', models.CharField(max_length=100)),
            ],
            options={
                'db_table': 'django_content_type',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='DjangoMigrations',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
                ('app', models.CharField(max_length=255)),
                ('name', models.CharField(max_length=255)),
                ('applied', models.DateTimeField()),
            ],
            options={
                'db_table': 'django_migrations',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='DjangoSession',
            fields=[
                ('session_key', models.CharField(max_length=40, primary_key=True, serialize=False)),
                ('session_data', models.TextField()),
                ('expire_date', models.DateTimeField()),
            ],
            options={
                'db_table': 'django_session',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Favorite',
            fields=[
                ('favorite_id', models.AutoField(primary_key=True, serialize=False)),
            ],
            options={
                'db_table': 'Favorite',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Feature',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('feature_type', models.CharField(blank=True, max_length=30, null=True)),
                ('feature_name', models.CharField(blank=True, max_length=50, null=True)),
                ('feature_content', models.CharField(blank=True, max_length=200, null=True)),
            ],
            options={
                'db_table': 'Feature',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Grant',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('role', models.CharField(blank=True, max_length=10, null=True)),
            ],
            options={
                'db_table': 'Grant',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Item',
            fields=[
                ('item_id', models.AutoField(primary_key=True, serialize=False)),
                ('item_type', models.CharField(blank=True, max_length=50, null=True)),
                ('capacity', models.IntegerField(blank=True, null=True)),
                ('item_bedroom', models.CharField(blank=True, max_length=20, null=True)),
                ('item_bathroom', models.CharField(blank=True, max_length=20, null=True)),
                ('monthly_rent', models.DecimalField(blank=True, decimal_places=2, max_digits=10, null=True)),
            ],
            options={
                'db_table': 'Item',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Itemlabel',
            fields=[
                ('label_id', models.AutoField(primary_key=True, serialize=False)),
                ('label', models.CharField(blank=True, max_length=255, null=True)),
            ],
            options={
                'db_table': 'ItemLabel',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Like',
            fields=[
                ('like_id', models.AutoField(primary_key=True, serialize=False)),
            ],
            options={
                'db_table': 'Like',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Lookup',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('category', models.CharField(blank=True, max_length=255, null=True)),
                ('type', models.CharField(blank=True, max_length=50, null=True)),
                ('content1', models.IntegerField(blank=True, null=True)),
                ('content2', models.CharField(blank=True, max_length=100, null=True)),
                ('content3', models.TextField(blank=True, null=True)),
                ('description', models.CharField(blank=True, max_length=200, null=True)),
            ],
            options={
                'db_table': 'Lookup',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Rent',
            fields=[
                ('rent_id', models.AutoField(primary_key=True, serialize=False)),
                ('rating', models.IntegerField(blank=True, null=True)),
                ('rent_start_date', models.DateField(blank=True, null=True)),
                ('rent_end_date', models.DateField(blank=True, null=True)),
                ('is_delete', models.IntegerField(blank=True, null=True)),
            ],
            options={
                'db_table': 'Rent',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Storeimages',
            fields=[
                ('image_id', models.AutoField(primary_key=True, serialize=False)),
                ('image', models.TextField(blank=True, null=True)),
            ],
            options={
                'db_table': 'StoreImages',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='User',
            fields=[
                ('user_id', models.AutoField(primary_key=True, serialize=False)),
                ('user_first_name', models.CharField(blank=True, max_length=255, null=True)),
                ('user_middle_name', models.CharField(blank=True, max_length=255, null=True)),
                ('user_last_name', models.CharField(blank=True, max_length=255, null=True)),
                ('user_gender', models.CharField(blank=True, max_length=10, null=True)),
                ('user_phone', models.CharField(blank=True, max_length=20, null=True)),
                ('user_email', models.CharField(blank=True, max_length=255, null=True)),
                ('account_id', models.IntegerField(blank=True, null=True)),
                ('create_date', models.DateTimeField(blank=True, null=True)),
                ('delete_date', models.DateTimeField(blank=True, null=True)),
                ('is_delete', models.IntegerField(blank=True, null=True)),
            ],
            options={
                'db_table': 'User',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Test',
            fields=[
                ('test_id', models.CharField(max_length=20, primary_key=True, serialize=False)),
                ('test_text', models.CharField(max_length=30)),
            ],
            options={
                'db_table': 'Test',
            },
        ),
        migrations.CreateModel(
            name='Account',
            fields=[
                ('account_id', models.AutoField(primary_key=True, serialize=False)),
                ('account_username', models.CharField(blank=True, max_length=30, null=True)),
                ('account_password', models.CharField(blank=True, max_length=30, null=True)),
                ('signup_email', models.CharField(blank=True, max_length=75, null=True)),
                ('user', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.DO_NOTHING, to='rmr_app.user')),
            ],
            options={
                'db_table': 'Account',
            },
        ),
    ]
