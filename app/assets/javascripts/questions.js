$(document).on('turbolinks:load', function(){
  $('div.answers').prepend($('div.best'));
  $('div.best').find('a.mark-as-best').addClass('hidden');

  $('.actions').on('click', '.edit-question-link', function(e) {
      e.preventDefault();
      $(this).hide();

      $('form#edit-question').removeClass('hidden');

    });
  });

  App.cable.subscriptions.create('QuestionsChannel', {
    connected() {
        this.perform('follow')
    },
    received(data) {
        $('.questions-list').find('tbody').append(data);
    }
});
