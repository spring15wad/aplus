# ApplicationController
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_context, except: [:filter_subject]

  # GET /filter_subject
  # Saves the subject code in the parameter to filter the
  # topics in the list. Then it redirects to the previous view. 
  def filter_subject
    cache = Rails.cache
    cache.write('subject', params[:subject])
  	respond_to do |format|
  		format.html { redirect_to request.referrer  }
  	end
  end

  protected
  
    # Method to determine or set the current user
    def current_user
      @current_user ||= User.find_by_id(session[:user_id])
    end

    # Method to determine whether a user is signed in or not
    def user_signed_in?
      !!current_user
    end

    helper_method :current_user, :user_signed_in?
    
    def current_user=(user)
      @current_user = user
      session[:user_id] = user.id
      session[:user_name] = user.name
    end

  private

    # Sets the context for the topics menu. Only the unarchived subjects,
    # and topics are picked. The topics are filtered based on the subject
    # code in cache.
    def set_context
      @app_subjects = Subject.not_archived
      cache = Rails.cache

      if cache.read('subject')
        @selected_subject = cache.read('subject')
        if @selected_subject == "all"
          @menu_topics = Topic.not_archived
        elsif @selected_subject == "none"
          @menu_topics = Topic.not_archived.where(subject_id: nil)
        else
          subject = Subject.find_by(code: @selected_subject)
          @menu_topics = Topic.where(subject_id: subject._id)
        end
      else
        @menu_topics = Topic.not_archived
      end
  	end
    
    def authenticate_user!
      if session[:user_id].nil?
        redirect_to root_url
      end
    end
end
