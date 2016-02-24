class RelationshipsController < ApplicationController

  include ApplicationHelper
  before_filter :authenticate

  def create
    @followed_id = params[:relationship][:followed_id]
    @type = params[:relationship][:relationship_type]

    relationship = Relationship.new(params[:relationship])
    relationship.follower = @current_user
    @object = relationship.target

    if relationship.save
      respond_to do |format|
         format.html {redirect_to @object}
         format.js # if no block, it will execute action_name.js.erb
      end
    end
  end

  def destroy
    relationship = Relationship.find(params[:id])
    @followed_id = relationship.followed_id
    @type = relationship.relationship_type
    @object = relationship.target
    relationship.delete
    respond_to do |format|
       format.html {redirect_to @object}
       format.js # if no block, it will execute action_name.js.erb
    end
  end


end
