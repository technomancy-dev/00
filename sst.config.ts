/// <reference path="./.sst/platform/config.d.ts" />

export default $config({
  app(input) {
    return {
      name: "double-zero",
      removal: input?.stage === "production" ? "retain" : "remove",
      home: "aws",
    };
  },
  async run() {
    if (!process.env.EMAIL_IDENTITY) {
      const message = "Need to set EMAIL_IDENTITY env variable.";
      console.error(message);
      throw Error(message);
    }

    const queue = new sst.aws.Queue("ZeroEmailSQS");

    let service;
    if (
      process.env.SST_DEPLOY &&
      process.env.PHX_HOST &&
      process.env.DATABASE_PATH
    ) {
      const vpc = new sst.aws.Vpc("ZeroEmailVpc");

      const cluster = new sst.aws.Cluster("ZeroEmailCluster", { vpc });

      const bucket = new sst.aws.Bucket("ZeroSQLiteBucket", {
        public: false,
      });

      service = cluster.addService("ZeroEmailService", {
        public: {
          domain: {
            name: process.env.PHX_HOST,
          },
          ports: [
            { listen: "80/http", forward: "4000/http" },
            { listen: "443/https", forward: "4000/http" },
          ],
        },
        environment: {
          REPLICA_URL: $interpolate`s3://${bucket.name}/db`,
          BUCKETNAME: bucket.name,
          AWS_SECRET_ACCESS_KEY: process.env.AWS_SECRET_ACCESS_KEY!,
          AWS_ACCESS_KEY_ID: process.env.AWS_ACCESS_KEY_ID!,
          AWS_REGION: process.env.AWS_REGION!,
          DATABASE_PATH: process.env.DATABASE_PATH!,
          SYSTEM_EMAIL: process.env.SYSTEM_EMAIL!,
          SQS_URL: queue.url,
          SECRET_KEY_BASE: process.env.SECRET_KEY_BASE!,
          PHX_HOST: process.env.PHX_HOST!,
        },
        image: {
          dockerfile: "litestream.Dockerfile",
        },
        link: [bucket],
      });
    }

    const topic = new sst.aws.SnsTopic("ZeroEmailSNS");

    topic.subscribeQueue(queue.arn);

    const configSet = new aws.sesv2.ConfigurationSet("ZeroEmailConfigSet", {
      configurationSetName: "zero_email_events",
    });

    const exampleConfigurationSetEventDestination =
      new aws.sesv2.ConfigurationSetEventDestination("ZeroEmailEvent", {
        configurationSetName: configSet.configurationSetName,
        eventDestinationName: "zero_email_sns",
        eventDestination: {
          snsDestination: {
            topicArn: topic.arn,
          },
          enabled: true,
          matchingEventTypes: [
            "SEND",
            "REJECT",
            "BOUNCE",
            "COMPLAINT",
            "DELIVERY",
            // TODO: Handle all these.
            "OPEN",
            "CLICK",
            "RENDERING_FAILURE",
            "DELIVERY_DELAY",
            "SUBSCRIPTION",
          ],
        },
      });

    const exampleEmailIdentity = new aws.sesv2.EmailIdentity("ZeroEmail", {
      emailIdentity: process.env.EMAIL_IDENTITY || "",
      configurationSetName: configSet.configurationSetName,
    });

    return { queue: queue.url, service: service?.url };
  },
});
