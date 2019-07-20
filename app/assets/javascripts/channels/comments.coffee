App.answers = App.cable.subscriptions.create "CommentsChannel",
  connected: ->
# Called when the subscription is ready for use on the server
    questionId = $('h1').attr('id')
    @perform 'follow', question_id: questionId

  received: (data) ->
# Called when there's incoming data on the websocket for this channel
    commentData = data.comment
    commentElement = JST['templates/comments/comment']({
      comment: commentData
    })
    $(".comments-#{commentData.commentable_id}").append commentElement
