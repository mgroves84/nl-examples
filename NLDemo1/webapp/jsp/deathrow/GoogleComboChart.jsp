<%@ page import = "users.nluthra.MyServerSideClass" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Visualization Examples -- Splunk Java combined with JavaScript SDK</title>
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Le styles -->
    <link href="../resources/bootstrap.css" rel="stylesheet">
    <link href="../resources/prettify.css" type="text/css" rel="stylesheet" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
    <style type="text/css">
      body {
      }
      
      section {
        padding-top: 60px;
      }
      
      .code {
        font-family: Monaco, 'Andale Mono', 'Courier New', monospace;
      }
      
      button.run {
        float: right;
      }
      
      pre {
        overflow-x: auto;
      }
      
      code {
        font-size: 12px!important;
        background-color: ghostWhite!important;
        color: #444!important;
        padding: 0 .2em!important;
        border: 1px solid #DEDEDE!important;
      }
      
      #google-container.active { 
        height: 250px;
        margin-bottom: 20px;
      }
      
      #rickshaw-container.active { 
        height: 250px;
        width: 100%;
        
        position: relative;
        margin-bottom: 20px;
      }
      
      #rickshaw-chart {
        position: relative;
        left: 40px;
      }
      
      .rickshaw_legend span {
        color: white;
      }
      .rickshaw_legend a.action {
        color: white;
      }
      
      #y_axis {
        width: 40px;
        position: absolute;
        top: 0;
        bottom: 0;
        width: 40px;
      }
      
      .secondary-nav ul.dropdown-menu  {
        padding: 10px;
      }
      
      .secondary-nav .dropdown-menu li {
        width: 100%;
      }
      
      .secondary-nav .dropdown-menu li input {
        width: 200px;
        margin: 1px auto;
        margin-bottom: 8px;
      }
    </style>

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="images/favicon.ico">
    <link rel="apple-touch-icon" href="images/apple-touch-icon.png">
    <link rel="apple-touch-icon" sizes="72x72" href="images/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="114x114" href="images/apple-touch-icon-114x114.png">
    
    <script type="text/javascript" src="../resources/json2.js"></script>
    <script type="text/javascript" src="../resources/jquery.min.js"></script>
    <script type="text/javascript" src="../resources/prettify.js"></script>
    <script type="text/javascript" src="../resources/bootstrap.tabs.js"></script>
    <script type="text/javascript" src="../resources/bootstrap.dropdown.js"></script>
    <script type="text/javascript" src="../resources/jquery.placeholder.min.js"></script>
    <script type="text/javascript" src="../resources/rickshaw/d3.min.js"></script>
    <script type="text/javascript" src="../resources/rickshaw/d3.layout.min.js"></script>
    <script type="text/javascript" src="../resources/rickshaw/rickshaw.min.js"></script>
    <script type="text/javascript" src="../resources/client/splunk.js"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load('visualization', '1', {packages: ['corechart']});
    </script>
    <script>       
      $.fn.pVal = function() {
        return this.hasClass('placeholder') ? '' : this.val();
      };
       
      utils = splunkjs.Utils;
      
      $(function() {
        prettyPrint();
        
        var head = $("head");
        
        var injectCode = function(code) {
          var sTag = document.createElement("script");
          sTag.type = "text/javascript";
          sTag.text = code;
          $(head).append(sTag);
          
          return sTag;
        }
        
        var getCode = function(id) {
          var code = "";
          $(id + " pre li").each(function(index, line) {
            var lineCode = "";
            $("span" ,line).each(function(index, span) {
              if ($(span).hasClass("com")) {
                lineCode += " ";
              }
              else {
                lineCode += $(span).text();
              }
            });
            
            lineCode += "\n";
            code += lineCode;
          });
          
          return code;
        }
        
        $("#google-run").click(function() {
          // Get the code except comments
          var code = getCode("#google");
          
          var tag = null;
          
          // setup the global variables we need
          done = callback = function() {
            $(tag).remove();
          };
          
          $("#google-container").html("");
          $("#google-container").addClass("active");
          tag = injectCode(code);
        });
      });
    </script>
  </head>

  <body>
    <div class="topbar">
      <div class="fill">
        <div class="container-fluid">
          <a class="brand" href="#">SDK Visualization Examples</a>
        </div>
      </div>
    </div>

    <div class="container">
      
      <section id="google">
       <div class="page-header">
          <h1>
            Google Charts <small>Using Java and JavaScript SDK</small>
          </h1>
       </div>
       <div class="row">
          <div class="span4">
            <h2>Description</h2>
              <p>
                <p>Details about SOP. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer eget lacinia tellus.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer eget lacinia tellus.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer eget lacinia tellus. For example, you may already have a website setup with Google Charts, and you want to display your data using it.</p>
                <p>This example performs a simple Splunk search (using <code>exec_mode=oneshot</code> for simplicity), and presents the results using Google Charts. The result format that Splunk gives is very similar to what Google Charts expects, so with a little bit of data massaging, you can have a chart up and running in no time.</p>
              </p>
          </div>
         <div class="span12">
            <h3>Code <button class="btn primary run" id="google-run">Run</button></h3>
            <div id="google-container">
                
            </div>
            <pre class='prettyprint lang-js linenums'>
var drawChart = function(rows) {  
  var chart = new google.visualization.ComboChart(document.getElementById('google-container'));
  var data = google.visualization.arrayToDataTable(rows);
  
  var options = {
    title : 'HTTP Status Codes For Every 10 Minutes on Splunkd',
    vAxis: {title: "Count", logScale: true},
    hAxis: {title: "Time"},
    seriesType: "bars",
    isStacked: false
  };
   
  
  chart.draw(data, options);
};

// The javascript 'results' variable is set using a JSP scriptlet that runs the server side code using the Java SDK ...
//< % String searchQuery = "search index=_internal sourcetype=splunkd* | head 10000 | bucket span=10m _time | eval formatted_time=strftime(_time, \"%D %H:%M\") | chart count over formatted_time by status usenull=f"; %>
//results = < %= MyServerSideClass.getSearchResults(searchQuery) %>;


<% String searchQuery = "search index=_internal sourcetype=splunkd* | head 10000 | bucket span=10m _time | eval formatted_time=strftime(_time, \"%D %H:%M\") | chart count over formatted_time by status usenull=f"; %>
results = <%= MyServerSideClass.getSearchResults(searchQuery) %>;

// The format Google Charts needs data in is very similar to ours - we just
// need to put the field headers in the same array, and convert the strings
// into numbers.
var rows = results.rows.slice();
var fields = results.fields.slice();

var timeIndex = utils.indexOf(fields, "formatted_time");
for(var i = 0; i < rows.length; i++) {
  var row = rows[i];
  for(var j = 0; j < row.length; j++) {
    
    // Don't change the time field
    if (j !== timeIndex) {
      row[j] = parseInt(row[j]);
    }
  }
}
    
    // Add the headers in
    rows.unshift(results.fields);
    
    drawChart(rows);
            </pre>
          </div>
        </div>
      </section>
      
      <footer>
        <p>&copy; Splunk 2011-2012</p>
      </footer>

    </div> <!-- /container -->

  </body>
</html>
