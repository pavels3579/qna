App.answers = App.cable.subscriptions.create "AnswersChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    questionId = $('h1').attr('id')
    @perform 'follow', question_id: questionId

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    answerData = JST['templates/answers/answer']({
      answer: data.answer
      links: data.links
      files: data.files
    })
    $('.answers').append answerData
