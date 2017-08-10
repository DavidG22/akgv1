class ApiController < ApplicationController
# /****************************************************************************************
#WakeupSales Community Edition is a web based CRM developed by WakeupSales. Copyright (C) 2015-2016

#This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License version 3 as published by the Free Software Foundation with the addition of the following permission added to Section 15 as permitted in Section 7(a): FOR ANY PART OF THE COVERED WORK IN WHICH THE COPYRIGHT IS OWNED BY SUGARCRM, SUGARCRM DISCLAIMS THE WARRANTY OF NON INFRINGEMENT OF THIRD PARTY RIGHTS.

#This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

#You should have received a copy of the GNU General Public License along with this program; if not, see http://www.gnu.org/licenses or write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

#You can contact WakeupSales, 2059 Camden Ave. #118, San Jose, CA - 95124, US.  or at email address support@wakeupsales.org.

#The interactive user interfaces in modified source and object code versions of this program must display Appropriate Legal Notices, as required under Section 5 of the GNU General Public License version 3.

#In accordance with Section 7(b) of the GNU General Public License version 3, these Appropriate Legal Notices must retain the display of the "Powered by WakeupSales" logo. If the display of the logo is not reasonably feasible for technical reasons, the Appropriate Legal Notices must display the words "Powered by WakeupSales".

#*****************************************************************************************/

skip_before_filter  :authenticate_user!, :only => [:save_bug_report]
skip_before_filter  :verify_authenticity_token, :only => [:save_bug_report]
 include HotLeadAssignment


 def api_contact_us
   xml_start_node = "<message>"
   xml_end_node = "</message>"
   if (params[:email] != "") && (params[:name] != "") && (params[:message] != "") &&  (params[:phone] != "") 
      build_contact_us_info(params[:email],params[:name],params[:message], params[:phone], true)
      msg = xml_start_node +"<success>Successfully saved the contact us information.</success>"+ xml_end_node
   else
      msg = xml_start_node +"<error>Error while saving contact us information.</error>"+ xml_end_node
   end
   respond_to do |format|
      format.json  { render :json => Hash.from_xml(msg).to_json }  
   end
 end

def createLead
   
  
end

 def update_source(deal,src,org)
   if src
     src = org.name.gsub(" ", "-") + "-" + src
     extsrc = Source.where("name=?",src).first
     if !extsrc.present?
      source= Source.new
      source.organization = org
      source.name = src
      source.save
     end
     dealsrc = DealSource.where(:deal_id=> deal.id).first
      if dealsrc.present? && extsrc.present? 
        dealsrc.update_column :source_id, extsrc.id
      else
        if  extsrc.present?
        DealSource.create(:organization =>org,:deal_id=>deal.id,:source_id=> extsrc.id)
        else
          DealSource.create(:organization =>org,:deal_id=>deal.id,:source_id=> source.id) 
        end
      end
    end
 end
 
  def save_company_contact(myname,email,phoneno,country,admin,timezoneoffset,company,website, org) 
    compContact = CompanyContact.where("email =? and organization_id=?", email, org.id.to_i)
    contact = compContact.first
    if compContact.present?
      compContact={}
      compContact[:work_phone] = phoneno if phoneno.present?
      compContact[:email] = email if email.present?
      compContact[:country] = country if country.present?
      contact.update_attributes(compContact)
                
      return contact
      
    else
      compContact = CompanyContact.new
      compContact.organization_id= org.id.to_i
      compContact.name = (myname ||=company)
      compContact.email =email
      compContact.country = country
      compContact.work_phone =phoneno
      compContact.website = website
      compContact.created_by =admin
      compContact.time_zone = ActiveSupport::TimeZone[timezoneoffset.to_f].name if timezoneoffset.present?
      if compContact.save
        return compContact
      end
    end
  end
 
 
  def save_individual_contact(name,email,phoneno,country,admin,timezoneoffset, org) 
    invcontact = IndividualContact.where("email =? and organization_id=?", email, org.id)
    contact = invcontact.first
    if invcontact.present?
      individual_contact={}
      individual_contact[:work_phone] = phoneno if phoneno.present?
        if contact.address.present?
            individual_contact[:street]= contact.address.address if contact.address.address.present?
            individual_contact[:city]= contact.address.city if contact.address.city.present?
            individual_contact[:state]= contact.address.state if contact.address.state.present?
            individual_contact[:zip_code]= contact.address.zipcode if contact.address.zipcode.present?
        end
            individual_contact[:email] = email if email.present?
            individual_contact[:country] = country if country.present?
            contact.update_attributes(individual_contact)
                
      return contact
      
    else
      invcontact = IndividualContact.new
      invcontact.organization_id=org.id.to_i
      invcontact.first_name = name
      invcontact.email =email
      invcontact.country = country
      invcontact.work_phone =phoneno
      invcontact.created_by =admin
      invcontact.time_zone = ActiveSupport::TimeZone[timezoneoffset.to_f].name if timezoneoffset.present?
      if invcontact.save
        
        return invcontact
      end
    end
  end 
  def save_bug_report
    if ReportABug.create(email: params[:email], bug_type: params[:bug_type], description: params[:description], ip_address: request.ip)
      render text: "Success"
    else
      render text: "Fail"
    end
  end
  
end

