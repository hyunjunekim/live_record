class LiveRecordChannel < ApplicationCable::Channel
  include ActiveSupport::Rescuable
  include LiveRecord::Channel::Implement
end
