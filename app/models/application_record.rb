class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  has_many :live_record_updates, as: :recordable

  after_update :__reference_changed_attributes__
  after_update_commit :__broadcast_record_update__
  after_destroy_commit :__broadcast_record_destroy__

  def self.live_record_whitelisted_attributes
    []
  end

  private

  def __reference_changed_attributes__
    @_live_record_changed_attributes = changed
  end

  def __broadcast_record_update__
    included_attributes = attributes.slice(*@_live_record_changed_attributes)
    @_live_record_changed_attributes= nil
    message_data = { 'action' => 'update', 'attributes' => included_attributes }
    LiveRecordChannel.broadcast_to(self, message_data)
    LiveRecordUpdate.create!(recordable: self)
  end

  def __broadcast_record_destroy__
    message_data = { 'action' => 'destroy' }
    LiveRecordChannel.broadcast_to(self, message_data)
  end
end
