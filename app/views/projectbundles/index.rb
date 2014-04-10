wb = xlsx_package.workbook

wb.add_worksheet(:name => "Projektijaot") do |sheet|
  array = ["Opiskelija", "Opiskelijanumero"]
  @projectbundle.projects.each do |proj|
    array << proj.name
  end
  array << "Opiskelijalla projekteja"
  array << "Magic number"
  sheet.add_row array
  stdntArray = []
  projId = 1
  @projectbundle.enrollments.each do |roll|
    stdntArray << roll.name
    stdntArray << roll.studentnumber
    while projId <= @projectbundle.projects.count do
      proju =roll.signups.find_by_project_id(projId)
      if not proju.nil?
        if proju.status
          stdntArray << 'Valittu'
        else
          stdntArray << 'Ei valittu'
        end
      else
        stdntArray << " "
      end
      projId = projId + 1
    end
    great = roll.signups.where(status: true)
    if not great.nil?
      stdntArray << great.count
    else
      stdntArray << '0'
    end
    stdntArray << roll.magic_number
    projId = 1
    sheet.add_row stdntArray
    stdntArray = []
  end
  arrayStats = ["Opiskelijoita", " "]
  arrayFills = ["Täyttöaste", " "]
  @projectbundle.projects.each do |proj|
    accStudnts = proj.signups.where(status: true)
	if not accStudnts.nil?
   # studnts= accStudnts + "/" + proj.maxstudents
  #  arrayStats << accStudnts.count.to_s
    arrayStats << "" + accStudnts.count.to_s + "/" + proj.maxstudents.to_s + ""
    fill = accStudnts.count - proj.maxstudents
    arrayFills << fill.to_s
	else
		arrayStats << '0'
    arrayFills << "-" + maxstudents.to_s + ""
	end
  end
  sheet.add_row arrayStats
  sheet.add_row arrayFills



end
