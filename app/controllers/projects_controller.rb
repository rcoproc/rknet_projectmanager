class ProjectsController < ApplicationController

  # GET /projects
  # GET /projects.xml
  def index
    @projects = initialize_grid(Project, 
                               order: 'name',
                               enable_export_to_csv: true,
                               csv_field_separator: ';',
                               csv_file_name: 'projetos',
                               per_page: 10)

    export_grid_if_requested('grid' => 'grid')

    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.xml  { render :xml => @projects }
    # end
  end

  def report
    respond_to_report('projects', 'select * from projects order by name', 'projects.pdf')
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to(@project, :notice => 'Project was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(project_params)
        format.html { redirect_to(@project, :notice => 'Projeto foi atualizado com sucesso!') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  private

  def project_params
    params.require(:project).permit(
        :name, :description, :owner_id,
        tasks_attributes: [:id, :_destroy, :name, :description, :done, sub_tasks_attributes: [:id, :_destroy, :name, :description] ],
        people_attributes: [:id, :name, :role, :description, :_destroy],
        owner_attributes: [:id, :name, :role, :description, :_destroy],
        project_tags_attributes: [:id, :_destroy, :tag_id,
        tag_attributes: [:id, :_destroy, :name]]

    )
  end
end
