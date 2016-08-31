require 'aws-sdk'

class SomethingsController < ApplicationController
  before_action :set_something, only: [:show, :edit, :update, :destroy]

  # GET /somethings
  # GET /somethings.json
  def index
    @somethings = Something.all
    render json: @somethings
  end

  # GET /somethings/1
  # GET /somethings/1.json
  def show
    # render json: @somethings
  end

  # GET /somethings/new
  def new
    @something = Something.new
  end

  # GET /somethings/1/edit
  def edit
  end

  # POST /somethings
  # POST /somethings.json
  def create
    @something = Something.new(something_params)
    instance_id = @something.instanceid

    respond_to do |format|
      if @something.save

        if @something.todo_action == "Start EC2"
          start(instance_id)
        end

        if @something.todo_action == "Stop EC2"
          stop(instance_id)
        end
        if @something.todo_action == "Start RDS"
          rdsstart(instance_id)
        end
        if @something.todo_action == "Stop RDS"
          rdsstop(instance_id)
        end
        format.html { redirect_to @something, notice: 'Something was successfully created.' }
        format.json { render :show, status: :created, location: @something }
      else
        format.html { render :new }
        format.json { render json: @something.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /somethings/1
  # PATCH/PUT /somethings/1.json
  def update
    respond_to do |format|
      if @something.update(something_params)
        # format.html {  notice: 'Something was successfully updated.' } #redirect_to @something,
        format.json { render :show, status: :ok, location: @something }
      else
        format.html { render :edit }
        format.json { render json: @something.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /somethings/1
  # DELETE /somethings/1.json
  def destroy
    @something.destroy
    respond_to do |format|
      format.html { redirect_to somethings_url, notice: 'Something was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_something
      @something = Something.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def something_params
      params.require(:something).permit(:instanceid, :todo_action)
    end
  def start(instance_id)

    ec2_client = Aws::EC2::Client.new(
        # region: ENV['AWS_REGION'],
        access_key_id: ENV['AWS_API_KEY'],
        secret_access_key: ENV['AWS_SECRET_KEY']
    )

    ec2_client.start_instances({
                                   instance_ids: [@something.instanceid], # required
                                   # additional_info: "String",
                                   dry_run: false,
                               })
    puts "Instance started"
    # redirect_to root_path and return
  end

    def stop(instance_id)
      ec2_client = Aws::EC2::Client.new(
          # region: ENV['AWS_REGION'],
          access_key_id: ENV['AWS_API_KEY'],
          secret_access_key: ENV['AWS_SECRET_KEY']
      )
    ec2_client.stop_instances({
                                        dry_run: false,
                                        instance_ids: [@something.instanceid], # required
                                        force: false,
                                    })
    # redirect_to root_path and return
    end
  def rdsstart(instance_id)
    dbsnapshots.first.restore({
                                  db_instance_identifier: dbinstanceidentifier, # required
                                  # db_instance_class: "String",
                                  # port: 3306,
                                  # availability_zone: "String",
                                  # db_subnet_group_name: "String",
                                  multi_az: false,
                                  publicly_accessible: true,
                                  # auto_minor_version_upgrade: false,
                                  # license_model: "String",
                                  # db_name: "String",
                                  # engine: "String",
                                  # iops: 1,
                                  # option_group_name: "String",
                                  # tags: [
                                  #     {
                                  #         key: "String",
                                  #         value: "String",
                                  #     },
                                  # ],
                                  # storage_type: "String",
                                  # tde_credential_arn: "String",
                                  # tde_credential_password: "String",
                                  # domain: "String",
                                  # copy_tags_to_snapshot: false,
                                  # domain_iam_role_name: "String",
                              })
    dbsnapshots.first.delete()
    puts"Starting DB Instance " + dbinstanceidentifier
  end
  def rdsstop(instance_id)
    dbInstance=rds.db_instance()
    dbInstance.delete({
                          skip_final_snapshot: false,
                          final_db_snapshot_identifier: dbsnapshotidentifier,
                      })
    puts "Deleting the instance this may take few minutes"
  end


end
