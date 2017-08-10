  class TasksDatatable
  include ApplicationHelper
  delegate :params, :h, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: tasks_info((@user=User.find params[:cuser]), params[:task_status]).select("id").count,
      iTotalDisplayRecords: tasks.present? ? tasks.total_entries : 0,
      aaData: data
    }
  end

private

  def tasks_info(user, task_status,deal_id = "0")
    deal=nil
    if(!deal_id.nil? && !deal_id.blank? && deal_id != "0")
      deal=Deal.find deal_id
    end
    Task.task_list(user, task_status,deal)
  end
  
  def get_priority_color(task)
    clr="green"
    if task.priority_type.present? && task.priority_type.original_id == 1
      clr="red"
    elsif task.priority_type.present? && task.priority_type.original_id == 2
      clr="blue"
    end
    clr
  end
  
  def get_style_bg(task)
    style_bg=""
    style_bg="background:#F5F8FC;" if task.is_completed
  end  
  
  def get_style_text(task)
    style_text=""
    style_text="text-decoration:line-through;overflow:hidden;" if task.is_completed
  end

  def get_style_css(task)
    style_text=""
    style_text="text-decoration:line-through;overflow:hidden;" if task.is_completed
    deal = task.deal
    if deal.present? && deal.deals_contacts.present? && deal.deals_contacts.first.contactable.present? && deal.deals_contacts.first.contactable.image.present?
      style_text += "margin-left:45px;margin-top:-45px;position:absolute;"
    end
  end
  
  def get_datetime(task)
     case params[:task_status]
         when "today"
            task.due_date.strftime("%H:%M")
         when "overdue"
         
         when "upcoming"
            task.due_date.strftime("%a %d %b %Y @ %H:%M")
         when "completed"
     end
  end
  
  def get_datetime_as_per_type(task_type,task)
     case task_type
         when "today"
            task.due_date.strftime("%H:%M")
         when "overdue"
         
         when "upcoming"
            task.due_date.strftime("%a %d %b %Y @ %H:%M")
         when "completed"
     end
  end

  def checkbox_div(task,cuser)
    #status="<input class='task_chk' id='complete_task_#{task.id}' name='complete_task' onclick='task_outcome(#{task.id})' type='checkbox'>"
   # if task.is_completed && cuser.is_admin?
    if task.is_completed && cuser.is_admin?


      status="<input class='task_chk' id='complete_task_#{task.id}' name='complete_task'  onclick='task_outcome(#{task.id})' disabled='disabled' type='checkbox'  checked='checked'>"    
    #elsif task.is_completed && !cuser.is_admin?
    #  status="<input class='task_chk' id='complete_task_#{task.id}' name='complete_task' onclick='task_outcome(#{task.id})' disabled='disabled' type='checkbox' checked='checked'>"
    else
     status="<input class='task_chk' id='complete_task_#{task.id}' name='complete_task' onclick='task_outcome(#{task.id});' type='checkbox'>"
    end
    status
  end
  
  def get_user_name(cuser, task)
    user=task.initiator #User.where("id=?",task.created_by).first
    name=""
    if user.present? && user.id == cuser.id
      name="me"
    elsif user.present?
      name=user.full_name
    end
  end
  
  def get_task_count(counter)
    counter=tasks.select("id").where("is_completed=?", false) if params[:task_status] == "all"
    counter.count
  end
  def data
#    cuser=User.find params[:cuser]
    @count = tasks.count
    @count = tasks.select("id").where("is_completed=?", false).count if params[:task_status] == "all"
    tasks.map do |task|
      deal = task.deal
      [
        h(get_priority_color(task)),#row[0]
        h(get_style_bg(task)),#row[1]
        (checkbox_div(task,@user)),#row[2]
        h(task.id),#row[3]
        h(task.get_title),#row[4]
        h(task.due_date.present? ? (task.due_date.strftime("%a %d %b %Y @ %H:%M")) : ""),#row[5]
        h(task.user.present? ? task.user.full_name : "NA"),#row[6]
        h(format_date(task.created_at)),#row[7]
        h(get_user_name(@user, task)),#row[8]
        h(task.task_note.present? ? task.task_note : ""),#row[9]
        h(task.task_type.name),#row[10]
        h(task.is_completed),#row[11]
        h(task.get_url),#row[12]
        h(get_style_text(task)),#row[13]
        h(@count),#row[14]
        h(task.updated_at.present? ? (task.updated_at.strftime("%a %d %b %Y @ %H:%M")) : ""),#row[15]
        h(get_datetime(task)),#row[16]
        #h(get_datetime_as_per_type(task.belongs_to_category, task))
        h(task.due_date.present? ? (get_datetime_as_per_type(task.belongs_to_category, task)) : ""),#row[17]
        h(task.recurring_type != "none"),#row[18]
        h(deal.present? && deal.contact_name.present? ? deal.contact_name : ""),#row[19]
        h(deal.present? && deal.contact_email.present? ? deal.contact_email : ''), #row[20]
        h(deal.contact_name[0].upcase), #row[21]
        h(deal.get_color_code(deal.contact_name.downcase[0])), #row[22]
        h(deal.deals_contacts.present? && deal.deals_contacts.first.contactable.image.present? ? deal.deals_contacts.first.contactable.image.image.url(:icon) : ""), #row[23]
        h(deal.deals_contacts.present? && deal.deals_contacts.first.contactable.present? ? deal.deals_contacts.first.contactable.id : ""), #row[24]
        h(deal.deals_contacts.present? && deal.deals_contacts.first.contactable.present? ? deal.deals_contacts.first.contactable.class.name : ""), #row[25]
        h(get_style_css(task)),#row[26]
        h(deal.contact_info['id']), #row[27]
        h(task.get_title_hover) #row[28]
      ]
    end
  end
  
  def tasks
    @tasks ||= fetch_tasks
  end

  def fetch_tasks
    tasks=tasks_info(@user, params[:task_status],params[:deal_id])
    if tasks.present?
      tasks = tasks.page(page).per_page(per_page)
#      if params[:filter_type].present?
#        if params[:filter_type].include?("0")
#          params[:filter_type].delete("0")
#          if params[:filter_type].present?
#            tasks = tasks.includes(:task_type).where("is_completed = ? AND task_types.id IN (?)", true, params[:filter_type])
#          else

#            tasks = tasks.includes(:task_type).where("is_completed = ?", true)
#          end
#        else


#          tasks = tasks.includes(:task_type).where("task_types.id IN (?)", params[:filter_type])
#        end
#      end
    if params[:t_type].present? && params[:assigned_to].present? 
        tasks=tasks.active_multi_filter_usage_summery(params).page(page).per_page(per_page) 
    else
        tasks=tasks.active_multi_filter(params).page(page).per_page(per_page) if params[:deal_type].present? || params[:asg_to].present? || params[:task_type].present? || params[:dt_range].present?
        tasks=tasks.active_multi_filter_report(params).page(page).per_page(per_page) if params[:assigned_to].present? 
        tasks=tasks.active_multi_filter_usage_summery(params).page(page).per_page(per_page) if params[:t_type].present?
    end
      if params[:sSearch].present?
        tasks = tasks.where("(title like :search)", search: "%#{params[:sSearch]}%")
      end
    end
    tasks
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[title]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
