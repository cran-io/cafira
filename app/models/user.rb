class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  def translated_type
    case type
    when 'AdminUser'
      'Administrador'
    when 'Expositor'
      'Expositor'
    when 'Organizer'
      'Organizador'
    when 'Designer'
      'Diseñador'
    when 'Architect'
      'Arquitecto'
    else
      '-'
    end
  end

end
