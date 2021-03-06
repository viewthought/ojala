class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  def send_devise_notification(notification, *args)
    if Rails.env.production?
      # No worker process in production to handle scheduled tasks
      devise_mailer.send(notification, self, *args).deliver_now
    else
      devise_mailer.send(notification, self, *args).deliver_later
    end
  end
end
