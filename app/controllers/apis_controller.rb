class ApisController < ApplicationController


  def ec2start()

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
                                   instance_ids: ["i-85a007b4"], # required
                                   # additional_info: "String",
                                   dry_run: false,
                               })

       redirect_to root_path

  end

  def ec2stop()

    # AWS.config(:logger => Logger.new($stdout))
    ec2_client = Aws::EC2::Client.new(
         region: 'us-east-1',
         access_key_id: ENV['AWS_API_KEY'],
         secret_access_key: ENV['AWS_SECRET_KEY']
    )

  ec2_client.stop_instances({
                                      dry_run: false,
                                      instance_ids: ["i-85a007b4"], # required
                                      force: false,
                                  })

      redirect_to root_path

  end
  def rdsstart()
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

             redirect_to root_path



  end


  def rdsstop()
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


         redirect_to root_path

    end
end
