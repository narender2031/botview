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
      { 
        text: 'Say Hello 😲',
        value: 'Hello 😲'
      }
    ]
    }).then(function (res) {
      content = res.value;
      on_action_genrate_message(content, 'user', type="text", payload=content, postback='postback')
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

function add_text_field(delay, type){
  add_message = chaeck_field_type(type) //check the field type
  field = botui.action.text({ 
    addMessage: add_message,
    delay: delay,
    human: true,
    action: {
      sub_type: type,
      placeholder: 'Please enter your text',
    }
  }).then(function (res) {
    if(type == 'password'){
      botui.message.add({
        human: true,
        content: '************'
      });
    }
  });
  return field
}

function chaeck_field_type(type){
  add_message = true
  if(type == 'password'){
    add_message = false
  }
  return add_message
}

function on_action_genrate_message(content, message_by, type, payload, postback){
  content = content
  message_by = message_by
  data = []
  if(postback == 'postback'){
    message = composeMessage(content, type=type, meta={}, actions = [] )
    conversation_id = $("#conversation_id").val();
    data.push({body: message, message_by: message_by, type: type,  conversation_id: conversation_id, payload: payload})
    var values = data
    App.conversation.speak(values);
  }else{
    add_text_field(delay=1000, type=type)
  }
}


function genrate_buttons(actions){
  buttons = []
  $.map(actions['buttons'], function(value, key){
    button = {
      sub_type: value['type'],
      text: value['text'],
      payload: value['payload'],
      url: value['url'] || '',
      value: value['text']
    }
    buttons.push(button)
  })
  return buttons
}

function genrate_buttons_ui(buttons){
  botui.action.button({
    delay: 2000,
    loading: true,
    action: buttons
  }).then(function (res) { 
    payload = res.payload;
    message = res.text
    type = res.sub_type
    url =res.url
    redirect_other_page(url)
    if(payload != "Delete"){
      on_action_genrate_message(message, 'user', type=type, payload=payload, postback=type)
    }else{
      window.location.replace(url)
    }
  });
}

function redirect_other_page(url){
  if(url != undefined && url != ''){
    window.location.replace(url)
  }
}