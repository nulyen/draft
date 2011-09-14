class Player < ActiveRecord::Base
  include DraftSelectionHelper
  attr_accessor
  attr_accessible :name, :position, :first_team
  
  validates :name, :presence => true,
                   :uniqueness => { :scope => [:position, :first_team] }
  
  validates :position, :presence => true,
                       :inclusion => { :in => DraftSelectionHelper::POSITION_LIST }
  
  validates :first_team, :presence => true, :team => true
  
  has_one :draft_selection, :dependent => :destroy   
  
  
  
end
