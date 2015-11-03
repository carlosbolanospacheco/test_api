class CongressSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :start_date, :end_date, :editable
#  belongs_to :user

  def editable
  	editable = false  	
  	if current_user && (current_user.admin? || object.user_id == current_user.id)
			editable = true
		end
		return editable
  end

end
