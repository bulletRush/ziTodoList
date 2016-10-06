#!/usr/bin/env python
# -*- coding: utf-8 -*-
import init
import json
import os.path
import datetime
import bottle
import sys
print sys.path
from bottle import route, run, debug, template, error, request
import yaml
from models import Task, Employee
from playhouse.shortcuts import model_to_dict
# Set globale
source_dir = os.path.dirname(__file__)
bottle.TEMPLATE_PATH.insert(0, os.path.join(source_dir, 'templates'))

# only needed when you run Bottle on mod_wsgi
from bottle import default_app


class ModelEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, datetime.datetime):
            return o.strftime("%d/%m/%Y")
        return json.JSONEncoder.default(self, o)


@route('/admin')
def admin():
    output = template(os.path.join(source_dir, 'templates/admin'))
    return output


@route('/todoList')
def display_todo_list():
    task_list = [task for task in Task.select()]
    output = template(os.path.join(source_dir, 'templates/todoList'), task_list=task_list)
    return output


@route('/setTask', method='POST')
def set_task():
    if 'taskId' not in request.POST or request.POST['taskId'] == '':
        task_id = None
    else:
        task_id = int(request.POST['taskId'])
    # Interpret answer
    # Build task from request
    new_task = Task()
    new_task.title = request.POST['taskTitle']
    new_task.description = request.POST['taskDescription']
    if "taskStatus" in request.POST:
        new_task.status = request.POST["taskStatus"]
    new_task.due_date = datetime.datetime.strptime(request.POST['taskDueDate'], "%d/%m/%Y")
    if task_id is not None:
        new_task.id = task_id
    new_task.save()
    return json.dumps({'new_task': model_to_dict(new_task)}, cls=ModelEncoder)


@route('/getTask', method='GET')
def get_task():
    task = Task.select().where(Task.id == request.GET['taskId']).get()
    return json.dumps(model_to_dict(task), cls=ModelEncoder);


@route('/removeTask', method='POST')
def del_task():
    task_id = int(request.POST['taskId'])
    Task.delete().where(Task.id == task_id).execute()


@route('/employeeList')
def display_employee_list():
    employee_list = [employee for employee in Employee.select()]
    output = template(os.path.join(source_dir, 'templates/employeeList'), employee_list=employee_list)
    return output


@route('/setEmployee', method='POST')
def set_employee():
    if 'employeeId' not in request.POST or request.POST['employeeId'] == '':
        employee_id = None
    else:
        employee_id = int(request.POST['employeeId'])
    employee_list = [employee for employee in Employee.select()]
    new_employee = Employee()
    new_employee.name = request.POST['employeeName']
    new_employee.birthday = datetime.datetime.strptime(request.POST['employeeBirthday'], "%d/%m/%Y")
    new_employee.hire_date = datetime.datetime.strptime( request.POST['employeeHireDate'], "%d/%m/%Y")
    new_employee.probation =  int(request.POST['employeeProbation'])
    if employee_id is not None:
        new_employee.id = employee_id
    new_employee.save()
    return json.dumps({'new_employee': model_to_dict(new_employee)}, cls=ModelEncoder)


@route('/getEmployee', method='GET')
def get_employee():
    employee = Employee.select().where(Employee.id == request.GET['employeeId']).get()
    return json.dumps({'employee': model_to_dict(employee)}, cls=ModelEncoder)


@route('/removeEmployee', method='POST')
def del_employee():
    employee_id = int(request.POST['employeeId'])
    Employee.delete().where(Employee.id == employee_id).execute()


@route('/migrateDatabase', method='POST')
def migrate_database():
    # Define default task
    default_task = {"Description": None,
                    "Due Date": None,
                    "Status": None,
                    "Title": None}
    # Load task list
    task_list = load_tasklist()
    migrated_task_list = {}
    # Loop over all tasks
    for id_task, task in task_list.iteritems():
        # Add missing keys with default content
        migrated_task_list[id_task] = dict(default_task.items() + task.items())
    # Dump new task list
    dump_tasklist(migrated_task_list)


@error(403)
def error403(code):
    return 'Error 403 !'


@error(404)
def error404(code):
    return 'Error 404 !'


def is_same_day(d1, d2):
    if d1.day == d2.day and d1.month == d2.month:
        return True
    return False


def generate_today_todo():
    employee_list = [employee for employee in Employee.select()]
    todo_list = [task for task in Task.select()]
    todo_map = {}
    for todo in todo_list:  # type: Task
        todo_map[todo.title] = todo
        print todo
    now = datetime.datetime.now()
    for employee in employee_list:  # type: Employee
        name = employee.name
        birthday = employee.birthday
        hireDate = employee.hire_date
        probation = employee.probation
        if is_same_day(birthday, now):
            key = u"{0}的生日".format(name)
            if key in todo_map:
                print u'{0} exists, skip'.format(key)
            else:
                new_task = Task()
                new_task.title = key
                new_task.description = u'{0}的生日到了, 他的生日是：{1}年{2}月{3}日'.format(
                    name, birthday.year, birthday.month, birthday.day,
                )
                new_task.status = 'Todo'
                new_task.due_date = now
                new_task.save()
        end_date = hireDate + datetime.timedelta(days=probation)
        if is_same_day(end_date, now):
            key = u"{0}的试用期结束了".format(name)
            if key in todo_map:
                print u'{0} exists, skip'.format(key)
            else:
                new_task = Task()
                new_task.title = key
                new_task.description = u'{0}入职时间：{1}年{2}月{3}日，试用期：{4}天'.format(
                    name, hireDate.year, hireDate.month, hireDate.day, probation
                )
                new_task.status = 'Todo'
                new_task.due_date = now
                new_task.save()
        pass
    pass  #

application = default_app()
# Import plugins
# import pyDashBoard.crm
