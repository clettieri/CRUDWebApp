from flask_wtf import Form
from wtforms import StringField, PasswordField, BooleanField, SelectField
from wtforms.validators import DataRequired

class LoginForm(Form):
    username = StringField('username', validators=[DataRequired()])
    password = PasswordField('password', validators=[DataRequired()])
    remember_me = BooleanField('remember_me', default=False)

class ClientSearchForm(Form):
    search = StringField('search', validators=[DataRequired()])
    
class AddClientForm(Form):
    full_name = StringField('full_name', validators=[DataRequired()])
    id_or_desc = StringField('id_or_desc', validators=[DataRequired()])
    phone = StringField('id_or_desc', validators=[DataRequired()])
    
class AddClientLogForm(Form):
    #TODO - integer field for id?
    service_id = StringField('service_id', validators=[DataRequired()])
    description = StringField('description', validators=[DataRequired()])
    notes = StringField('notes', validators=[DataRequired()])
    
class SelectBunkForm(Form):
    bunk_type = SelectField('Bunk Type', choices=[('male', 'Male Bunk'), ('female', 'Female Bunk'), ('mixed', 'Mixed Bunk')])
    service_type = SelectField('Service Type')
    #service_id = StringField('service_id', validators=[DataRequired()])