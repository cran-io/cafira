$(function() {
  vex.defaultOptions.className = 'vex-theme-os';
  $('.approve_blueprint_file, .dissaprove_blueprint_file, .pre_approve_blueprint_file, .pre_approve_catalog, .disapprove_catalog').click(function() {
    var url = $(this).data('path');
    initializeJustificationModal(url);
  });
  $('.view_conversation').click(function() {
    var url = $(this).data('path');
    initializeConversationModal(url);
  });
});



var initializeConversationModal = function(url) {
	vex.dialog.open({
    message: 'Conversación',
	  input: "<textarea name='conversation' maxlength='500' placeholder='Escriba su mensaje...' rows='10' />",
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
