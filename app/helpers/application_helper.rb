include Carmen

module ApplicationHelper

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-error", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do 
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
              concat message 
            end)
    end
    nil
  end

  def set_resource_through_template
    @resource = current_user
    @resource.build_store unless @resource.stores.any?    
  end

  def buyer?
    current_user.has_role? :buyer
  end

  def get_states
    ind = Country.named('India')
    ind.subregions.select{|t| t.type=="state"}.map(&:name)
  end

  def set_image(product)
    if (product.galleries.first.photo.url.include? "missing")
      asset_path("bg_cover")      
    else
      product.galleries.first.photo.url 
    end
  end
end