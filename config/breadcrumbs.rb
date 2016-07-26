# NAMING CONVENTIONS
# (a) crumb names should match path helpers unless there's a good reason otherwise
# (b) Qualifying public routes is a good enough reason to break (a)

crumb :departments do
  link 'Departments', departments_path
  parent :public_node, Node.root_node
end

crumb :ministers do
  link 'Ministers', ministers_path
  parent :public_node, Node.root_node
end

crumb :public_node do |node|
  if node.parent.present?
    link node.name, public_node_path(node)
    parent :public_node, node.parent
  else
    link 'Home', root_path
  end
end

crumb :category do |name|
  link name, nil #TODO: change this once we have Category model
  parent :public_node, Node.root_node
end

crumb :editorial_root do
  link 'Editorial Home', editorial_root_path
end

crumb :editorial_section do |section|
  link section.name, editorial_section_path(section)
  parent :editorial_root
end

crumb :editorial_collaborators do |section|
  link 'Collaborators', editorial_section_collaborators_path(section)
  parent :editorial_section, section
end

crumb :editorial_node do |node|
  link node.name, editorial_section_node_path(node.section, node)
  parent :editorial_section, node.section
end

crumb :prepare_editorial_nodes do |section, parent_node|
  link 'Prepare', prepare_editorial_section_nodes_path(section: section.andand.id, parent: parent_node.andand.id)
  if parent_node
    parent :editorial_node, parent_node
  elsif section
    parent :editorial_section, section
  else
    parent :editorial_root
  end
end

crumb :new_editorial_node do |section, parent_node, type|
  link 'New', new_editorial_section_node_path(section, parent: parent_node.andand.id, type: type)
  parent :prepare_editorial_nodes, section, parent_node
end

crumb :edit_editorial_node do |node|
  link 'Edit', edit_editorial_section_node_path(node.section, node)
  parent :editorial_node, node
end

crumb :editorial_section_submissions do |section|
  link 'Submissions', editorial_section_submissions_path(section)
  parent :editorial_section, section
end

crumb :editorial_submission do |submission|
  link 'Submission', editorial_section_submission_path(submission.section, submission)
  parent :editorial_node, submission.revisable
end

crumb :editorial_submission_new do |node|
  link 'New Submission', new_editorial_section_submission_path(node.section, node)
  parent :editorial_node, node
end

# use :editorial_root as parent because the user may not have access to :editorial_section
crumb :editorial_request do |request|
  link 'Membership Request', editorial_section_request_path(request.section, request)
  parent :editorial_root
end

crumb :new_editorial_request do |section|
  link 'Request Membership', new_editorial_section_request_path(section)
  parent :editorial_root
end

crumb :public_news_articles do |section|
  link 'News', section_news_articles_path(section.home_node.slug)
  parent :public_node, section.home_node
end

crumb :public_news_article do |node|
  link node.name, public_node_path(node)
  parent :public_news_articles, node.section
end
