class RemindersController < ApplicationController
  before_filter :set_reminder, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @upcoming_reminders = Reminder.where("reminder_date >= ?", Time.zone.now.end_of_day).order("reminder_date asc").limit(5)
    @today_reminders = Reminder.where(:reminder_date => (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).order("reminder_date desc")
    respond_with(@reminders)
  end

  def show
    respond_with(@reminder)
  end

  def new
    @reminder = Reminder.new
    respond_with(@reminder)
  end

  def edit
  end

  def create
    @reminder = Reminder.create(:title => params[:reminder][:title], :description => params[:reminder][:description], :reminder_date => params[:reminder][:reminder_date], :email_ids => params[:reminder][:email_ids], :send_before => params[:reminder][:send_before], :reminder_type_id => params[:reminder][:reminder_type_id], :deal_id => params[:reminder][:deal_id])
    #render :json => "success"
    # @reminder = Reminder.new(params[:reminder])
    # @reminder.save
    # respond_with(@reminder)
  end

  def get_day_reminder
    if params[:selected_date].present?
      @today_reminders = Reminder.where(:reminder_date => (Date.parse(params[:selected_date]).beginning_of_day..Date.parse(params[:selected_date]).end_of_day)).order("reminder_date desc")
      render :partial => "today_reminders"
    end
  end

  def update
    @reminder.update_attributes(params[:reminder])
    respond_with(@reminder)
  end

  def destroy
    @reminder.destroy
    respond_with(@reminder)
  end

  private
    def set_reminder
      @reminder = Reminder.find(params[:id])
    end
end
