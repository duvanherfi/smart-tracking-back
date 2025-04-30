file = File.read(Rails.root.join("locations.json"))


data = JSON.parse(file)

list = data.map{|info| { lat: info["latitude"].to_f, lon: info["longitude"].to_f }}

json_coordinates = list.map do |info|
  {
    "type": "Feature",
    "properties": {},
    "geometry": {
      "coordinates": [
        info[:lon],
        info[:lat]
      ],
      "type": "Point"
    }
  }
end

h3_ids = list.map{ |info| H3.from_geo_coordinates([info[:lat], info[:lon]], 7) }

uniqs = h3_ids.uniq

# coordinates = uniqs.map do |d|
#   H3.to_boundary(d)
# end

coordinates = H3.h3_set_to_linked_geo(uniqs)
data = JSON.parse(H3.coordinates_to_geo_json coordinates)

#data = { "type": "Polygon", "coordinates": coordinates }

File.open("./info.json", "w") do |f|
  f.write(data.to_json)
end

File.open("./list_locations.json", "w") do |f|
  f.write(json_coordinates.to_json)
end

#----------------------
file = File.read(Rails.root.join("locations.json"))


data = JSON.parse(file)
v = Vehicle.last
data.each do |info|
  Position.create(
    lat: info["latitude"].to_f,
    lon: info["longitude"].to_f,
    course: info["course"].to_i,
    speed: info["speed"].to_i,
    time: info["time"],
    vehicle: v
  )
end