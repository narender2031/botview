App.conversation = App.cable.subscriptions.create("ConversationChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    message = data['message']['content']['text']
    message_by = data['message_by']
    message_type = data['message']['type']
    actions = data['message']['content']['actions']
    if(data != ''){
      if( message_by == 'user'){
        // botui.message.add({
        //   human: true,
        //   content: message
        // });
      }else{
        bot_message(message, delay=1000, loading = true)
        if (actions.length != 0){
          return botui.action.button({
            delay: 2000,
            loading: true,
            action: actions
          }).then(function (res) { // will be called when a button is clicked.
            content = res.payload;
            on_action_genrate_message(content, 'user', type="text", payload=content)
          });
        }else{
          add_text_field(delay=3000)
        }
      }
    }
  },
  speak: function(message) {
    return this.perform('speak', {
      message: message
    });
  }
})

$(document).on('submit', '.botui-actions-text', function(e){
  e.preventDefault();
  content = $(".botui-actions-text-input").val();
  on_action_genrate_message(content, 'user', type="text", payload='')
  $(this).trigger('reset');
})