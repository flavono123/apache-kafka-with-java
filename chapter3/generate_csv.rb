require "csv"
require "json"

# generate from json file
# json format is array of {method, path, description}

CSV.open("connect-rest.csv", "w") do |csv|
  csv << ["METHOD", "PATH", "DESC"]
  JSON.parse(File.read("connect-rest.json")).each do |api|
    csv << [api["method"], api["path"], api["description"]]
  end
end
