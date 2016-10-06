from peewee import *

database = SqliteDatabase('data\data.db', **{})


class UnknownField(object):
    def __init__(self, *_, **__): pass


class BaseModel(Model):
    class Meta:
        database = database


class Employee(BaseModel):
    birthday = DateTimeField()
    hire_date = DateTimeField()
    name = CharField(unique=True)
    probation = IntegerField()

    class Meta:
        db_table = 'employee'


class SqliteSequence(BaseModel):
    name = UnknownField(null=True)  # 
    seq = UnknownField(null=True)  # 

    class Meta:
        db_table = 'sqlite_sequence'


class Task(BaseModel):
    description = CharField()
    due_date = DateTimeField()
    status = CharField()
    title = CharField(unique=True)

    class Meta:
        db_table = 'task'
