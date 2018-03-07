json.array! @projects do |project|
  json.partial! 'api/projects/partial/fancytree-project', project: project
end
