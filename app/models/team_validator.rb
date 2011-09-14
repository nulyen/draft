class TeamValidator < ActiveModel::EachValidator
  include DraftSelectionHelper

  def validate_each(record, attribute, value)
    record.errors[attribute] << "is invalid: #{value}" unless valid_team? value    
  end


end