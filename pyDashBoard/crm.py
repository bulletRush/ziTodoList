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
    # Handle case when all entry for a given contact are removed
    if len(crm_data[request.POST['name']]) == 0:
        del crm_data[request.POST['name']]
    dump_yaml_data("crm",crm_data)
    return json.dumps({})

@route('/addContactHistory', method='POST')
def addContactHistory():
    crm_data = load_yaml_data("crm")
    name = request.POST['name']
    date = request.POST['date']
    comment = request.POST['comment']
    if name in crm_data.keys():
        crm_data[name] += [{"Comment":comment, "Date":date,"Mean":"Phone"}]
    else:
        crm_data[name] = [{"Comment":comment, "Date":date,"Mean":"Phone"}]
    dump_yaml_data("crm",crm_data)
    return json.dumps({})
    