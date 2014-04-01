class ProjectpicturesController < ApplicationController

    def show
      @projectpicture = Projectpicture.find(params[:id])
      send_data @projectpicture.data, :filename => @projectpicture.filename, :type => @projectpicture.content_type
    end

end
