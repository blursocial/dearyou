class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_post, only: %i[edit update destroy]

  # GET /posts or /posts.json
  def index
    if user_signed_in?
      # Fetch posts from followed users for authenticated users
      @posts = Post.where(user: current_user.followeds)
                   .order(created_at: :desc)
                   .paginate(page: params[:page], per_page: 10)
    else
      # Fetch all posts for unauthenticated users
      @posts = Post.all.order(created_at: :desc)
                   .paginate(page: params[:page], per_page: 10)
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /posts/1 or /posts/1.json
  def show; end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Post was successfully created." }
        format.turbo_stream { redirect_to root_path, status: :see_other }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("form_errors", partial: "shared/errors", locals: { object: @post }) }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if @post.update(post_params)
      respond_to do |format|
        format.html { redirect_to post_path(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Post was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: "Post not found."
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:content)
  end

  # Authorize post actions
  def authorize_post
    unless current_user&.admin? || current_user&.moderator? || @post.user == current_user
      redirect_to posts_path, alert: "You are not authorized to perform this action."
    end
  end
end
