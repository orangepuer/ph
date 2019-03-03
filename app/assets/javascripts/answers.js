$(document).on("turbolinks:load", function() {
  $('.edit_answer_link').click(function (e) {
    e.preventDefault();
    $(this).hide();
    let answer_id = $(this).data('answerId');
    $('#edit_answer_' + answer_id).show();
  });
  /*
  $('form.new_answer').on("ajax:success", function (event) {
    let detail = event.detail;
    let data = detail[0], status = detail[1], xhr = detail[2];
    let answer = $.parseJSON(xhr.responseText);
    $('.answers').append('<p>' + answer.body + '</p>');
  });
  $('form.new_answer').on("ajax:error", function (event) {
    let detail = event.detail;
    let data = detail[0], status = detail[1], xhr = detail[2];
    let errors = $.parseJSON(xhr.responseText);
    $('.answer-errors').html('');
    $(errors).each(function (index, value) {
      $('.answer-errors').append(value);
    });
  });
  */
});