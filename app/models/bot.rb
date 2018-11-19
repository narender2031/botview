class Bot < ApplicationRecord
    has_many :bot_service_messages
    has_many :service_messages, through: :bot_service_messages, dependent: :destroy
end
