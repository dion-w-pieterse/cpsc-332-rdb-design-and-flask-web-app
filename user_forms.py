'''
Class: CPSC 332 - File Structures & Database Systems
Team: Dion W. Pieterse & Chris Phongsa
'''

from flask_wtf import FlaskForm
from wtforms import Form, BooleanField, StringField, PasswordField, DateTimeField, DateField, SelectField, IntegerField, SubmitField, validators
from wtforms.validators import ValidationError, DataRequired, Email, EqualTo, Length

class Artist_Form_Validator(FlaskForm):
    title = StringField('Title', [validators.Length(min=3, max=20)])
    first_name = StringField('First Name', [validators.Length(min=1, max=40)])
    middle_name = StringField('Middle Name', [validators.Length(min=1, max=40)])
    last_name = StringField('Last Name', [validators.Length(min=1, max=40)])
    dob = DateField('DOB', validators=[DataRequired()], format='%Y-%m-%d')
    st_apt_num = StringField('House# or Apt#', [validators.Length(min=1, max=20)])
    street = StringField('Street', [validators.Length(min=1, max=50)])
    city = StringField('City', [validators.Length(min=1, max=50)])
    state = StringField('State', [validators.Length(min=1, max=2)])
    zip = StringField('Zip', [validators.Length(min=1, max=10)])
    country = StringField('Country', [validators.Length(min=1, max=40)])
    intl_code = IntegerField('International Code', [validators.NumberRange(min=1, max=999)])
    area_code = IntegerField('Area Code', [validators.NumberRange(min=1, max=999)])
    phone_number = IntegerField('Phone Number', [validators.NumberRange(min=1, max=9999999)])
    submit = SubmitField('Add Artist')

    def validate_artist_name(self, first_name, middle_name, last_name):
        #Search DB for username input by user. If get hit, username not unique => validation error.
        cursor = connection.cursor()
        query = 'SELECT * FROM ARTIST_ID_CODE_TABLE WHERE FName={} AND MName={} AND LName={}'.format(first_name, middle_name, last_name)
        cursor.execute(query)
        #Get the first result if available.
        query_result = cursor.fetchone()
        cursor.close()
        if query_result is not None:
            #Username already exists => throw error. Inform flask_wtf field invalid.
            raise ValidationError('The artist\'s name already exists. Please use another name.')

class List_Artists_Sorted(FlaskForm):
    attr_choice = SelectField('Attribute:', choices= [('Artist Id','Artist Id'),('Title','Title'), ('First Name', 'First Name'), ('Middle Name', 'Middle Name'), ('Last Name', 'Last Name'), ('Date of Birth', 'DOB'), ('Street/Apt #', 'Street/Apt #'), ('Street', 'Street'), ('City', 'City'), ('State','State'), ('Zip', 'Zip'), ('Country', 'Country'), ('International Code', 'International Code'), ('Area Code', 'Area Code'), ('Phone Number', 'Phone Number')])
    asc_desc_choice = SelectField('Sorted:', choices= [('Ascending Order', 'Ascending Order'), ('Descending Order', 'Descending Order')])
    submit = SubmitField('View Artists in Chosen Order.')

class Artists_At_Event_Form(FlaskForm):
    event = SelectField('Event:', choices = [])
    submit = SubmitField('View Artists At Event')

class Artists_By_Type_Form(FlaskForm):
    type_art = SelectField('Type of Art:', choices = [])
    submit = SubmitField('View Artwork Details by Type')
