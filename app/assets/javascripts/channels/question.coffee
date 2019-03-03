App.cable.subscriptions.create { channel: "QuestionChannel", question_id: gon.question_id },
  received: (data) ->
    console.log data
    $('.answers').append(JST["templates/answer"](data: data))
