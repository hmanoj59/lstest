require 'aws-sdk'
require 'logger'

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

        case @something.todo_action
        when "Start EC2"
          ec2tart(instance_id)
        when "Stop EC2"
          ec2top(instance_id)
        when "Create Rds"
          rdstart()
        when "Delete Rds"
          rdstop()
        else
          puts "undefined"
        end

        format.html { redirect_to @something, notice: 'Something was successfully done, please check the aws console or json file for details.' }
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
        format.html { redirect_to @something, notice: 'Something was successfully updated.' } #redirect_to @something,
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

  def ec2tart(instance_id)

    ec2_client = Aws::EC2::Client.new(
        # region: ENV['AWS_REGION'],
         region: 'us-east-1',
         access_key_id: ENV['AWS_API_KEY'],
         secret_access_key: ENV['AWS_SECRET_KEY']
        # region: ENV['AWS_REGION'],
        # access_key_id: ENV['AWS_API_KEY'],
        # secret_access_key: ENV['AWS_SECRET_KEY']
        # access_key_id: '',
        # secret_access_key: ''
    )

    ec2_client.start_instances({
                                   instance_ids: [@something.instanceid], # required
                                   # additional_info: "String",
                                   dry_run: false,
                               })

    # response = request.send_request


    # redirect_to root_path and return
  end

    def ec2top(instance_id)

      # AWS.config(:logger => Logger.new($stdout))
      ec2_client = Aws::EC2::Client.new(
           region: 'us-east-1',
           access_key_id: ENV['AWS_API_KEY'],
           secret_access_key: ENV['AWS_SECRET_KEY']
      )
      # if @something.instanceid == null
        # @something.instanceid = "i-85a007b4"
      # end
    ec2_client.stop_instances({
                                        dry_run: false,
                                        instance_ids: [@something.instanceid], # required
                                        force: false,
                                    })


    end
    def rdstart()
      rds = Aws::RDS::Resource.new(
      region: 'us-east-1',
      access_key_id: ENV['AWS_API_KEY'],
      secret_access_key: ENV['AWS_SECRET_KEY'])
            dbsnapshots = rds.db_snapshots({
                                               db_instance_identifier: "liquidsky",
                                               db_snapshot_identifier: "liquidsky",
                                               # snapshot_type: "String",
                                              #  filters: [
                                              #      {
                                              #          name: "liquidsky", # required
                                              #          values: ["liquidsky"], # required
                                              #      },
                                              #  ],
                                               # max_records: 1,
                                               # marker: "String",
                                               # include_shared: false,
                                               # include_public: true,
                                           })
            dbsnapshots.first.restore({
                                              db_instance_identifier: "liquidsky", # required
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
            # dbsnapshots.first.delete()



    end


    def rdstop()
      rds = Aws::RDS::Resource.new(
      region: 'us-east-1',
      access_key_id: ENV['AWS_API_KEY'],
      secret_access_key: ENV['AWS_SECRET_KEY']
  )

        dbInstance = rds.db_instance("liquidsky")
        dbInstance.delete({
                      skip_final_snapshot: true,
                      # final_db_snapshot_identifier: "liquidsky",
                          })
        puts "Deleting the instance this may take few minutes"


      end




private

      def something_params
        params.require(:something).permit(:instanceid, :todo_action)
      end

end
