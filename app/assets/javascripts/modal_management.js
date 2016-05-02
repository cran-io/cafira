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

//    message: "<div style='overflow-y:scroll; height: 100px;'>  <p><strong>asfsaf</strong></p>   <h3 align='right'>asfsaf</h3>  <p>asfsaf</p> </div>",


var initializeConversationModal = function(url, conversation) {
	vex.dialog.open({
    message: parseConversation(conversation),
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


var parseConversation = function(conversation) {
  //JSON.parse(conversation.comments[0]).comment;
  var div_tag = "<div style='overflow-y:scroll; height: 300px;'> "
  for (var i = 0; i < conversation.comments.length; i++) {
    var align_text = "align='right'";
    if(JSON.parse(conversation.comments[i]).created_by == 'expositor' ) {
      align_text = "align='left'";
    }
    div_tag += "<h3 " + align_text + ">" + JSON.parse(conversation.comments[i]).comment + "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</h3>";
    div_tag += "<h6 " + align_text + ">" + "por: " + JSON.parse(conversation.comments[i]).user_name + " en la fecha: " + JSON.parse(conversation.comments[i]).created_at + "</h6>";
  }
  div_tag += "</div>";
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
