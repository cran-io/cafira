$(function() {
  vex.defaultOptions.className = 'vex-theme-os';
  $('.approve_blueprint_file, .dissaprove_blueprint_file, .pre_approve_blueprint_file, .pre_approve_catalog, .disapprove_catalog').click(function() {
    var url = $(this).data('path');
    initializeJustificationModal(url);
  });
  $('.view_conversation').click(function() {
    var url = $(this).data('path');
    var conversation = $(this).data('comments')
    initializeConversationModal(url, conversation);
  });
});



var initializeConversationModal = function(url, conversation) {
	vex.dialog.open({
    message: "<div style='overflow-y:scroll; height: 100px;'>  <p>asfsaf</p><p>asfsaf</p><p>asfsaf</p><p>asfsaf</p><p>asfsaf</p><p>asfsaf</p><p>asfsaf</p> </div>",
	  input: "<textarea name='conversation' maxlength='500' placeholder='Escriba su mensaje...' rows='2' />",
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
    				comment: data.comment
		    	},
		    	success: function(response) {
            window.location = response.url;
		    	}
		    });
	    }
	  }
	});
}

var parseConversation = function(conversation) {
  JSON.parse(conversation.comments[0]).comment
  for (var i = 0; i < conversation.comments.length; i++) {
    conversation.comments[i]
  }


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
