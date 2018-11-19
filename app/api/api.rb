require 'grape-swagger'
class API < Grape::API
before do
  header 'Access-Control-Allow-Origin', '*'
  header 'Access-Control-Allow-Methods', 'GET, POST, DELETE, PATCH, OPTIONS, PUT'
end
    prefix 'api'
    version 'v1', using: :path
    default_format :json

    mount ChatApi::Chat
    add_swagger_documentation(
        mount_path: '/docs',
        markdown: false,
        hide_documantation_path: true,
        api_version: '1.0'
    )
end
