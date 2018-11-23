App.conversation = App.cable.subscriptions.create("ConversationChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    console.log(data)
    console.log(data['content']['content'])
    message = data['content']['content']
    message_by = data['content']['message_by']
    message_type = data['content']['message_type']
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
        if(message_type=='buttons'){
          return botui.action.button({
            action: [
              { // show only one button
                text: message,
                value: message
              }
            ]
          }).then(function (res) { // will be called when a button is clicked.
            console.log(res.value);
          });
        }else{
          botui.message.add({
            content: message,
          });
        }
      }
      botui.action.text({ 
        delay: 3000,
        loading: true,
        human: true,
        action: {
          placeholder: 'Enter your text here'
        }
      });
     
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
