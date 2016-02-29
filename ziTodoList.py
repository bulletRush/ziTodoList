import yaml

from bottle import route, run, debug, template, error


# only needed when you run Bottle on mod_wsgi
@route('/todolist')
def display_toto_list():
    # Load YAML database
    with open("./data/todolist.yaml", 'r') as stream:
        try:
            task_list = yaml.load(stream)
            print task_list
        except yaml.YAMLError as exc:
            print(exc)
    output = template('./templates/todolist', task_list = task_list)
    return output

@error(403)
def error403(code):
    return 'Error 403 !'

@error(404)
def error404(code):
    return 'Error 404 !'

debug(True)
run(reloader=True)
