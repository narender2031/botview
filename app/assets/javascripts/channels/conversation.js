App.conversation = App.cable.subscriptions.create("ConversationChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    console.log(data)
    console.log(data['content'])
    message = data['content']
    message_by = data['message_by']
    message_type = data['message_type']
    if(data != ''){
      // $(".messages").append(data['message'])
      // $(".messages").append('<br>')
      // $(".no-messages").css('display','none')
      // console.log("hello")
      if( message_by == 'user'){
        // botui.message.add({
        //   human: true,
        //   content: message
        // });
      }else{
        if( message_type == 'text'){
          botui.message.add({
            delay: 1000,
            loading: true,
            content: message
          });
          if( message != 'Goodbye World!'){
            botui.action.text({ 
              delay: 3000,
              human: true,
              action: {
                placeholder: 'Please enter your text'
              }
            });
          }
        }else if (message_type == 'buttons'){
          new_message = message.replace(/=>/g, ':')
          final_button = []
          buttons = JSON.parse(new_message)
          $.map(buttons, function(val, i){
            sort_data = {
              text: val['text'],
            value: val['payload']
            }
            final_button.push(sort_data)
          })
          console.log(final_button)
          return botui.action.button({
            delay: 2000,
            loading: true,
            action: final_button
          }).then(function (res) { // will be called when a button is clicked.
            message = res.value;
            message_by = 'user'
            data = []
            conversation_id = $("#conversation_id").val();
            data.push({message: message, message_by: message_by, conversation_id: conversation_id, payload:  message})
            var values = data
            App.conversation.speak(values); // will print "one" from 'value'
          });
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
  message = $(".botui-actions-text-input").val();
  message_by = 'user'
  data = []
  conversation_id = $("#conversation_id").val();
  data.push({message: message, message_by: message_by, conversation_id: conversation_id})
  var values = data
  App.conversation.speak(values);
  $(this).trigger('reset');
})

// $(document).on('click', '.botui-actions-buttons-button', function(e){
//   e.preventDefault();
//   debugger
//   message = $(".botui-actions-buttons-button").val();
//   message_by = 'user'
//   data = []
//   conversation_id = $("#conversation_id").val();
//   data.push({message: message, message_by: message_by, conversation_id: conversation_id})
//   var values = data
//   App.conversation.speak(values);
//   $(this).trigger('reset');
// })
