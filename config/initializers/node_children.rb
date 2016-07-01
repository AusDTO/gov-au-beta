# Ensure all models are loaded at startup
# This ensures that any children of Node are loaded so that we
# know all of the Node types at runtime
# FIXME: Put nodes in a subdir so we can load just them
Dir.glob('./app/models/*.rb') { |f| require f }
