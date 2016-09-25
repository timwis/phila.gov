jQuery(document).ready(function($) {

  //TODO: Abstract for use on other data-types
  var parents = $('.a-z-group');
  var hiddenLetter = {};

  //Hide/show sets of letter groups
  $('.a-z-group .result').bind('update', function() {

    parents.each(function(index, item) {

      var $item = $(item);
      var childElements = $item.find('.result.is-hidden');

      var total = $item.find('.result');

      if (childElements.length === total.length) {
        $item.hide();
        hiddenLetter[$item.data('alphabet')] =  $item.data('alphabet') ;
      }else{
        $item.show();
        delete hiddenLetter[$item.data('alphabet')];

      }
    });
    //Disable anchor links when no results present for letter group
    $('.a-z-list nav li a').each( function ( i, value ) {
      var el = $(value);
      if ( el.data('alphabet') in hiddenLetter ) {
        $(this).attr('disabled', 'disabled');
        $(this).attr('aria-disabled', true);
      }else{
        $(this).removeAttr('disabled');
        $(this).attr('aria-disabled', false);
      }
    });
  });

  //Watch checkboxes
  $("#service_filter :checkbox").click(function() {

    $('.result').hide().addClass('is-hidden');

    if ( $(this).val() == 'all' ){

      $('#service_filter :checkbox').each(function(){
        $(this).prop('checked', false);

      });

      parents.show();

      $(this).prop('checked', true);
      $('.result').show().removeClass('is-hidden');

    }else{
      $('#all').prop('checked', false);
    }

    if( $('#service_filter :checkbox:checked').length > 0 ){

      //Match array values with checked items
      $('#service_filter :checkbox:checked').each(function(e) {
        var serviceType = $(this).val();

          $('.result').each(function( index, value ){

            $('.result').filter(function() {
              var arr = $(this).data('service').toString().split(/,\s+/);
                return $.inArray( serviceType, arr ) != -1;
              }).show().removeClass('is-hidden');
          });
          $('.a-z-group .result').trigger('update');
      });
    }else{

      $('#all').prop('checked', true);
      $('.result').show().removeClass('is-hidden');
      parents.show();
      $('.a-z-group .result').trigger('update');

    }
  });
  $("a.scrollTo").click(function(e){
    var link = $(this);

    $('html, body').animate({
      scrollTop:
        $( $(this).attr("href") ).offset().top
    }, 1000, function(){

      var anchor = link.attr("href").substr(1);
      var el = document.getElementById(anchor);

      el.focus();

    });

    return false;

  });


  // Mobile Filter
  function getValues() {
    confirmedValues = $( '#service_filter :checkbox:checked' ).map( function() {
      return this.value;
    }).get();
  }

  function applyValues() {
    $( '#service_filter input[type="checkbox"]' ).prop( 'checked', false );
    for ( i=0 ; i < confirmedValues.length ; i++ ){
      $( 'input#' + confirmedValues[i] ).trigger( 'click' );
    }
  }

  function attachFilter() {
    var $filterForm = $( '#service_filter' );
    $filterForm.detach();
    $( 'div[data-desktop-filter-wrapper]' ).append( $filterForm );
  }

  getValues();

  $( '[data-open="mobile-filter"]' ).click( function() {
    getValues();
    var $filterForm = $( '#service_filter' );
    $filterForm.detach();
    $( '[data-toggle="data-mobile-filter"]' ).append( $filterForm );
  });

  //Close button. Ignore unapplied changes.
  $( 'button[data-close]' ).on( 'close.zf.trigger' , applyValues );

  //Clear selection. Reset to 'All services'.
  $( 'a[data-clear-filter]' ).click( function() {
    $( '#service_filter #all[type="checkbox"]' ).trigger( 'click' );
  });

  //Apply filter selections.
  $( 'a[data-apply-filter]' ).click( function() {
    getValues();
    attachFilter;
  });

  $( window ).on( 'changed.zf.mediaquery' , function( event , newSize , oldSize ){
    if ( ( oldSize == 'medium' || oldSize == 'large' ) && ( newSize == 'small' ) ){
      getValues();
    }
    else if ( ( newSize == 'medium' || newSize == 'large' ) && ( oldSize == 'small' ) ){
      applyValues()
      attachFilter();
      $( '#mobile-filter[data-reveal]' ).trigger( 'close.zf' );
    }
  });

});
