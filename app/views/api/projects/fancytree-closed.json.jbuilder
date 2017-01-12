json.array! [1] do
  json.title 'Projetos'
  json.folder true
  json.children @projects do |project|
    json.partial! 'api/projects/partial/fancytree-project', project: project
  end
end