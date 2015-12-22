$(function() {
  vex.defaultOptions.className = 'vex-theme-os';
  $('.dissaprove_blueprint_file, .pre_approve_blueprint_file').click(function() {
    var url = $(this).data('path');
    initializeJustificationModal(url);
  });
});

var initializeJustificationModal = function(url) {
	vex.dialog.open({
    message: 'Justificación',
	  input: "<textarea name='justification' maxlength='500' placeholder='Justificación...' rows='10' />",
	  buttons: [
      $.extend({}, vex.dialog.buttons.YES, {
        text: 'Enviar'
	    }), $.extend({}, vex.dialog.buttons.NO, {
	      text: 'Volver'
	    })
	  ],
	  callback: function(data) {
	    if(data){
		    $.ajax({
		    	type: 'POST',
		    	url: url,
		    	data: { 
    				justification: data.justification 
		    	},
		    	success: function(response) {
            window.location = response.url;
		    	}
		    });
	    }
	  }
	});
}