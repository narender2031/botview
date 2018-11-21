App.conversation = App.cable.subscriptions.create("ConversationChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    console.log(data)
    console.log(data['content']['content'])
    message = data['content']['content']
    message_by = data['content']['message_by']
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
        botui.message.add({
          content: message
        });
      }
      botui.action.text({ 
        action: {
          placeholder: 'Your name'
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
  data.push({message: message, message_by: message_by})
  var values = data
  App.conversation.speak(values);
  $(this).trigger('reset');
})