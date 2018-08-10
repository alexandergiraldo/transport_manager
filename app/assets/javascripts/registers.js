//Registers = (function(){
  //function calculate_registers_totals() {
    //var incoming_values = [];
    //var outcoming_values = [];
//
    //$('.register-row').each(function(index) {
      //var type = $(this).find('.register-type').val();
      //var value = $(this).find('.register-value').val() || 0;
//
      //if( type == '0'){
        //incoming_values.push(parseInt(value));
      //}
      //else{
        //outcoming_values.push(parseInt(value));
      //}
    //});
//
    //var incoming_sum = sum_values(incoming_values)
    //var outcoming_sum = sum_values(outcoming_values)
//
    //$('#registers-incoming').html('$'+incoming_sum);
    //$('#registers-outcoming').html('$'+outcoming_sum);
    //$('#registers-total').html('$'+(incoming_sum-outcoming_sum));
  //}
//
  //function monitor_total_values(){
    //$(document).on("change", '.register-value', function() {
      //calculate_registers_totals();
    //});
  //}
//
  //function sum_values(values){
    //if(values.length > 0){
      //return values.reduce((a, b) => a + b)
    //}
    //else{
      //return 0;
    //}
  //}
//
  //return{
    //calculate_registers_totals: function() {
      //calculate_registers_totals();
    //},
    //init: function() {
      //calculate_registers_totals();
      //monitor_total_values();
    //}
  //}
//})();
//
//$(function() {
  //Registers.init();
//});
//
//window.Registers = Registers