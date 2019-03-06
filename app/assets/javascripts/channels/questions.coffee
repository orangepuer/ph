App.cable.subscriptions.create { channel: "QuestionsChannel" },
  received: (data) ->
    $('.questions').append(JST["templates/question"](data: data))
