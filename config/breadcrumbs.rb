# NAMING CONVENTIONS
# (a) crumb names should match path helpers unless there's a good reason otherwise
# (b) Qualifying public routes is a good enough reason to break (a)

# Don't use :root because :root will always be displayed and we want to hide it in editorial mode
crumb :public_root do
  link 'Home', root_path
end

crumb :public_section do |section|
  link section.name, section_path(section)
  parent :public_root
end

crumb :public_node do |node|
  link node.name, nodes_path(section: node.section, path: node.path)
  if node.parent
    parent :public_node, node.parent
  else
    parent :public_section, node.section
  end
end

crumb :editorial_root do
  link 'Editorial Home', editorial_root_path
end

crumb :editorial_section do |section|
  link section.name, editorial_section_path(section)
  parent :editorial_root
end

crumb :editorial_collaborators do |section|
  link 'Collaborators', editorial_collaborators_path(section)
  parent :editorial_section, section
end

crumb :editorial_node do |node|
  link node.name, editorial_node_path(node)
  parent :editorial_section, node.section
end

crumb :prepare_editorial_nodes do |section, parent_node|
  link 'Prepare', prepare_editorial_nodes_path(section: section.andand.id, parent: parent_node.andand.id)
  if parent_node
    parent :editorial_node, parent_node
  elsif section
    parent :editorial_section, section
  else
    parent :editorial_root
  end
end

crumb :new_editorial_node do |section, parent_node, type|
  link 'New', new_editorial_node_path(section: section.andand.id, parent: parent_node.andand.id, type: type)
  parent :prepare_editorial_nodes, section, parent_node
end

crumb :editorial_section_submissions do |section|
  link 'Submissions', editorial_section_submissions_path(section)
  parent :editorial_section, section
end

crumb :editorial_submission do |submission|
  link 'Submission', editorial_submission_path(submission)
  parent :editorial_node, submission.revisable
end

crumb :editorial_submission_new do |node|
  link 'New Submission', new_editorial_node_submission_path(node)
  parent :editorial_node, node
end

# use :editorial_root as parent because the user may not have access to :editorial_section
crumb :editorial_request do |request|
  link 'Membership Request', editorial_request_path(request)
  parent :editorial_root
end

crumb :new_editorial_request do |section|
  link 'Request Membership', new_editorial_request_path(section: section.id)
  parent :editorial_root
end

