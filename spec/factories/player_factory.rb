Factory.define :player do |player|  
  player.name       "Anthony Calvillo"
  player.position   "QB"
  player.first_team "BUF"
end

Factory.sequence :name do |n|
  "Bob#{n} D. Sanders"
end
