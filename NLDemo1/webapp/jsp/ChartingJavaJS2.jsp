<%@ page import = "users.nluthra.MyServerSideClass" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>UI Examples -- Splunk Java combined with JavaScript SDK</title>
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Le styles -->
    <link href="../resources/bootstrap.css" rel="stylesheet">
    <link href="../resources/prettify.css" type="text/css" rel="stylesheet" />
    <link href="../resources/timeline.css" type="text/css" rel="stylesheet" />
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
      
      #timeline-container.active {
        height: 250px;
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
    <script type="text/javascript" src="../resources/client/splunk.js"></script>
    <script >      
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
        
        $("#chart-run").click(function() {
          // Get the code except comments
          var code = getCode("#chart");
          
          var tag = null;
          
          // setup the global variables we need
          done = callback = function() {
            $(tag).remove();
          };
          
          $("#chart-container").html("");
          $("#chart-container").addClass("active");
          tag = injectCode(code);
        });
      });
    </script>
  </head>

  <body>
    <div class="topbar">
      <div class="fill">
        <div class="container-fluid">
          <a class="brand" href="#">SDK UI Examples</a>
          <ul class="nav">
            <li><a href="#timeline">Charting</a></li>
          </ul>
        </div>
      </div>
    </div>

    <div class="container">
      
      <section id="chart">
       <div class="page-header">
          <h1>
            Charting <small>Loading, creating and updating a chart using Java and JavaScript SDKs</small>
          </h1>
       </div>
       <div class="row">
          <div class="span4">
            <h2>Description</h2>
              <p>
                <p>This sample shows how to asynchronously load the Splunk Charting control, and perform operations on it. It will create a simple search, and when the search is done, will fetch results and display them in the chart.</p>
              </p>
          </div>
         <div class="span12">
            <h3>Code <button class="btn primary run" id="chart-run">Run</button></h3>
            <div id="chart-container">
                
            </div>
            <pre class='prettyprint lang-js linenums'>
  // The javascript 'results' variable is set through a JSP scriptlet that runs the server side code using Splunk Java SDK ...
  // < % String searchQuery = "search index=_internal | head 1000 | stats count(host), count(source) by sourcetype"; %>
  // results = < %= MyServerSideClass.getSearchResults(searchQuery) %>;
  <% String searchQuery = "search index=_internal | head 1000 | stats count(host), count(source) by sourcetype"; %>
  results = <%= MyServerSideClass.getSearchResults(searchQuery, "json_cols") %>;

  var chart = null; 
  var chartToken = splunkjs.UI.loadCharting("../resources/client/splunk.ui.charting.js", function() {
    // Once we have the charting code, create a chart and update it.
    chart = new splunkjs.UI.Charting.Chart($("#chart-container"), splunkjs.UI.Charting.ChartType.COLUMN, false);
  });

  splunkjs.UI.ready(chartToken, function() {
      chart.setData(results, {
      "chart.stackMode": "stacked"
    });
  chart.draw();
  });
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
