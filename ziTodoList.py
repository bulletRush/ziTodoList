import json
import os.path

import bottle
from bottle import route, run, debug, template, error, request
import yaml



# Set globale
source_dir = os.path.dirname(__file__)
bottle.TEMPLATE_PATH.insert(0,os.path.join(source_dir,'templates'))




# only needed when you run Bottle on mod_wsgi
from bottle import default_app

@route('/admin')
def admin():
    output = template(os.path.join(source_dir,'templates/admin'))
    return output

@route('/todolist')
def display_todo_list():
    # Load YAML database
    task_list = load_tasklist()
    output = template(os.path.join(source_dir,'templates/todolist'), task_list = task_list)
    return output

@route('/setTask', method='POST')
def set_task():
    task_id = int(request.POST['taskId'])
    task_list = load_tasklist()
    # Interpret answer
    if "taskStatus" in request.POST.keys():
        status = "Todo"
    else:
        status = "Done"    
    # Build task from request
    new_task = {'Title':request.POST['taskTitle'],
                'Description':request.POST['taskDescription'],
                'Status':status,
                'Due Date':request.POST['taskDueDate']}
    task_list[task_id] = new_task
    dump_tasklist(task_list)
    return json.dumps({'new_task':new_task});

@route('/getTask',method='GET')
def get_task():
    task_list = load_tasklist()
    return json.dumps({'task':task_list[int(request.GET['taskId'])]});

@route('/getNewId',method='GET')
def get_id():
    task_list = load_tasklist()
    if task_list: 
        new_id = max(task_list.keys())+1
    else:
        new_id = 1
    return json.dumps(new_id);

@route('/removeTask',method='POST')
def del_task():
    task_list = load_tasklist()
    task_id = int(request.POST['taskId'])
    del task_list[task_id]
    dump_tasklist(task_list)

@route('/migrateDatabase',method='POST')
def migrate_database():
    # Define default task
    default_task = {"Description": None, 
                    "Due Date": None, 
                    "Status": None,
                    "Title":None}
    # Load task list
    task_list = load_tasklist()
    migrated_task_list={}
    # Loop over all tasks
    for id_task, task in task_list.iteritems():
        # Add missing keys with default content
        migrated_task_list[id_task] = dict(default_task.items()+task.items())
    # Dump new task list
    dump_tasklist(migrated_task_list)
    
    
def load_tasklist():
    with open(os.path.join(source_dir,"data/todolist.yaml"), 'r') as stream:
        try:
            task_list = yaml.load(stream)
        except yaml.YAMLError as exc:
            print(exc)
    return task_list

def load_yaml_data(database_name):
    with open(os.path.join(source_dir,"data/"+database_name+".yaml"), 'r') as stream:
        try:
            data = yaml.load(stream)
        except yaml.YAMLError as exc:
            print(exc)
    return data

def dump_yaml_data(database_name, data):
    dump_file = open(os.path.join(source_dir,"./data/"+database_name+".yaml"), 'w')
    yaml.dump(data,dump_file, width = float("inf"))
    

def dump_tasklist(data):
    dump_file = open(os.path.join(source_dir,"./data/todolist.yaml"), 'w')
    yaml.dump(data,dump_file, width = float("inf"))

@error(403)
def error403(code):
    return 'Error 403 !'

@error(404)
def error404(code):
    return 'Error 404 !'

application = default_app()
# Import plugins
import pyDashBoard.crm