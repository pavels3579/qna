$(document).on('turbolinks:load', function(){
   $('.actions').on('click', '.edit-question-link', function(e) {
       e.preventDefault();
       $(this).hide();

       $('form#edit-question').removeClass('hidden');
   })
});
