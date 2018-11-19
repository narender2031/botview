require 'grape-swagger'
module ChatApi
  class Chat < Grape::API
		default_format :json
		# authantication methods in helpers 
		helpers do 
			def authenticate
				token = headers['Authorization']
				User.exists?(token: token)
				if User.exists?(token: token)
						@current_user = User.find_by(token: token)
				else
						error! 'Unauthorized', 401
				end
			end
			def current_user
					@current_user
			end
		end
		# login SignUp Api's

		resource :graph do 
			desc "Hello"
			params do
				requires :valuse, type:String, documentation: { in: 'body' }
				requires :encounter_id, type:Integer
			end
			post '/' do
				require 'uri'
				require 'net/http'

				url = URI("https://38ab4dc3.ngrok.io/incoming/sarah")

				http = Net::HTTP.new(url.host, url.port)
				http.use_ssl = true
				http.verify_mode = OpenSSL::SSL::VERIFY_NONE

				request = Net::HTTP::Post.new(url)
				request["content-type"] = 'application/x-www-form-urlencoded'
				request.body = "value=#{params[:valuse]}&encounter_id=#{params[:encounter_id]}"
				response = http.request(request)
				({message: response})
			end

			desc "Results"
			params do 
				requires :message, type:String, documentation: {in: 'body'}
			end
			post '/results' do 
				puts params[:message]
				({message: params[:message] })
			end
		end

  	end
end