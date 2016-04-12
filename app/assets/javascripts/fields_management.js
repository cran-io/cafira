$(function() {
  if($('#infrastructure_alfombra_input #infrastructure_alfombra').val() != "true") {
    $('#infrastructure_alfombra_tipo_input').hide();
  }
  if($('#aditional_service_energia_input #aditional_service_energia').val() != "true") {
    $('#aditional_service_energia_cantidad_input').hide();
  }
  if($('#aditional_service_estacionamiento_input #aditional_service_estacionamiento').val() != "true") {
    $('#aditional_service_estacionamiento_cantidad_input').hide();
  }

  $('#infrastructure_alfombra_tipo').val() == 'otra' ? $('#infrastructure_alfombra_tipo_input .inline-hints').show() : $('#infrastructure_alfombra_tipo_input .inline-hints').hide();
  $('#infrastructure_alfombra_input #infrastructure_alfombra').click(function() {
    $('#infrastructure_alfombra_input #infrastructure_alfombra').val() == "true" ? $('#infrastructure_alfombra_tipo_input').show() : $('#infrastructure_alfombra_tipo_input').hide();
  });
  $('#infrastructure_alfombra_tipo_input #infrastructure_alfombra_tipo').change(function() {
    $('#infrastructure_alfombra_tipo').val() == 'otra' ? $('#infrastructure_alfombra_tipo_input .inline-hints').show() : $('#infrastructure_alfombra_tipo_input .inline-hints').hide();
  });

  $('#aditional_service_energia_input #aditional_service_energia').click(function() {
    $('#aditional_service_energia_input #aditional_service_energia').val() == "true" ? $('#aditional_service_energia_cantidad_input').show() : $('#aditional_service_energia_cantidad_input').hide();
  });


  $('#aditional_service_estacionamiento_input #aditional_service_estacionamiento').click(function() {
    $('#aditional_service_estacionamiento_input #aditional_service_estacionamiento').val() == "true" ? $('#aditional_service_estacionamiento_cantidad_input').show() : $('#aditional_service_estacionamiento_cantidad_input').hide();
  });

});
