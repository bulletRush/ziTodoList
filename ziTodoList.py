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

@route('/setTask', method='POST')
def set_task():
    task_id = int(request.POST['taskId'])
    task_list = load_tasklist()
    # Build task from request
    new_task = {'Title':request.POST['taskTitle'],'Description':request.POST['taskDescription']}
    if task_id >= len(task_list):
        # New task to insert
        task_list += [new_task]
    else:
        # Existing task to edit
        task_list[task_id] = new_task
    dump_tasklist(task_list)
    return json.dumps({'new_task':new_task});

@route('/getTask',method='GET')
def get_task():
    task_list = load_tasklist()
    return json.dumps({'task':task_list[int(request.GET['taskId'])]});
    
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
