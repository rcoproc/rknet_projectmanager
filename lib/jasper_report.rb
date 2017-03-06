
Dir.entries("#{Rails.root}/lib/jasperreports").each do |lib|
  require "jasperreports/#{lib}" if lib =~ /\.jar$/
end

require 'java'

java_import Java::net::sf::jasperreports::engine::JasperFillManager
java_import Java::net::sf::jasperreports::engine::JasperExportManager
java_import Java::net::sf::jasperreports::engine::JRResultSetDataSource
java_import Java::org::apache::commons::collections4::map::ReferenceMap


class JasperReport
  DIR = "#{Rails.root}/app/reports"

  def initialize(report, query, params = nil)
    @model = report
    @report_params = params
    @conn = ActiveRecord::Base.connection.jdbc_connection
    @query = query
  end

  def to_pdf
    stmt = @conn.create_statement
    @result = JRResultSetDataSource.new(stmt.execute_query(@query))
    report_source = "#{DIR}/#{@model}.jasper"
    raise ArgumentError, "O ARQUIVO do Relatório #{@model} não existe." unless File.exist?(report_source)
    params = {}
    params.merge!(@report_params) if @report_params.present?
    fill = JasperFillManager.fill_report(report_source, params, @conn)
    pdf = JasperExportManager.export_report_to_pdf(fill)
    return String.from_java_bytes(pdf)
  end
end
