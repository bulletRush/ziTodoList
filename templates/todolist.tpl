<!DOCTYPE html>
<html lang="en">
<head>
<title>ziTodoList</title>
</head>
<body>
    <table>
        <thead>
            <tr>                
                <th>#</th>
                <th>Title</th>
                <th>Description</th>
            </tr>
        </thead>
        <tbody>
            %for id, task in task_list.iteritems():
            <tr id="{{id}}">
                <td>{{id}}</td>
                <td>{{task['Title']}}</td>
                <td>{{task['Description']}}</td>              
            </tr>
            %end
        </tbody>
    </table>
</body>
</html>


