class ServiceMessage < ApplicationRecord
    has_many :bot_service_messages
    has_many :bots, through: :bot_service_messages, dependent: :destroy
end
