namespace :data do
  desc "Creates departments and agencies"
  task create_depts: :environment do
    Department.all.each{ |d| d.home_node && d.home_node.delete }
    Agency.all.each{ |a| a.home_node && a.home_node.delete }

    Agency.delete_all
    Department.delete_all

    departments = {
      'Agriculture And Water Resources' => [
        'Australian Fisheries Management Authority',
        'Australian Grape and Wine Authority',
        'Australian Pesticides and Veterinary Medicines Authority',
        'Cotton Research and Development Corporation',
        'Fisheries Research and Development Corporation',
        'Grains Research and Development Corporation',
        'Murray-Darling Basin Authority',
        'Rural Industries Research and Development Corporation'
      ],
      'Attorney-General\'s' => [
      	'Administrative Appeals Tribunal',
      	'Australian Commission for Law Enforcement Integrity',
      	'Australian Crime Commission',
      	'Australian Federal Police',
      	'Australian Financial Security Authority',
      	'Australian Human Rights Commission',
      	'Australian Institute of Criminology',
      	'Australian Law Reform Commission',
      	'Australian Security Intelligence Organisation',
      	'Australian Transaction Reports and Analysis Centre',
      	'CrimTrac Agency',
      	'Family Court and Federal Circuit Court',
      	'Federal Court of Australia',
      	'National Archives of Australia',
      	'Office of Parliamentary Counsel',
      	'Office of the Australian Information Commissioner',
      	'Office of the Director of Public Prosecutions'
      ],
      'Department of Communications and the Arts' => [
      	'Australia Business Arts Foundation (operating as Creative Partnerships Australia)',
      	'Australia Council',
      	'Australian Film, Television and Radio School',
      	'Australian National Maritime Museum',
      	'Australian Postal Corporation',
      	'Bundanon Trust',
      	'Museum of Australian Democracy at Old Parliament House',
      	'National Film and Sound Archive of Australia',
      	'National Gallery of Australia',
      	'National Library of Australia',
      	'National Museum of Australia',
      	'National Portrait Gallery of Australia',
      	'NBN Co Limited',
      	'Screen Australia',
      	'Australian Broadcasting Corporation',
      	'Australian Communications and Media Authority',
      	'Special Broadcasting Service Corporation',
      	'Children\'s e-Safety Commissioner'
      ],
      'Department of Defence' => [
      	'Army Amenities Fund Company',
      	'Army and Air Force Canteen Service',
      	'Australian Military Forces Relief Trust Fund',
      	'Australian Strategic Policy Institute Limited',
      	'Defence Housing Australia',
      	'RAAF Welfare Recreational Company',
      	'Royal Australian Air Force Veterans Residences Trust Fund',
      	'Royal Australian Air Force Welfare Trust Fund',
      	'Royal Australian Navy Central Canteens Board (Royal Australian Navy Central Canteens Fund)',
      	'Royal Australian Navy Relief Trust Fund',
      	'Australian War Memorial'
      ],
      'Department of Veterans\' Affairs' => [],
      'Department of Education and Training' => [
      	'Australian Curriculum, Assessment and Reporting Authority',
      	'Australian Institute for Teaching and School Leadership Limited',
      	'Australian Institute of Aboriginal and Torres Strait Islander Studies',
      	'Australian National University',
      	'Australian Research Council',
      	'National Vocational Education and Training Regulator (Australian Skills Quality Authority)',
      	'Tertiary Education Quality and Standards Agency'
      ],
      'Department of Employment' => [
      	'Asbestos Safety and Eradication Agency',
      	'Coal Mining Industry (Long Service Leave Funding) Corporation',
      	'Comcare',
      	'Fair Work Commission',
      	'Office of the Fair Work Building Industry Inspectorate',
      	'Office of the Fair Work Ombudsman',
      	'Safe Work Australia',
      	'Seafarers Safety, Rehabilitation and Compensation Authority',
      	'Workplace Gender Equality Agency'
      ],
      'Department of the Environment' => [
      	'Australian Renewable Energy Agency',
      	'Bureau of Meteorology',
      	'Clean Energy Finance Corporation',
      	'Clean Energy Regulator',
      	'Climate Change Authority',
      	'Director of National Parks',
      	'Great Barrier Reef Marine Park Authority',
      	'Sydney Harbour Federation Trust'
      ],
      'Department of Finance' => [
      	'ASC Pty Ltd',
      	'Australian Electoral Commission',
      	'Commonwealth Superannuation Corporation',
      	'Future Fund Management Agency'
      ],
      'Department of Foreign Affairs and Trade' => [
      	'Australian Centre for International Agricultural Research',
      	'Australian Secret Intelligence Service',
      	'Australian Trade Commission (Austrade)',
      	'Export Finance and Insurance Corporation',
      	'Tourism Australia'
      ],
      'Department of Health' => [
      	'Australian Aged Care Quality Agency',
      	'Australian Commission on Safety and Quality in Health Care',
      	'Australian Institute of Health and Welfare',
      	'Australian National Preventive Health Agency',
      	'Australian Organ and Tissue Donation and Transplantation Authority',
      	'Australian Radiation Protection and Nuclear Safety Agency',
      	'Australian Sports Anti-Doping Authority',
      	'Australian Sports Commission',
      	'Australian Sports Foundation Limited',
      	'Cancer Australia',
      	'Food Standards Australia New Zealand',
      	'Independent Hospital Pricing Authority',
      	'National Blood Authority',
      	'National Health and Medical Research Council',
      	'National Health Funding Body',
      	'National Health Performance Authority',
      	'National Mental Health Commission',
      	'Professional Services Review'
      ],
      'Department of Immigration and Border Protection' => [],
      'Department of Industry, Innovation and Science' => [
      	'Australian Institute of Marine Science',
      	'Australian Nuclear Science and Technology Organisation',
      	'Commonwealth Scientific and Industrial Research Organisation',
      	'Geoscience Australia',
      	'IIF Investments Pty Limited',
      	'IP Australia',
      	'National Offshore Petroleum Safety and Environmental Management Authority'
      ],
      'Department of Infrastructure and Regional Development' => [
      	'Infrastructure Australia',
      	'Airservices Australia',
      	'Australian Maritime Safety Authority',
      	'Australian Rail Track Corporation Limited',
      	'Australian Transport Safety Bureau',
      	'Civil Aviation Safety Authority',
      	'Moorebank Intermodal Company Limited',
      	'National Capital Authority',
      	'National Transport Commission'
      ],
      # 'Department of Parliamentary Services' => [],
      # 'Department of the House of Representatives' => [],
      # 'Department of the Senate' => [],
      # 'Parliamentary Budget Office' => [],
      'Department of the Prime Minister and Cabinet' => [
      	'Aboriginal Hostels Limited',
      	'Anindilyakwa Land Council',
      	'Australian National Audit Office',
      	'Australian Public Service Commission',
      	'Central Land Council',
      	'Digital Transformation Office',
      	'Indigenous Business Australia',
      	'Indigenous Land Corporation',
      	'National Australia Day Council Limited',
      	'Northern Land Council',
      	'Office of National Assessments',
      	'Office of the Commonwealth Ombudsman',
      	'Office of the Inspector-General of Intelligence and Security',
      	'Office of the Official Secretary to the Governor-General',
      	'Outback Stores Pty Ltd',
      	'Tiwi Land Council',
      	'Torres Strait Regional Authority',
      	'Wreck Bay Aboriginal Community Council'
      ],
      'Department of Social Services' => [
      	'Australian Institute of Family Studies',
      	'National Disability Insurance Agency',
      	'Department of Human Services',
      	'Australian Hearing Services'
      ],
      'Department of the Treasury' => [
      	'Australian Bureau of Statistics',
      	'Australian Competition and Consumer Commission',
      	'Australian Office of Financial Management',
      	'Australian Prudential Regulation Authority',
      	'Australian Reinsurance Pool Corporation',
      	'Australian Securities and Investments Commission',
      	'Australian Taxation Office',
      	'Commonwealth Grants Commission',
      	'Corporations and Markets Advisory Committee',
      	'Inspector-General of Taxation',
      	'National Competition Council',
      	'Office of the Auditing and Assurance Standards Board',
      	'Office of the Australian Accounting Standards Board',
      	'Productivity Commission',
      	'Reserve Bank of Australia',
      	'Royal Australian Mint'
      ]
    }

    departments.each do |dept_name, agencies|

      puts "** #{dept_name} **"

      dept = Department.find_or_create_by!(name: dept_name)

      agencies.each do |agency_name|
        puts "** #{agency_name} **"
        agency = Agency.find_or_create_by!(name: agency_name)
        dept.sections << agency
      end

      dept.save!
    end

  end

end
