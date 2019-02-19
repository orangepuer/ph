$(document).on("turbolinks:load", function() {
  $('.edit_question_link').click(function (e) {
    e.preventDefault();

    if (!$(this).hasClass('cancel')) {
      $(this).html('Cancel');
      $(this).addClass('cancel');
    } else {
      $(this).html('Edit');
      $(this).removeClass('cancel');
    };

    $('.edit_question').toggle();
  });
});