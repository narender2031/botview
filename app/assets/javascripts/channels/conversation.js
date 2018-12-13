App.conversation = App.cable.subscriptions.create("ConversationChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    message = data['message']['content']['text']
    message_by = data['message_by']
    message_type = data['message']['content']['type']
    actions = data['message']['content']['actions']
    if(data != ''){
      if( message_by == 'user'){
      //  no user action update here
      }else{
        bot_message(message, delay=1000, loading = true)
        if (!jQuery.isEmptyObject(actions)){
          buttons = genrate_buttons(buttons = actions)
          return genrate_buttons_ui(buttons)
        }else{
          add_text_field(delay=3000, type=message_type)
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
  type = $(".botui-actions-text-input").attr('type');
   $(".botui-actions-text-input").attr('response_type', 'postback');
  if(type == 'text' || type == 'name' || type == 'email' || type == 'password'){
    payload = ''
  }
  on_action_genrate_message(content, 'user', type=type, payload=payload, postback='postback')
  $(this).trigger('reset');
})