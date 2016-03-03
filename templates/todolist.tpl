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

<script>
    function bindEditButtons(node) {
        return p1 * p2;              // The function returns the product of p1 and p2
    }
	$(document).ready(function() {
		// Empty form in modal when modal closes
		$('.modal').on('hidden.bs.modal', function(){
		    $(this).find('form')[0].reset();		    
		});
		// Bind all edit buttons
		bindEditButtons();
		
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
				// Define task
				var task = '<tr><td>'+id+'</td><td>'+title+'</td><td>'+description+'</td>'+'<td><button type="button" class="btn btn-primary"><span class="glyphicon glyphicon-pencil"></span> Edit</button></td>'+'</tr>';
				if (id == $('#taskTable tr').length-1)
				    // New task
					$('#taskTable tbody').append(task);
				else
					// Existing task
					$('#taskTable tbody tr').eq(id).replaceWith(task)
			    // Attach event to button
	            bindEditButtons();
			});
        });
		// Handle new task event
		$("#newTaskBtn").on('click', function(e){
			// Set id of new task
			$("[name='taskId']").val($('#taskTable tr').length-1);
			// Popup form
			$('#newTaskPopup').modal('show');
		});

		
	});

	// Handle edit event
    function bindEditButtons(){
        $("table tr button").on('click', function(e){
            var taskId = $(this).closest('tr').index();
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
                // Popup task form
                $('#newTaskPopup').modal('show');
            });
        });
    }
</script>
</head>
<body>

    <!-- Button trigger modal -->
    <button id="newTaskBtn" type="button" class="btn btn-primary">New Task</button>

    <table id="taskTable" class="table table-striped">
        <thead>
            <tr>                
                <th>#</th>
                <th>Title</th>
                <th>Description</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            %for id,task in enumerate(task_list):
            <tr>
                <td>{{id}}</td>
                <td>{{task['Title']}}</td>
                <td>{{task['Description']}}</td>
                <td>
                    <button type="button" class="btn btn-primary">
                        <span class="glyphicon glyphicon-pencil"></span> Edit
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
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>


