class CommentsController < ApplicationController
 


  before_action :check_current_user, only: [:new, :create, :edit, :update, :destroy]
  def index
  end



  def create
	@comment = Comment.new(params_comment)
    if @comment.save
        flash[:notice] = "Success Add Records"
        redirect_to action: 'index'
    else
        flash[:error] = "data not valid"
        render 'new'
    end
  end




  def edit
  end

  private
    def params_comment
		params.require(:comment).permit(:article_id, :user_id, :content, :status)
    end

end
