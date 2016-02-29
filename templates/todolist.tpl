<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>ziTodoList</title>
<!-- jQuery  - Minified version -->
<script src="//code.jquery.com/jquery-2.2.1.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>

<!-- Bootstrap from CDN -->
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">
<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>

<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>
<body>

    <!-- Button trigger modal -->
    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#newTaskForm">New Task</button>

    <table class="table table-striped">
        <thead>
            <tr>
                <th>Title</th>
                <th>Description</th>
            </tr>
        </thead>
        <tbody>
            %for task in task_list:
            <tr>
                <td>{{task['Title']}}</td>
                <td>{{task['Description']}}</td>
            </tr>
            %end
        </tbody>
    </table>
    <!-- New task form -->
    <!-- Modal -->
    <div class="modal fade" id="newTaskForm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">New Task Definition</h4>
                </div>
                <div class="modal-body">
                    <form>
                        <fieldset class="form-group">
                            <label for="taskTitle">Task title</label>
                            <input type="text" class="form-control" id="taskTitle" placeholder="Enter task title">
                        </fieldset>
                        <fieldset class="form-group">
                            <label for="taskDescription">Task description</label>
                            <textarea class="form-control" id="taskDescription" rows="3"></textarea>
                        </fieldset>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Create task</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>


