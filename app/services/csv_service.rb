class CsvService
  def self.generate_csv(headers, rows)
    CSV.generate(headers: true) do |csv|
      csv << headers
      rows.each { |row| csv << row }
    end
  end
end
