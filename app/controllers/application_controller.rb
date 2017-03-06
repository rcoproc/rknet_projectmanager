require "application_responder"

class ApplicationController < ActionController::Base
  # self.responder = ApplicationResponder
  # respond_to :html, :xml, :pdf

  protect_from_forgery

  def respond_to_report(name, query, filename, download = false, report_params = nil)
    @report = JasperReport.new(name, query, report_params)
    disposition = (download.nil? || download == false ) ? 'inline' : 'attachament'
    send_data @report.to_pdf, :filename => filename, :type => :pdf , :disposition => disposition
  end
end
