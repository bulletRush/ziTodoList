import os.path

from bottle import default_app
from bottle import route,template
import yaml


source_dir = os.path.dirname(__file__)

@route('/todolist')
def display_toto_list():
    # Load YAML database
    task_list = load_tasklist()
    output = template(os.path.join(source_dir,'templates/todolist'), task_list = task_list)
    return output
    
def load_tasklist():
    with open(os.path.join(source_dir,"data/todolist.yaml"), 'r') as stream:
        try:
            task_list = yaml.load(stream)
        except yaml.YAMLError as exc:
            print(exc)
    return task_list

application = default_app()
