<?php
// MySQL
$mysqli = @new mysqli('localhost', 'root', 'root');

$mysql_running = true;
if (mysqli_connect_errno()) {
  $mysql_running = false;
} else {
  $mysql_version = $mysqli->server_info;
}

$mysqli->close();
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Vagrant LEMP stack</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <!-- Latest compiled and minified CSS -->
  <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
  <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.6.1/css/font-awesome.min.css">
  <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.2/jquery.min.js" charset="utf-8"></script>
  <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" charset="utf-8"></script>
  <style type="text/css">
  html, body {
    height: 100%;
  }
  #wrap {
    min-height: 100%;
    height: auto !important;
    height: 100%;
    margin: 0 auto -60px;
  }
  #push, #footer {
    height: 60px;
  }
  #footer {
    background-color: #f5f5f5;
    text-align: center;
  }
  @media (max-width: 767px) {
    #footer {
      margin-left: -20px;
      margin-right: -20px;
      padding-left: 20px;
      padding-right: 20px;
    }
  }
  .container .credit {
    margin: 20px 0;
  }
  .page-header i {
    float: left;
    margin-top: -5px;
    margin-right: 12px;
    font-size: 4em;
  }
  table td:first-child {
    width: 300px;
  }
  .tomato{
    color: tomato
  }
  h3{
    text-align: center;
  }
  </style>
</head>
<body>
  <div id="wrap">
    <div class="container">
      <div class="row">
           <div class="col-lg-8 col-lg-offset-2 col-md-10 col-md-offset-1">
             <div class="page-header">
               <i class="fa fa-lightbulb-o fa-3" aria-hidden="true"></i>
               <h1>It works!</h1>
             </div>
             <p class="lead">The Virtual Machine is up and running, yay! Here's some additional information you might need.</p>
             <div class="row">
               <div class="col-sm-12">
                 <div class="panel-group" id="accordion">
                   <div>
                     <div class="row">
                       <div class="col-sm-4">
                         <div class="">
                           <div data-toggle="collapse" data-parent="#accordion">
                             <ul id="tabs" class="nav nav-pills nav-stacked" data-collapse-toggle="collapseOne" data-tabs="tabs">
                               <li class="active"><a href="#item1" data-toggle="tab">Installed software</a></li>
                               <li><a href="#item2" data-toggle="tab">PHP Loaded Extensions</a></li>
                               <li><a href="#item3" data-toggle="tab">MySQL Credentials</a></li>
                             </ul>
                           </div>
                         </div>
                       </div>
                       <div class="col-sm-8">
                         <div id="collapseOne" class="panel panel-default panel-collapse collapse in">
                           <div class="panel-body">
                             <div class="tab-content">
                               <div class="tab-pane fade in active" id="item1">
                                 <h3>Installed software</h3>
                                 <div class="table-responsive">
                                   <table class="table table-striped">
                                     <tr>
                                       <td>PHP Version</td>
                                       <td><?php echo phpversion(); ?></td>
                                     </tr>
                                     <tr>
                                       <td>MySQL running</td>
                                       <td>
                                         <?php
                                           echo ($mysql_running ? '¡Hell Yeah!' : 'Oh balls!!');
                                         ?>
                                         <i class="fa <?php echo ($mysql_running ? 'fa-check tomato' : 'fa-times'); ?> " aria-hidden="true"></i></td>
                                     </tr>
                                     <tr>
                                       <td>MySQL version</td>
                                       <td><?php echo ($mysql_running ? $mysql_version : 'N/A'); ?></td>
                                     </tr>
                                     <tr>
                                       <td>NGINX</td>
                                       <td><?php echo $_SERVER['SERVER_SOFTWARE']; ?></td>
                                     </tr>
                                   </table>
                                 </div>
                               </div>
                               <div class="tab-pane fade" id="item2">
                                 <h3>PHP Loaded Extensions</h3>
                                 <div class="table-responsive">
                                 <table class="table table-striped">
                                   <?php
                                   $extdir   = ini_get('extension_dir');
                                   $modules  = get_loaded_extensions();
                                   foreach($modules as $m){
                                         $lib  = $extdir.'/'.$m.'.so';
                                   echo '
                                   <tr>
                                     <td>'.$m.'</td>'; ?>
                                       <td><?php echo (file_exists($lib) ? '¡Hell Yeah!' : 'Oh balls!!' ); ?> <i class="fa <?php echo (file_exists($lib) ? 'fa-check tomato' : 'fa-times' ); ?>" aria-hidden="true"></i></td>
                                   <?php
                                   echo '</tr>';
                                   }
                                   ?>
                                 </table>
                               </div>
                             </div>
                               <div class="tab-pane fade" id="item3">
                                 <h3>MySQL Credentials</h3>
                                 <div class="table-responsive">
                                 <table class="table table-striped">
                                   <tr>
                                     <td>Hostname</td>
                                     <td>localhost</td>
                                   </tr>
                                   <tr>
                                     <td>Username</td>
                                     <td>root</td>
                                   </tr>
                                   <tr>
                                     <td>Password</td>
                                     <td>root</td>
                                   </tr>
                                   <tr>
                                     <td colspan="2"><em>Note: External access is enabled! Just use <strong><?php echo $_SERVER['SERVER_ADDR'] ?></strong> as host.</em></td>
                                   </tr>
                                 </table>
                               </div>
                             </div>
                             </div><!-- / my-tab-content -->
                           </div><!-- / panel-body -->
                         </div><!-- / panel-collapse collapse in -->
                       </div><!-- / col-lg-8 -->
                     </div><!-- / row -->
                   </div><!-- / panel panel-default -->
                 </div><!-- / accordion -->
               </div><!-- / col-lg-12 -->
             </div>
           </div>
      </div>
    </div>

    <div id="push"></div>
  </div>

  <div id="footer">
    <div class="container">
      <p class="muted credit"><a href="https://github.com/abr4xas/vagrant-config" target="_blank">Vagrant LEMP Stack</a> by <a href="https://github.com/abr4xas" traget="_blank">abr4xas</a>.</p>
    </div>
  </div>
</body>
</html>
