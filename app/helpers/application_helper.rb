module ApplicationHelper

  def get_logo
    image_tag("rails.png", :alt => "Sample App", :class => "round")   
  end

  # Return a title on a per-page basis.
  def get_title
    base_title = "NFL Draft Analysis"
    if @title.nil?
      base_title
    else
      "#{base_title} - #{@title}"
    end
  end
  
end
