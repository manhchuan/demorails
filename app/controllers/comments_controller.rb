class CommentsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :comment_post, only: :create
	def create
		@comment = current_user.comments.build(comment_params)
		@entry = Entry.find(@comment.entry_id)
		if @comment.save
			flash[:success] = "Commented!"
			redirect_to :back
		else
			redirect_to :back
		end
	end

	def destroy
		@comment = current_user.comments.find(params[:id])
		@entry = @comment.entry
		@comment.destroy
		flash[:success] = "Comment deleted"
		redirect_to request.referrer || root_url
	end

	private
	def comment_params
		params.require(:comment).permit(:content, :entry_id, :user_id)
	end
	def comment_post  
		@entry = Entry.find(params[:comment][:entry_id])
		if !current_user.following?(@entry.user) && !current_user?(@entry.user)
			redirect_to :back
		end
	end
end 
