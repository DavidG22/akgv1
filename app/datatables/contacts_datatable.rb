class ContactsDatatable
  include ApplicationHelper
  include ContactsHelper
  include ActionView::Helpers::DateHelper
  delegate :params, :h, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    cuser =User.find params[:cuser]
	if cuser.is_super_admin?
		all_contacts = cuser.organization.individual_contacts.count #+ cuser.organization.company_contacts.count
	else
		all_contacts = IndividualContact.where("created_by=?", cuser.id).count #+ CompanyContact.where("created_by=?", cuser.id).count
	end
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: all_contacts,
      iTotalDisplayRecords: all_contacts,
      aaData: data
    }
  end

private
  def data
    # Display each record of IndividualContact and CompanyContact in datatable
    contacts.map do |con|

      if con.class.name == "IndividualContact"
        cont_type = "individual"
      else
        cont_type = "company"
      end
      ph = con.phones.by_phone_type "work"
      # Find last touch of the Individual or Company contact.
      activ_date = show_contact_last_activity(con.id,"#{cont_type}")[0] if con.present?
      activ_by = show_contact_last_activity(con.id,"#{cont_type}")[1] if con.present?
      if( activ_by.present? && activ_date.present? )
        last_touch = "#{activ_date} ago * by #{activ_by}"
      else
        last_touch = "No Activity Found"
      end
      if cont_type == "individual"
        [
          h(con.id),
          h("individual_contact"),
          h(con.full_name.present? ? con.full_name[0].upcase : (con.email.present? ? con.email[0].upcase : "NA")),
          h(con.full_name),
          h(con.email.present? ? con.email : "NA"),
          h(con.company_contact.present? ? con.company_contact.name : "NA"),
          h(con.country.present? ? con.country.name : "NA"),
          h(ph.present? ? ph.first.phone_no : "NA"),
          h(con.website.present? ? con.website : "NA"),
          h(Contact.get_color_code(con.full_name.present? ? con.full_name.downcase[0] : "N")),
          h(con.class.name),
          h(con.image.present? ? con.image.image.url(:icon) : ""),
          h(con.company_contact.present? ? ("contact/"+con.company_contact.to_param+"?type=company") : "javascript:void(0)"), #row[12]
          h(con.is_csv), #row[13]
          h(con.id), #row[14]
          h(con.contact_opportunity.present? ? con.contact_opportunity.opportunity : ""), #row[15]
          h(con.contact_opportunity.present? ? con.contact_opportunity.is_converted : ""), #row[16]
          h(con.contact_opportunity.present? ? con.contact_opportunity.deal.to_param : "") #row[17]
        ]
      else
        [
          h(con.id),
          h("company_contact"),
          h(con.name.present? ? con.name[0].upcase : con.email[0].upcase),
          h(con.name),
          h(con.email.present? ? con.email : "NA"),
          h("NA"),
          h(con.country.present? ? con.country.name : "NA"),
          h(ph.present? ? ph.first.phone_no : "NA"),
          h(con.website.present? ? con.website : "NA"),
          h(Contact.get_color_code(con.name.downcase[0])),
          h(con.class.name),
          h(con.image.present? ? con.image.image.url(:icon) : "")
        ]
      end
    end


  end
  # Get all Individual and Company Contact.
  def contacts
    @contacts ||= fetch_contacts
  end
  # Fetch all Individual and Company Contact.
  def fetch_contacts
    cuser =User.find params[:cuser]
	if cuser.is_super_admin?
		individual_contacts = cuser.organization.individual_contacts.order("#{sort_column} #{sort_direction}")
		#company_contacts = cuser.organization.company_contacts.order("#{sort_company_column} #{sort_direction}")
    else
		individual_contacts = IndividualContact.where("created_by=?", cuser.id).order("#{sort_column} #{sort_direction}")
		#company_contacts = CompanyContact.where("created_by=?", cuser.id).order("#{sort_company_column} #{sort_direction}")
	end
    if params[:sSearch].present?
      individual_contacts = individual_contacts.where("first_name like :search or email like :search", search: "%#{params[:sSearch]}%")
      #company_contacts = company_contacts.where("name like :search or email like :search", search: "%#{params[:sSearch]}%")

    end
    # Return combined contacts object and paginate
    all_contacts = individual_contacts #+ company_contacts
    all_contacts.paginate(:page => page, :per_page => per_page)
  end
  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 20
  end

  def sort_column
    columns = %w[id first_name email]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_company_column
    columns = %w[id name email]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "desc" : "asc"
  end
end
