App.conversation = App.cable.subscriptions.create("ConversationChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    message = data['message']['content']['text']
    message_by = data['message_by']
    message_type = data['message']['content']['type']
    actions = data['message']['content']['actions']
    console.log(actions)
    if(data != ''){
      if( message_by == 'user'){
        // botui.message.add({
        //   human: true,
        //   content: message
        // });
      }else{
        bot_message(message, delay=1000, loading = true)
        if (actions.length != undefined){
          return botui.action.button({
            delay: 2000,
            loading: true,
            action: [
              {
                type: 'text',
                text: "test",
                payload: 
              }
            ]
          }).then(function (res) { // will be called when a button is clicked.
            content = res.payload;
            if(content == 'Create Account'){
              window.location.href = "http://localhost:3000/password"
            }else if(content == 'Login'){
              window.location.href = 'http://localhost:3000/update_session'
            }else{
              on_action_genrate_message(content, 'user', type="text", payload=content)
            }
          });
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
  payload = $(".botui-actions-text-input").attr('type')
  if(payload == 'text'){
    payload = ''
  }
  on_action_genrate_message(content, 'user', type="text", payload=payload)
  $(this).trigger('reset');
})