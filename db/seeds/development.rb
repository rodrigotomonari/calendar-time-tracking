admin = User.find_or_create_by email: 'admin@localhost' do |user|
  user.name     = 'Admin'
  user.email    = 'admin@localhost'
  user.password = 'password'
  user.admin    = true
end

phase_planning  = Phase.find_or_create_by name: "Planning"
phase_desing    = Phase.find_or_create_by name: "Design"
phase_coding    = Phase.find_or_create_by name: "Coding"
phase_qa        = Phase.find_or_create_by name: "QA"
phase_script    = Phase.find_or_create_by name: "Script"
phase_recording = Phase.find_or_create_by name: "Recording"

client_1 = Client.find_or_create_by name: "Client 1"
client_2 = Client.find_or_create_by name: "Client 2"
client_3 = Client.find_or_create_by name: "Client 3"
client_4 = Client.find_or_create_by name: "Client 4"

project_1 = Project.find_or_create_by name: "Project 1" do |project|
  project.client = client_1
end

project_2 = Project.find_or_create_by name: "Project 2" do |project|
  project.client = client_2
end

project_3 = Project.find_or_create_by name: "Project 3" do |project|
  project.client = client_3
end

project_4 = Project.find_or_create_by name: "Project 4" do |project|
  project.client = client_4
end

subproject = Subproject.find_or_create_by name: "Site", project: project_1
[phase_planning, phase_desing, phase_coding, phase_qa].each do |phase|
  SubprojectPhase.find_or_create_by subproject: subproject, phase: phase
end

subproject = Subproject.find_or_create_by name: "App", project: project_1
[phase_planning, phase_desing, phase_coding, phase_qa].each do |phase|
  SubprojectPhase.find_or_create_by subproject: subproject, phase: phase
end

subproject = Subproject.find_or_create_by name: "Site", project: project_2
[phase_planning, phase_desing, phase_coding, phase_qa].each do |phase|
  SubprojectPhase.find_or_create_by subproject: subproject, phase: phase
end

subproject = Subproject.find_or_create_by name: "Blog", project: project_3
[phase_planning, phase_desing, phase_coding, phase_qa].each do |phase|
  SubprojectPhase.find_or_create_by subproject: subproject, phase: phase
end

subproject = Subproject.find_or_create_by name: "App", project: project_3
[phase_planning, phase_desing, phase_coding, phase_qa].each do |phase|
  SubprojectPhase.find_or_create_by subproject: subproject, phase: phase
end

subproject = Subproject.find_or_create_by name: "Movie 1", project: project_4
[phase_planning, phase_script, phase_recording].each do |phase|
  SubprojectPhase.find_or_create_by subproject: subproject, phase: phase
end

subproject = Subproject.find_or_create_by name: "Movie 2", project: project_4
[phase_planning, phase_script, phase_recording].each do |phase|
  SubprojectPhase.find_or_create_by subproject: subproject, phase: phase
end
