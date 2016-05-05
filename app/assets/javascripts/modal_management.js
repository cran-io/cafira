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
    $('#vexx').scrollTop($('#vexx')[0].scrollHeight);

    disableSubmitButton();

  });
});

var disableSubmitButton = function() {
  $('.vex-first').addClass('btn-disabled');
  $("textarea[name='conversation']").keyup(function() {
    console.log("foo")
    if($(this).val().length == 0){
      $('.vex-first').addClass('btn-disabled');
    } else {
      $('.vex-first').removeClass('btn-disabled');
    }
  })
}


var initializeConversationModal = function(url, conversation) {
  var conversation_length = 5
  var bp = conversation.id;
  var arch = 0;
  if(conversation.user_type == 'expositor') {
    for(var i = conversation.comments.length - 1; i >= 0; i--){
      if(JSON.parse(conversation.comments[i]).created_by == 'architect') {
        arch = JSON.parse(conversation.comments[i]).architect_id;
        break;
      }
    }
  }
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
    				comment: data.conversation,
            bp_id: bp,
            arc_id: arch,
		    	},
		    	success: function(response) {
            window.location = response.url;
		    	}
		    });
	    }
      location.reload(true);
	  }
	});
}


$(function() {

});

var parseConversation = function(conversation) {
  var div_tag = "<div id='vexx' style='overflow-y:scroll; height: 500px;'> "
  if(conversation != 'empty') {
    for (var i = 0; i < conversation.comments.length; i++) {
      var bubble_class = "class='bubble2'";
      var name_class = "class='convName2'";
      var conv_class = "class='convSay2'";
      var date_class = "class='convDate2'";
      if(JSON.parse(conversation.comments[i]).created_by == 'expositor' ) {
        bubble_class = "class='bubble'";
        name_class = "class='convName'";
        conv_class = "class='convSay'";
        date_class = "";
      }
      div_tag += "<div " + bubble_class + ">" + "<span " + name_class + ">" + JSON.parse(conversation.comments[i]).user_name + "</span>" + "<br>" + "<span " + conv_class + ">" + JSON.parse(conversation.comments[i]).comment + "</span><br>";
      div_tag += "<span " + date_class + ">" + JSON.parse(conversation.comments[i]).created_at + "</span>" + "<br>" + "</div>";
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
