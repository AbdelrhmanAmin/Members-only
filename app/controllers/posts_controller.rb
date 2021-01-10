class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[new create]

  def signed_in_only!
    # current_user in ApplicationController must be defined as helper method to make it work
    redirect_to new_user_session_path unless current_user
  end

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.order('created_at DESC')
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to root_path
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :body)
  end
end
