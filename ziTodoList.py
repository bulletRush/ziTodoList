import yaml

from bottle import route, run, debug, template, error, request
import json


# only needed when you run Bottle on mod_wsgi
@route('/todolist')
def display_toto_list():
    # Load YAML database
    task_list = load_tasklist()
    output = template('./templates/todolist', task_list = task_list)
    return output

@route('/todolist', method='POST')
def new_task():
    # Insert new task and dump
    new_task = {'Title':request.POST['taskTitle'],'Description':request.POST['taskDescription']}
    task_list = load_tasklist()
    task_list += [new_task]
    dump_tasklist(task_list)
    return json.dumps({'new_task':new_task});

def load_tasklist():
    with open("./data/todolist.yaml", 'r') as stream:
        try:
            task_list = yaml.load(stream)
        except yaml.YAMLError as exc:
            print(exc)
    return task_list

def dump_tasklist(data):
    dump_file = open("./data/todolist.yaml", 'w')
    yaml.dump(data,dump_file)

@error(403)
def error403(code):
    return 'Error 403 !'

@error(404)
def error404(code):
    return 'Error 404 !'

debug(True)
run(reloader=True)
