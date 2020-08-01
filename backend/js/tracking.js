// google analytics code
var ga_code = 'UA-173804084-1'

// variables to log
var log_widgets = ['usrxbins', 'usrybins', 'insideOverlay', 'popup_info', 'sidebarOverlay', 'useScreen', 'usrObjs', 'usrIssues', 'usrColor'];

(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();
    a=s.createElement(o), m=s.getElementsByTagName(o)[0];
    a.async=1;
    a.src=g;m.parentNode.insertBefore(a,m)
})(window, document, 'script', '//www.google-analytics.com/analytics'  + '.js', 'ga');

ga('create', ga_code, 'auto');


$(document).on('shiny:connected', function(e) {
    ga('send', 'pageview');
});

$(document).on('shiny:inputchanged', function(e) {
    if (log_widgets.indexOf(e.name) > -1) {
        ga('send', 'event', 'widget', e.name, e.value);
    }
});