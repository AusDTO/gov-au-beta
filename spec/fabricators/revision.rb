Fabricator(:revision) do
  transient :revisable

  after_build do |revision, transients|
    revision.revisable = if transients[:revisable]
      transients[:revisable]
    else
      Fabricate(:general_content) do
        parent {|attrs| Fabricate(:section_home) unless attrs[:parent].present? }
      end
    end
  end
end
