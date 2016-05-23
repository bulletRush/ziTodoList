from bottle import route, template, request
from ziTodoList import load_yaml_data, dump_yaml_data
import json

@route('/crm')
def crm():
    crm_data = load_yaml_data("crm")
    output = template('crm', crm_data = crm_data)
    return output   

@route('/getContactHistory', method='POST')
def getContactHistory():
    crm_data = load_yaml_data("crm")
    return json.dumps({'contactHistory':crm_data[request.POST['name']]})

@route('/delContactHistory', method='POST')
def delContactHistory():
    crm_data = load_yaml_data("crm")
    del crm_data[request.POST['name']][int(request.POST['idx'])]
    dump_yaml_data("crm",crm_data)
    return json.dumps({})
