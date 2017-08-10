class FilesController < ApplicationController
  before_filter :authenticate_admin
  def index
    @note_attachments = @current_organization.all_attachments
  end
  def get_all_leads
    @deals = @current_organization.deals.order("id desc")
    render partial: "get_all_leads"
  end
  def filter_files_by_lead
    notes = @current_organization.notes.where(notable_type: "Deal", notable_id: params[:id])
    @deal = @current_organization.deals.find(params[:id])
    @note_attachments = @current_organization.all_attachments notes
    render partial: "show_files"
  end
  def load_all_files
    @note_attachments = @current_organization.all_attachments
    render partial: "show_files"
  end
  def filter_file_on_date_range
    notes = @current_organization.notes.where(created_at: params[:from_date]..params[:to_date])
    @note_attachments = @current_organization.all_attachments notes
    render partial: "show_files"
  end
  def get_all_users
    @users = @current_organization.users.order("first_name asc")
    render partial: "get_all_users"
  end
  def filter_files_by_user
    notes = @current_organization.notes.where(created_by: params[:user_id])
    @user = @current_organization.users.find(params[:user_id])
    @note_attachments = @current_organization.all_attachments notes
    render partial: "show_files"
  end
end
