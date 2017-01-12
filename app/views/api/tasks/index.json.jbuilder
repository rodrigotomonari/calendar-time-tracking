json.array! @tasks do |task|
  json.id task.id
  json.stored true
  json.title task.title
  json.start task.started_at
  json.end task.ended_at
  json.subproject_phase_id task.subproject_phase.id
  json.phase task.subproject_phase.phase.name
  json.subproject task.subproject_phase.subproject.name
  json.project task.subproject_phase.subproject.project.name
  json.color task.subproject_phase.subproject.project.color
  json.client task.subproject_phase.subproject.project.client.name
end