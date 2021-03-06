class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]

  def new
    @skatespot_id = params[:skatespot_id] if params[:skatespot_id]
    @skatespot = Skatespot.find_by_id(params[:skatespot_id])
    @comment = Comment.new
  end


  def create 
    @comment = current_user.comments.new(comment_params)
    @skatespot = @comment.skatespot
      if @comment.save 
        redirect_to skatespot_comments_path(@comment.skatespot, @comment)
      else 
        render :new 
    end
  end
  
  def index
    if params[:skatespot_id] 
      @comments = Comment.find_by_skatespot_id(params[:skatespot_id])
    end
  end

  def edit
    @skatespot = Skatespot.find(params[:skatespot_id])
  end 

  def update 
    if current_user.comments.update(comment_params)
      redirect_to skatespot_comments_path(@comment.skatespot, @comment)
    else
      render :edit
    end
  end

  def destroy 
    binding.pry
    @comment.destroy
    flash[:notice] = "That Comment is Destroyed!!!!!!!!!"
    redirect_to skatespot_comments_path
  end

  private 

  def comment_params 
    params.require(:comment).permit(:content, :busted?, :status, :skatespot_id)
  end

  def set_comment 
    @comment = Comment.find_by_id(params[:id])
  end

end