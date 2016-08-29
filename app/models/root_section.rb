class RootSection < Section
resourcify

after_initialize :assign_defaults, if: 'new_record?'

def generate_home_node
  # no home_node needed
end

private
def assign_defaults
  self.name = "Root level pages"
end
end
