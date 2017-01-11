json.array! @tasks do |task|
  json.id task.id
  json.stored true
  json.title task.title
  json.start task.started_at
  json.end task.ended_at
  json.phase task.subproject_phase.phase.name
  json.subproject task.subproject_phase.subproject.name
  json.project task.subproject_phase.subproject.project.name
  json.color task.subproject_phase.subproject.project.color.present? ? "#{task.subproject_phase.subproject.project.color}" : ''
end