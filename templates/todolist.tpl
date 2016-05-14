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
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
  

<!-- Bootstrap from CDN -->
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">
<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>

<!-- For toggle with sliding effects -->
<link href="https://gitcdn.github.io/bootstrap-toggle/2.2.2/css/bootstrap-toggle.min.css" rel="stylesheet">
<script src="https://gitcdn.github.io/bootstrap-toggle/2.2.2/js/bootstrap-toggle.min.js"></script>

<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

<script>
	$(document).ready(function() {
		// Empty form in modal when modal closes
		$('.modal').on('hidden.bs.modal', function(){
		    $(this).find('form')[0].reset();
		    $("[name='taskDescription']").text("");
		    $("[name='taskStatus']").bootstrapToggle('on');
		});
		// format task depending on status
		formatTaskUponStatus();
		// Bind all edit buttons
		bindAllButtons();
        // Define filters and apply
        applyFilterStatus();
        $('#filterStatus').change(function() {
            applyFilterStatus();
        });
        // Init date picker
        $(function() {
       	    $("[name='taskDueDate']").datepicker({numberOfMonths: 2, dateFormat: "dd/mm/yy", showWeek: true});
        });
		
		// Handle form submission with AJAX
		$("#newTaskForm").submit(function(e) {
			// Prevent default submit form action
			e.preventDefault();
			// Submit form through AJAX
			var formData = JSON.stringify($("#newTaskForm").serializeArray());
			$.ajax({
				type : "POST",
				url : "setTask",
				data : $("#newTaskForm").serialize(),
				dataType : 'json',
				contentType : 'application/json; charset=utf-8'
			}).done(function(response) {
				var id = $("[name='taskId']").val();
				// Close modal
				$('#newTaskPopup').modal('toggle');
				// Add task to tasklist
				var title = response['new_task']['Title'];
				var description = response['new_task']['Description'];
				var dueDate = response['new_task']['Due Date'];
				// Define task
				var task = '<tr data-taskStatus="'+response['new_task']['Status']+'" id="'+id+'"><td>'+id+'</td><td>'+title+'</td><td>'+description+'</td><td>'+dueDate+'</td>'+'<td><button type="button" class="btn btn-primary editBtn"><span class="glyphicon glyphicon-pencil"></span></button> <button type="button" class="btn btn-danger delBtn"><span class="glyphicon glyphicon-remove"></span></button></td>'+'</tr>';
				if ($('#'+id).length)
                    // Existing task
                    $('#'+id).replaceWith(task);				    					
				else
					// New task
					$('#taskTable tbody').append(task);
			    // Attach event to button
	            bindAllButtons();
			    // Grey all done tasks
			    formatTaskUponStatus();
			    // Apply filters
			    applyFilterStatus();
			});
        });
		// Handle new task event
		$("#newTaskBtn").on('click', function(e){
			// Set id of new task
			$.ajax({
				type: "GET",
				url: "getNewId"
			}).done(function(response){
				var newId = response;
				$("[name='taskId']").val(newId);
			});
			// Popup form
			$('#newTaskPopup').modal('show');
		});

		
	});

    function formatTaskUponStatus(){
    	$("tr[data-taskStatus='Todo']").css('font-style', 'normal').css("text-decoration", "none");
        $("tr[data-taskStatus='Done']").css('font-style', 'italic').css("text-decoration", "line-through");
    }
    
    function applyFilterStatus(){
        if ($('#filterStatus').prop('checked')){
            $("tr[data-taskStatus='Done']").show();
        }else{
            $("tr[data-taskStatus='Done']").hide();
        }
    }
    
	// Bind all buttons
	function bindAllButtons(){
		bindEditButtons();
		bindDelButtons();	
    }
	
	// Handle edit event
    function bindEditButtons(){
    	$(".editBtn").unbind('click');
        $(".editBtn").on('click', function(e){
            var taskId = $(this).closest('tr').attr("id");
            // Retrieve task details
            $.ajax({
                type : "GET",
                url: "getTask",
                data : {taskId: taskId},
                dataType : 'json',
                contentType : 'application/json; charset=utf-8'
            }).done(function(response) {
                // Fill form with those informations
                $("[name='taskId']").val(taskId);
                $("[name='taskTitle']").val(response['task']['Title']);
                $("[name='taskDescription']").text(response['task']['Description']);
                $("[name='taskDueDate']").val(response['task']['Due Date']);
                if (response['task']['Status'] == "Todo") {
                	$("[name='taskStatus']").bootstrapToggle('on');
                } else {
                	$("[name='taskStatus']").bootstrapToggle('off')
                }
                $("[name='taskStatus']").prop("checked", response['task']['Status'] == "Todo")
                // Popup task form
                $('#newTaskPopup').modal('show');
            });
        });
    }
	
	// Handle remove event
    function bindDelButtons(){
    	$(".delBtn").unbind('click');
        $(".delBtn").on('click', function(e){
            var taskId = $(this).closest('tr').attr("id");
            // Retrieve task details
            $.ajax({
                type : "POST",
                url: "removeTask",
                data : {taskId: taskId},
            }).done(function(response) {
            	$('#'+taskId).remove();
            });
        });
    }
</script>
<style>
body {
	padding-top: 80px;
}
</style>
</head>

<body>
    <nav style="margin-bottom: 100px;" class="navbar navbar-inverse navbar-fixed-top">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                    <span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">ziTodoList</a>
            </div>

            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav pull-left">
                    <li>
                        <div class='navbar-btn'>
                            <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                GoTo <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a href="todolist">Todo List</a></li>
                                <li><a href="crm">CRM</a></li>
                                <li role="separator" class="divider"></li>
                                <li><a href="admin">Admin</a></li>
                            </ul>
                        </div>
                    </li>
                </ul>

                <ul class="nav navbar-nav pull-right">
                    <li>
                        <div class='navbar-btn'>
                            <!-- Button trigger modal -->
                            <button id="newTaskBtn" type="button" class="btn btn-primary">
                                <span class="glyphicon glyphicon glyphicon-plus"></span> New Task
                            </button>
                            <!-- Filters -->
                            <input id="filterStatus" checked data-toggle="toggle" data-on="Show Done" data-off="Hide Done" data-onstyle="primary" type="checkbox">
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </nav>


    <!-- Task table -->
    <table id="taskTable" class="table table-striped">
        <thead>
            <tr>
                <th>#</th>
                <th>Title</th>
                <th>Description</th>
                <th>Due Date</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            %for id, task in task_list.iteritems():
            <tr data-taskStatus="{{task['Status']}}" id="{{id}}">
                <td>{{id}}</td>
                <td>{{task['Title']}}</td>
                <td>{{task['Description']}}</td>
                <td>{{task['Due Date']}}</td>               
                <td>
                    <button type="button" class="btn btn-primary editBtn">
                        <span class="glyphicon glyphicon-pencil"></span>
                    </button>
                    <button type="button" class="btn btn-danger delBtn">
                        <span class="glyphicon glyphicon-remove"></span>
                    </button>
                </td>
            </tr>
            %end
        </tbody>
    </table>
    <!-- New task form -->
    <!-- Modal -->
    <div class="modal fade" id="newTaskPopup" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">New Task Definition</h4>
                </div>
                <div class="modal-body">
                    <form id="newTaskForm">
                        <fieldset class="form-group">
                            <input type="hidden" class="form-control" name="taskId">
                        </fieldset>
                        <fieldset class="form-group">
                            <label for="taskTitle">Task title</label>
                            <input type="text" class="form-control" name="taskTitle" placeholder="Enter task title">
                        </fieldset>
                        <fieldset class="form-group">
                            <label for="taskDescription">Task description</label>
                            <textarea class="form-control" name="taskDescription" rows="3"></textarea>
                        </fieldset>
                        <fieldset class="form-group">
                            <span style="float:left">
                                <label for="taskDueDate">Due date</label>
                                <input type="text" name="taskDueDate">
                            </span>        
                             <span style="float:right">                   
                                <label for="taskStatus">Status</label>
                                <input name="taskStatus" checked data-toggle="toggle" data-width="100" data-on="ToDo" data-off="Done" data-onstyle="primary" data-offstyle="success" type="checkbox" value="Todo">
                            </span>
                        </fieldset>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>


