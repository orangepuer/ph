$(document).on("turbolinks:load", function() {
  $('.edit_answer_link').click(function (e) {
    e.preventDefault();
    $(this).hide();
    let answer_id = $(this).data('answerId');
    $('#edit_answer_' + answer_id).show();
  });
});