json.title project.name
json.key project.id
json.folder true
json.children project.subprojects do |subproject|
  json.title subproject.name
  json.key subproject.id
  json.folder true
  json.children subproject.subproject_phases do |subproject_phase|
    json.title subproject_phase.phase.name
    json.key subproject_phase.id

    json.subproject_phase_id subproject_phase.id
    json.description subproject_phase.title
    json.project project.name
    json.subproject subproject.name
    json.client project.client.name
    json.phase subproject_phase.phase.name
    json.color subproject_phase.color
  end
end
