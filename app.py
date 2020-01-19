'''
Class: CPSC 332 - File Structures & Database Systems
Team: Dion W. Pieterse & Chris Phongsa
'''

from flask import Flask, render_template, redirect, flash, session, request
import user_forms
import pymysql.cursors
import os
from user_forms import List_Artists_Sorted
from user_forms import Artist_Form_Validator
from user_forms import Artists_At_Event_Form
from user_forms import Artists_By_Type_Form
from flask_wtf.csrf import CSRFError

app = Flask(__name__)

connection = pymysql.connect(host='localhost',
                             user='###',
                             password='###',
                             db='GALLERY_DB',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)

#Added for form validation.
app.config['SECRET_KEY'] = 'secret key'
WTF_CSRF_SECRET_KEY = 'secret key'

"""
#########################
Home Page of Application
#########################
"""
@app.route('/', methods=['GET', 'POST'])
def index():
    ############### View All Artists Sorted By User Choice ####
    list_artists_sorted_form = List_Artists_Sorted()

    ############### View Artists By Event #####################
    #Fetch the latest list of events from the DB
    cursor = connection.cursor()
    list_query ='SELECT Art_Show_Title FROM ART_SHOWS_TABLE'
    cursor.execute(list_query)
    dynamic_list = cursor.fetchall()
    cursor.close()
    print(dynamic_list)

    #Create the custom form (unpopulated with events at this point)
    artist_event_form = Artists_At_Event_Form()
    #Add the choices dynamically from the DB after form instantiation
    artist_event_form.event.choices = [(event['Art_Show_Title'], event['Art_Show_Title']) for event in dynamic_list]
    ### END ###

    ############### View Artwork by Style and Type #####################
    cursor = connection.cursor()
    #Fetch the latest list of events from the DB.
    list_aritst_by_type_query ='SELECT Type_Name FROM TYPE_ART_ID_CODE_TABLE'
    #Fetch types.
    cursor = connection.cursor()
    cursor.execute(list_aritst_by_type_query)
    type_dynamic_list = cursor.fetchall()
    cursor.close()
    #Print to console for debugging.
    print(type_dynamic_list)

    #Create form (Note: Initially unpopulated)
    artist_by_type_form = Artists_By_Type_Form()
    #Add list choices dynamically from the DB after form object instantiation.
    artist_by_type_form.type_art.choices = [(type_art['Type_Name'], type_art['Type_Name']) for type_art in type_dynamic_list]
    ### END ###

    #If form submitted w/o error.
    if list_artists_sorted_form.validate_on_submit():
        attr_choice = list_artists_sorted_form.attr_choice.data
        print(attr_choice)
        sort_choice = list_artists_sorted_form.asc_desc_choice.data
        print(sort_choice)
        attr_c = ''
        order = ''
        #Dropdown menu choices to actual SQL ORDER commands
        attr_look_up = {'Artist Id':'Artist_Id','Title':'Title', 'First Name':'FName', 'Middle Name':'MName', 'Last Name':'LName', 'Date of Birth':'DOB', 'Street/Apt #':'St_Apt_Num', 'Street':'Street', 'City':'City', 'State':'State', 'Zip':'Zip', 'Country':'Country', 'International Code':'Intl_Code','Area Code':'Area_Code', 'Phone Number':'P_Number'}
        order_look_up = { 'Ascending Order':'ASC', 'Descending Order':'DESC'}

        #find SQL value for drop down choice for attribute
        for a_c, value in attr_look_up.items():
            if a_c == attr_choice:
                attr_c = value
        #find SQL value for drop down choice
        for s_c, value in order_look_up.items():
            if s_c == sort_choice:
                order = value
        print(attr_c)
        print(order)
        list_sort_query = "SELECT * FROM ARTIST_ID_CODE_TABLE ORDER BY {0} {1}".format(attr_c, order)
        print(list_sort_query)
        cursor = connection.cursor()
        cursor.execute(list_sort_query)
        list_query_result = cursor.fetchall()
        print(list_query_result)
        cursor.close()
        return render_template('list_artists.html', list_query_result=list_query_result, attr_c=attr_c, sort_choice=sort_choice)
    elif artist_event_form.validate_on_submit():
        #Collect user's choice.
        the_event = artist_event_form.event.data
        cursor = connection.cursor()
        query = "SELECT A.Artist_Id, A.Title, A.FName, A.MName, A.LName, A.DOB FROM ARTIST_ID_CODE_TABLE AS A JOIN ARTSHOW_ARTIST_TABLE AS B ON A.Artist_Id=B.Art_Show_Artist_Id WHERE B.Art_Show_Title=\'{}\'".format(the_event)
        cursor.execute(query)
        query_result = cursor.fetchall()
        print(query_result)
        cursor.close()
        return render_template('view_event_artists.html', query_result=query_result, the_event=the_event)
    elif artist_by_type_form.validate_on_submit():
        the_type = artist_by_type_form.type_art.data
        cursor = connection.cursor()
        t_query = "SELECT A.Artwork_Title, C.Type_Name, B.Price, B.AW_DOC, B.AW_DAG, D.Title, D.FName, D.MName, D.LName FROM ((ARTWORK_TYPE_OF_ART_TABLE AS A INNER JOIN ART_WORK_TABLE AS B ON A.Artist_Id=B.Artist_Id AND A.Artwork_Title=B.Artwork_Title) INNER JOIN TYPE_ART_ID_CODE_TABLE AS C ON A.Type_Id=C.Type_id INNER JOIN ARTIST_ID_CODE_TABLE AS D ON B.Artist_Id=D.Artist_Id) WHERE Type_Name=\'{}\';".format(the_type)
        cursor.execute(t_query)
        t_query_result = cursor.fetchall()
        print(t_query_result)
        cursor.close()
        return render_template('artwork_by_type.html', t_query_result=t_query_result, the_type=the_type)
    return render_template('index.html', list_artists_sorted_form=list_artists_sorted_form, artist_event_form=artist_event_form, artist_by_type_form=artist_by_type_form)


"""
###############################
List all Artists & Styles
###############################
"""
@app.route('/artists_and_styles/')
def artists_and_styles():
    cursor = connection.cursor()
    #create query to fetch all artist's info and respective styles
    AaS_query = "SELECT A.Artist_Id, A.Title, A.FName, A.MName, A.LName, C.Style_Name FROM ((ARTIST_ID_CODE_TABLE AS A INNER JOIN ARTIST_STYLE_ART_TABLE AS B ON A.Artist_Id=B.Artist_Id) INNER JOIN STYLE_ART_ID_CODE_TABLE AS C ON B.Style_Id = C.Style_Id) ORDER BY A.Artist_Id ASC;"
    #run the query
    cursor.execute(AaS_query)
    #fetch all the tuple results
    AaS_query_result = cursor.fetchall()
    #print to console for debugging
    print(AaS_query_result)
    #close the cursor after use
    cursor.close()
    return render_template('artists_and_styles.html', AaS_Table_Result=AaS_query_result)


"""
##################################
List All Artwork Authors and Type
##################################
"""
@app.route('/list_artwork_details/')
def list_artwork_details():
    cursor = connection.cursor()
    #create query to fetch all artist's info and respective styles
    AfD_query = "SELECT A.Artwork_Title, C.Title, C.FName, C.MName, C.LName, B.Type_Name FROM ((ARTWORK_TYPE_OF_ART_TABLE AS A INNER JOIN TYPE_ART_ID_CODE_TABLE AS B ON A.Type_Id=B.Type_Id) INNER JOIN ARTIST_ID_CODE_TABLE AS C ON A.Artist_Id = C.Artist_Id);"
    #run the query
    cursor.execute(AfD_query)
    #fetch all the tuple results
    AfD_query_result = cursor.fetchall()
    #print to console for debugging
    print(AfD_query_result)
    #close the cursor after use
    cursor.close()
    return render_template('list_artwork_details.html', AfD_Table_Result=AfD_query_result)


"""
##############################################################
Access Specific artist by Artist_Id Number via URL in Browser
##############################################################
"""
@app.route('/artists/<int:id>/')
def artists(id):
    cursor = connection.cursor()
    #grab artist by ID number
    query = "SELECT * FROM ARTIST_ID_CODE_TABLE WHERE Artist_Id={}".format(id)
    query_result = cursor.execute(query)
    if query_result > 0:
        artist = cursor.fetchone()
        cursor.close()
        return render_template('artists.html',artist=artist, artist_id=id)
    cursor.close()
    return render_template('artists.html')

"""
##############################################################
Add an artist to the database
##############################################################
"""
@app.route('/add_artist/', methods=['GET', 'POST'])
def add_artist():
    try:
        form = Artist_Form_Validator()
        if form.validate_on_submit():
            cursor = connection.cursor()
            cursor.execute("INSERT INTO ARTIST_ID_CODE_TABLE(Title, FName, MName, LName, DOB, St_Apt_Num, Street, City, State, Zip, Country, Intl_Code, Area_Code, P_Number) VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", (form.title.data, form.first_name.data, form.middle_name.data, form.last_name.data, form.dob.data, form.st_apt_num.data, form.street.data, form.city.data, form.state.data, form.zip.data, form.country.data, form.intl_code.data, form.area_code.data, form.phone_number.data))
            connection.commit()
            cursor.close()
            return redirect('/')
    except:
        return render_template('csrf_error.html')
    return render_template('add_artist.html', form=form)

@app.route('/enter_contact/', methods=['GET', 'POST'])
def enter_contact():
    return render_template('enter_contact.html')

if __name__ == '__main__':
    app.run(debug=True)
