class BotServiceMessage < ApplicationRecord
    belongs_to :service_message
    belongs_to :bot
end
