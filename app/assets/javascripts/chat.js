function composeMessage(content, type, meta, actions){
  message = {
  content:{
      text: content,
      type: type,
      actions: actions
    },
    type: type,
    meta: meta
  }
  return message
}


function start_conversation(){
  hello_button =  botui.action.button({
    action: [
      { // show only one button
        text: 'Say Hello 😲',
        value: 'Hello 😲'
      }
    ]
    }).then(function (res) { // will be called when a button is clicked.
      content = res.value;
      on_action_genrate_message(content, 'user', type="text", payload=content)
    });
  
  return hello_button
}


function human_message(message, delay){
  message = botui.message.add({
    delay: delay,
    human: true,
    content: content,
  });

  return message
}


function bot_message(message, delay, loading){
  botui.message.add({
    delay: delay,
    loading: loading,
    content: message
  });

  return message
}

function add_text_field(delay){
  field = botui.action.text({ 
    delay: delay,
    human: true,
    action: {
      placeholder: 'Please enter your text'
    }
  });
  return field
}


function on_action_genrate_message(content, message_by, type, payload){
  content = content
  message_by = message_by
  data = []
  message = composeMessage(content, type=type, meta={}, actions = [] )
  conversation_id = $("#conversation_id").val();
  data.push({body: message, message_by: message_by, conversation_id: conversation_id, payload: payload})
  var values = data
  App.conversation.speak(values);
}