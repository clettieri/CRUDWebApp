from flask import render_template, flash, redirect, session
from app import app
from .forms import LoginForm, ClientSearchForm, AddClientForm, AddClientLogForm, SelectBunkForm
from flask_mysqldb import MySQL
import datetime
import pandas as pd

mysql = MySQL(app)

@app.route('/')
@app.route('/index')
def index():
    return render_template('index.html',
                           title='Site Form')

@app.route('/login_form', methods=['GET', 'POST'])
def login_form():
    form = LoginForm()
    if form.validate_on_submit():
        cursor = mysql.connection.cursor()
        cursor.execute('''SELECT UserID, SiteID, Password FROM `User` WHERE Username = "%s" ''' % (form.username.data) )
        rv = cursor.fetchall()
        if (len(rv) > 0):
            if (rv[0][2] == form.password.data):
                session['Username'] = form.username.data
                session['UserID'] = rv[0][0]
                session['SiteID'] = rv[0][1]
                return redirect('/index')
            else:
                flash('Password incorrect for user "%s"' % (form.username.data))
                return render_template('login_form.html',
                           title='Login Form',
                           form=form)
        else:
            flash('User "%s" not found!' % (form.username.data))
            return render_template('login_form.html',
                       title='Login Form',
                       form=form)
    return render_template('login_form.html',
                           title='Login Form',
                           form=form)

@app.route('/logout')
def logout():
    session.clear()
    return redirect('/login_form')

@app.route('/shelter_service_form')
def shelter_service_form():
    return render_template('shelter_service_form.html',
                           title='Shelter Service Form')

@app.route('/food_bank_service_form')
def food_bank_service_form():
    return render_template('food_bank_service_form.html',
                           title='Food Bank Service Form')

@app.route('/soup_kitchen_service_form')
def soup_kitchen_service_form():
    return render_template('soup_kitchen_service_form.html',
                           title='Soup Kitchen Form')

@app.route('/food_pantry_service_form')
def food_pantry_service_form():
    return render_template('food_pantry_service_form.html',
                           title='Food Pantry Service Form')
     
@app.route('/outstanding_requests_form')
def outstanding_requests_form():
    return render_template('outstanding_requests_form.html',
                           title='Outstanding Requests Form')
    
@app.route('/item_search_form')
def item_search_form():
    return render_template('item_search_form.html',
                           title='Item Search Form')

@app.route('/client_search_form', methods=['GET', 'POST'])
def client_search_form():
    form = ClientSearchForm()
    if form.validate_on_submit():
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM Client WHERE FullName LIKE %s OR IDOrDescription LIKE %s", ("%"+form.search.data+"%","%"+form.search.data+"%",))
        rv = cursor.fetchall()
        if (len(rv) == 0):
            flash("No matches found")
        elif (len(rv) <= 4):
            return render_template('client_search_results.html',
                                    title='Client Search Results',
                                    data=rv)
        else:
            flash('Too many matches')

    return render_template('client_search_form.html',
                           title='Client Search Form',
                           form=form)
    
@app.route('/add_client', methods=['GET', 'POST'])
def add_client():
    form = AddClientForm()
    if form.validate_on_submit():
        cursor = mysql.connection.cursor()
        #Add client
        cursor.execute("INSERT INTO Client (FullName, IDOrDescription, PhoneNumber) VALUES (%s, %s, %s)",
                       (form.full_name.data, form.id_or_desc.data, form.phone.data))
        
        #Get client id and timestamp
        new_client_id = cursor.lastrowid
        now = datetime.datetime.now()
        now = now.strftime('%Y-%m-%d %H:%M:%S') 
        
        #Create log entry
        cursor.execute(''' INSERT INTO ClientLog (ClientID, TimeStamp, ServiceID, Description, Notes) VALUES
                       (%s, %s, NULL, 'Client Added', 'See updated info in Client table')''',
                       (new_client_id, now))
        #Commit changes
        mysql.connection.commit()
        flash('User Added! ' + str(new_client_id))
        
        return redirect('/client_search_form')

    return render_template('add_client.html',
                           title='Add Client',
                           form=form)

@app.route('/modify_client_<client_id>', methods=['GET', 'POST'])
def modify_client(client_id):
    #Get client to modify
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM Client WHERE ClientID=%s", client_id)
    rv = cursor.fetchall()
    form = AddClientForm(full_name=rv[0][1], id_or_desc=rv[0][2], phone=rv[0][3])
    #User submits modify form
    if form.validate_on_submit():
        cursor = mysql.connection.cursor()
        #Modify client
        cursor.execute("UPDATE Client SET FullName=%s, IDOrDescription=%s, PhoneNumber=%s WHERE ClientID=%s",
                       (form.full_name.data, form.id_or_desc.data, form.phone.data, client_id))
        
        #Get client id and timestamp
        now = datetime.datetime.now()
        now = now.strftime('%Y-%m-%d %H:%M:%S') 
        
        #Create log entry
        cursor.execute(''' INSERT INTO ClientLog (ClientID, TimeStamp, ServiceID, Description, Notes) VALUES
                       (%s, %s, NULL, 'Client Modified', 'See updated info in Client table')''',
                       (client_id, now))
        #Commit changes
        mysql.connection.commit()
        flash('User Modified! ' + str(client_id))
        
        return redirect('/client_search_form')
    return render_template('modify_client.html',
                           title='Modify Client',
                           form=form,
                           data=rv)
    
@app.route('/add_client_log_<client_id>', methods=['GET', 'POST'])
def add_client_log(client_id):
    form = AddClientLogForm()
    
    #User submits modify form
    if form.validate_on_submit():
        cursor = mysql.connection.cursor()       
        #Get client id and timestamp
        now = datetime.datetime.now()
        now = now.strftime('%Y-%m-%d %H:%M:%S') 
        
        #Create log entry
        cursor.execute(''' INSERT INTO ClientLog (ClientID, TimeStamp, ServiceID, Description, Notes) VALUES
                       (%s, %s, %s, %s, %s)''',
                       (client_id, now, form.service_id.data, form.description.data, form.notes.data))
        #Commit changes
        mysql.connection.commit()
        flash('Log Added! ' + str(client_id))
        
        return redirect('/client_search_form')
    return render_template('add_client_log.html',
                           title='Add Client Log',
                           form=form)

@app.route('/bunks_available_report')
def bunks_available_report():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM ShelterService WHERE MaleBunksAvailable >= 1 OR FemaleBunksAvailable >= 1 OR MixedBunksAvailable >= 1")
    rv = cursor.fetchall()
    if len(rv) == 0:
        flash("Sorry, all shelters are currently at maximum capacity")
    return render_template('bunks_available_report.html',
                           title='Bunks Available Report',
                           data=rv)
    
@app.route('/meals_remaining_report')
def meals_remaining_report():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM FoodBankService INNER JOIN Item ON FoodBankService.ServiceID=Item.FoodBankServiceID WHERE Category='food_item'")
    rv = cursor.fetchall()
    #convert to dataframe
    df = pd.DataFrame(list(rv), columns=['ServicedID', "SiteID", 'ItemId','FoodBankServiceID', 'Category', 'SubCategory', 'Name',
                                          'Units', 'Expiration', 'StorageType'])
    #1 meal = 1 veg, 1 grain, 1 meat or dairy
    veg_units = df[df['SubCategory']=='vegetables']['Units'].sum()
    grain_units = df[df['SubCategory']=='nuts/grains/beans']['Units'].sum()
    meat_units = df[df['SubCategory']=='meat/seafood']['Units'].sum()
    dairy_units = df[df['SubCategory']=='dairy/eggs']['Units'].sum()
    meals_left = min([veg_units, grain_units, max(meat_units, dairy_units)])
    #What to donate
    donate = ''
    if meals_left == veg_units:
        donate = 'Vegetables'
    elif meals_left == grain_units:
        donate = 'Grains, Nuts, Beans'
    elif meals_left == meat_units:
        donate = 'Meat, Seafood'
    else:
        donate = 'Dairy, Eggs'
    data=(meals_left, donate)
    return render_template('meals_remaining_report.html',
                           title='Meals Remaining Report',
                           data=data)
def get_current_user_id():
    #Get current user id
    current_user = str(session['Username'])
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT UserID FROM User WHERE UserName=%s", [current_user])
    rv = cursor.fetchall()
    current_user_id = rv[0][0]
    return current_user_id

def get_current_site_id():
    current_user = get_current_user_id()
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT SiteID FROM User WHERE UserID=%s", [current_user])
    rv = cursor.fetchall()
    site_id = rv[0][0]
    return site_id

@app.route('/request_status_report')
def request_status_report():
    current_user = get_current_user_id()
    #Query
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM ItemRequest WHERE UserID=%s AND Status=%s", (current_user, 'pending'))
    rv = cursor.fetchall()
    return render_template('request_status_report.html',
                           title='Request Status Report',
                           data_set=rv)
    
@app.route('/cancel_status_report_<request_id>')
def cancel_status_report(request_id):
    cursor = mysql.connection.cursor()
    cursor.execute("UPDATE ItemRequest SET Units=0, Status='closed' WHERE ItemRequestID=%s", [request_id])
    mysql.connection.commit()
    flash("Datbase updated")
    return redirect('/request_status_report')

    
@app.route('/checkin_client_<client_id>', methods=['GET', 'POST'])
def checkin_client(client_id):
    site_id = get_current_site_id()
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM ShelterService WHERE SiteID=%s", [site_id])
    rv = cursor.fetchall()
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM FoodPantryService WHERE SiteID=%s", [site_id])
    pantry_set = cursor.fetchall()
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM SoupKitchenService WHERE SiteID=%s", [site_id])
    soup_set = cursor.fetchall()
    #Bunk
    form = SelectBunkForm()
    choices = []
    if len(rv) > 0:
        choices.append(("shelter","Shelter"))
    if len(pantry_set) > 0:
        choices.append(("pantry", "Food Pantry"))
    if len(soup_set) > 0:
        choices.append(("soup","Soup Kitchen"))
    form.service_type.choices = choices
    if form.validate_on_submit():
        #Shelter
        if "shelter" in form.service_type.data:
            #Update Service
            cursor = mysql.connection.cursor()
            bunk = form.bunk_type.data
            service_id = rv[0][0]
            if bunk == "male":
                cursor.execute('''UPDATE ShelterService SET ShelterService.MaleBunksAvailable=ShelterService.MaleBunksAvailable-1 
                               WHERE ShelterService.ServiceID=%s''', [service_id])
            elif bunk == "female":
                cursor.execute('''UPDATE ShelterService SET ShelterService.FemaleBunksAvailable=ShelterService.FemaleBunksAvailable-1 
                               WHERE ShelterService.ServiceID=%s''', [service_id])
            elif bunk =="mixed":
                cursor.execute('''UPDATE ShelterService SET ShelterService.MixedBunksAvailable=ShelterService.MixedBunksAvailable-1 
                               WHERE ShelterService.ServiceID=%s''', [service_id])
            #Create Log
            cursor = mysql.connection.cursor()
            now = datetime.datetime.now()
            now = now.strftime('%Y-%m-%d %H:%M:%S') 
            cursor.execute("INSERT INTO ClientLog (ClientID, TimeStamp, ServiceID, Description, Notes) VALUES (%s, %s, %s, %s, %s)",
                           (client_id, now, service_id, "Client checked in to shelter service", "See new client check in for more info"))
            mysql.connection.commit()
            flash("Client checked in")
            return redirect('/client_search_form')
        #Pantry
        if "pantry" in form.service_type.data:
            #Create Log
            cursor = mysql.connection.cursor()
            now = datetime.datetime.now()
            now = now.strftime('%Y-%m-%d %H:%M:%S') 
            cursor.execute("INSERT INTO ClientLog (ClientID, TimeStamp, ServiceID, Description, Notes) VALUES (%s, %s, %s, %s, %s)",
                           (client_id, now, pantry_set[0][0], "Client checked in to pantry service", "See new client check in for more info"))
            mysql.connection.commit()
            flash("Client checked in")
            return redirect('/client_search_form')
        #Soup
        if "soup" in form.service_type.data:
            #Checkin
            cursor = mysql.connection.cursor()
            cursor.execute('''UPDATE SoupKitchenService SET SoupKitchenService.SeatsAvailable=SoupKitchenService.SeatsAvailable-1
                           WHERE SoupKitchenService.ServiceID=%s''', [soup_set[0][0]])
            #Create Log
            cursor = mysql.connection.cursor()
            now = datetime.datetime.now()
            now = now.strftime('%Y-%m-%d %H:%M:%S') 
            cursor.execute("INSERT INTO ClientLog (ClientID, TimeStamp, ServiceID, Description, Notes) VALUES (%s, %s, %s, %s, %s)",
                           (client_id, now, soup_set[0][0], "Client checked in to soup service", "See new client check in for more info"))
            mysql.connection.commit()
            flash("Client checked in")
            return redirect('/client_search_form')
    return render_template('checkin_client.html',
                           title='Check In Client',
                           data_set=rv, soup_set=soup_set, pantry_set=pantry_set,
                           form=form)