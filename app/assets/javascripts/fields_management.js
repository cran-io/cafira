$(function() {
  if(!$('#infrastructure_alfombra_input #infrastructure_alfombra').is(':checked')) {
    $('#infrastructure_alfombra_tipo_input').hide();
  }
  $('#infrastructure_alfombra_tipo').val() == 'otra' ? $('#infrastructure_alfombra_tipo_input .inline-hints').show() : $('#infrastructure_alfombra_tipo_input .inline-hints').hide(); 
  $('#infrastructure_alfombra_input #infrastructure_alfombra').click(function() {
    $('#infrastructure_alfombra_input #infrastructure_alfombra').is(':checked') ? $('#infrastructure_alfombra_tipo_input').show() : $('#infrastructure_alfombra_tipo_input').hide();  
  });
  $('#infrastructure_alfombra_tipo_input #infrastructure_alfombra_tipo').change(function() {
    $('#infrastructure_alfombra_tipo').val() == 'otra' ? $('#infrastructure_alfombra_tipo_input .inline-hints').show() : $('#infrastructure_alfombra_tipo_input .inline-hints').hide(); 
  });

});