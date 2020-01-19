'''
Class: CPSC 332 - File Structures & Database Systems
Team: Dion W. Pieterse & Chris Phongsa
'''

from flask import render_template
from flask_wtf.csrf import CSRFError

@app.errorhandler(CSRFError)
def handle_csrf_error(e):
    return render_template('csrf_error.html', reason=e.description), 1062
