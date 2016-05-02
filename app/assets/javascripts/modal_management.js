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
    message: parseConversation(conversation),
    contentCSS: { width: '800px' },
	  input: "<textarea name='conversation' maxlength='500' placeholder='Escriba su mensaje...' rows='6' />",
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
    				comment: data.conversation
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
  var div_tag = "<div style='overflow-y:scroll; height: 500px; word-wrap: break-word;'> "
  if(conversation != 'empty') {
    for (var i = 0; i < conversation.comments.length; i++) {
      var align_text = "align='right'";
      if(JSON.parse(conversation.comments[i]).created_by == 'expositor' ) {
        align_text = "align='left'";
      }
      div_tag += "<h3 " + align_text + ">" + JSON.parse(conversation.comments[i]).comment + "</h3>";
      div_tag += "<h5 " + align_text + ">" + "por: " + JSON.parse(conversation.comments[i]).user_name + ",  en la fecha: " + JSON.parse(conversation.comments[i]).created_at + "</h5><br>";
    }
    div_tag += "</div>";
  } else {
    div_tag += "<h3>Esta conversación esta vacia</h3>"
  }
  return div_tag;
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
