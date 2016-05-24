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
        $('#contactHistoryTable > tbody').empty();
    });
	
    bindEditButtons();	
    bindDelButtons();  
    bindAddButton();  
    // Init date picker
    $(function() {
        $("[name='newContactDate']").datepicker({numberOfMonths: 2, dateFormat: "dd/mm/yy", showWeek: true});
    });
    // Reset new contact field
    $("[name='newContactName']").val("");
    $("[name='newContactDate']").val("");
    $("[name='newContactComment']").val("");
});

// Handle add new contact button
function bindAddButton(){
    $(".newContactBtn").unbind('click');
    $(".newContactBtn").on('click', function(e){        
        var name = $("[name='newContactName']").val();
        var date = $("[name='newContactDate']").val();
        var comment = $("[name='newContactComment']").val();
        // Remove contact history
        $.ajax({
            type : "POST",
            url: "addContactHistory",
            data : {name: name, date: date, comment: comment},
            dataType : 'json',
            contentType : 'application/json; charset=utf-8'
        }).done(function(response) {
            // Reset new contact field
            $("[name='newContactName']").val("");
            $("[name='newContactDate']").val("");
            $("[name='newContactComment']").val("");
            // Add contact
            if ($("[data-name='"+name+"']").length){
            	$("[data-name='"+name+"'] td:nth-child(2)").text(date);
            	$("[data-name='"+name+"'] td:nth-child(3)").text(comment);
            }else{
                $("#allContactHistoryTable").append('<tr data-name="'+name+'"><td>'+name+'</td><td>'+date+'</td><td>'+comment+'</td><td><button type="button" class="btn btn-primary editBtn"><span class="glyphicon glyphicon-list"></span></button></td></tr>');
                bindEditButtons();
            }
        });
    });
}


// Handle remove event
function bindDelButtons(){
    $(".delBtn").unbind('click');
    $(".delBtn").on('click', function(e){        
    	var name = $('#contactName').text();
        var contactItem = $(this).closest('tr');
        var idxContactItem = contactItem.parent().children('tr').index(contactItem);
        // Remove contact history
        $.ajax({
            type : "POST",
            url: "delContactHistory",
            data : {name: name, idx: idxContactItem},
            dataType : 'json',
            contentType : 'application/json; charset=utf-8'
        }).done(function(response) {
            // Remove div
            contactItem.empty();            
        });
    });
}

//Handle edit event
function bindEditButtons(){
    $(".editBtn").unbind('click');
    $(".editBtn").on('click', function(e){
        var name = $(this).closest('tr').attr("data-name");
        // Retrieve task details
        $.ajax({
            type : "POST",
            url: "getContactHistory",
            data : {name: name},
            dataType : 'json',
            contentType : 'application/json; charset=utf-8'
        }).done(function(response) {
            // Fill name in title
            $('#newTaskPopup #contactName').text(name);
            // Fill history from POST request
            var history = response['contactHistory'];
            for(var i=0;i<history.length;i++){
                var tr="<tr>";
                var td1="<td>"+history[i]["Mean"]+"</td>";
                var td2="<td>"+history[i]["Date"]+"</td>";
                var td3="<td>"+history[i]["Comment"]+"</td>";
                var td4='<td><button type="button" class="btn btn-danger btn-sm delBtn"><span class="glyphicon glyphicon-remove"></span></button></td></tr>';                    
                $("#contactHistoryTable").append(tr+td1+td2+td3+td4);                 
            };
            // Bind buttons
            bindDelButtons(); 
            // Popup task form
            $('#newTaskPopup').modal('show');
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

                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </nav>


    <!-- Task table -->
    <table id="allContactHistoryTable" class="table table-striped">
        <thead>
            <tr>
                <th>Name</th>
                <th>Last Contact Date</th>
                <th>Comment</th>
                <th></th>
            </tr>
            <tr>
                <td><input type="text" class="form-control" name="newContactName" placeholder="Enter name"></td>
                <td><input type="text" class="form-control" name="newContactDate"></td>
                <td><input type="text" class="form-control" name="newContactComment"></td>
                <td>                    
                    <button type="button" class="btn btn-success newContactBtn">
                        <span class="glyphicon glyphicon-plus"></span>
                    </button>
                </td>                
            </tr>            
        </thead>
        <tbody>
            %for name, last_contact in crm_data.iteritems():
            <tr data-name="{{name}}">
                <td>{{name}}</td>
                <td>{{last_contact[-1]["Date"]}}</td>
                <td>{{last_contact[-1]["Comment"]}}</td>                  
                <td>
                    <button type="button" class="btn btn-primary editBtn">
                        <span class="glyphicon glyphicon-list"></span>
                    </button>
                </td>
            </tr>
            %end
        </tbody>
    </table>    

<div class="modal fade" id="newTaskPopup" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">Contact history for <span id='contactName'></span></h4>
                </div>                
                <div class="modal-body">                    
                    <table id="contactHistoryTable" class="table table-striped">
                        <thead>
                            <tr>
                                <th>Mean</th>
                                <th>Date</th>
                                <th>Comment</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>

                        </tbody>
                    </table>

                </div>
            </div>
        </div>
    </div>    
</body>
</html>


