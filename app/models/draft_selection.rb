class DraftSelection < ActiveRecord::Base
  attr_accessor
  
  validates :year, :presence => true
  validates :round, :presence => true
  validates :pick, :presence => true
  validates :overall_selection, :presence => true
  validates :nfl_team, :presence => true, 
                       :team => true
  validates :college_team, :presence => true
  validates :position, :presence => true,
                       :inclusion => { :in => DraftSelectionHelper::POSITION_LIST }
  validates :player_id, :presence => true
  
  belongs_to :player
  


    
end


