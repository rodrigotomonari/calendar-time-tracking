var app = app || {};

app.table_filter = (function($){
  function init() {
    $('.js-table-filter').each(function(){
      var $container = $(this);
      var $submit = $container.find('[type="submit"]');
      var $reset = $container.find('.btn-reset');
      console.log($submit);
      $submit.click(function(){
        window.location = window.location.pathname + '?' + $.param(get_values($container))
      });

      $reset.click(function(){
        window.location = window.location.pathname;
      });
    });
  }

  function get_values($container) {
    var values = {};
    var $inputs = $container.find('[name]');

    $inputs.each(function() {
      values[$(this).attr('name')] = $(this).val();
    });

    return values;
  }

  return {
    init: init
  }

})(jQuery);

app.table_filter.init();